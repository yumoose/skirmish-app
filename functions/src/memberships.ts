import * as firebaseFunctions from "firebase-functions";
import * as admin from "firebase-admin";
import {leagueFromSnapshot} from "./domain/league";
import {membershipFromSnapshot} from "./domain/membership";

admin.initializeApp();

const logger = firebaseFunctions.logger;
const functions = firebaseFunctions.region("australia-southeast1");
// https://firebase.google.com/docs/reference/functions/providers_https_#functionserrorcode
const FunctionsError = firebaseFunctions.https.HttpsError;

type JoinLeaguePayload = {
  leagueId: string;
  playerId: string;
}

exports.joinLeague = functions.https
    .onCall(async (data: JoinLeaguePayload) => {
      const {leagueId, playerId} = data;

      if (!leagueId) {
        throw new FunctionsError(
            "invalid-argument",
            "The league ID must be defined"
        );
      }
      if (!playerId) {
        throw new FunctionsError(
            "invalid-argument",
            "The player ID must be defined"
        );
      }
      const db = admin.firestore();

      const playerRef = db.collection("players").doc(playerId);
      const leagueRef = db.collection("leagues").doc(leagueId);

      await db.runTransaction(async (transaction) => {
        const playerDoc = await transaction.get(playerRef);
        if (!playerDoc.exists) {
          throw new FunctionsError(
              "not-found",
              "Couldn't find player"
          );
        }
        const leagueDoc = await transaction.get(leagueRef);
        if (!leagueDoc.exists) {
          throw new FunctionsError(
              "not-found",
              "Couldn't find league"
          );
        }

        const league = leagueFromSnapshot(leagueDoc);

        const membershipQuery = db.collection("memberships")
            .where("league_id", "==", leagueId)
            .where("player_id", "==", playerId);
        const membershipSnapshot = await transaction.get(membershipQuery);

        if (!membershipSnapshot.empty) {
          const membershipDoc = membershipSnapshot.docs[0];
          const membership = membershipFromSnapshot(membershipDoc);

          if (membership.expires_at &&
            membership.expires_at >= admin.firestore.Timestamp.now()) {
            throw new FunctionsError(
                "already-exists",
                "The player is already a member of the league"
            );
          }
        }

        let membershipRef = db.collection("memberships").doc();
        if (membershipSnapshot.empty) {
          transaction.create(membershipRef, {
            player_id: playerId,
            league_id: leagueId,
            joined_at: admin.firestore.Timestamp.now(),
            rating: league.initial_rating,
            player_snapshot: playerDoc.data(),
            league_snapshot: leagueDoc.data(),
          });
        } else {
          membershipRef = membershipSnapshot.docs[0]?.ref;
          transaction.update(membershipRef, {
            expired_at: null,
          });
        }

        return membershipRef;
      }).then(async (membershipRef) => {
        const membershipDoc = await membershipRef.get();
        return membershipDoc;
      });
    });

exports.leaveLeague = functions.https
    .onCall(async (data: JoinLeaguePayload) => {
      const {leagueId, playerId} = data;

      if (!leagueId) {
        throw new FunctionsError(
            "invalid-argument",
            "The league ID must be defined"
        );
      }
      if (!playerId) {
        throw new FunctionsError(
            "invalid-argument",
            "The player ID must be defined"
        );
      }
      const db = admin.firestore();

      const playerRef = db.collection("players").doc(playerId);
      const leagueRef = db.collection("leagues").doc(leagueId);

      await db.runTransaction(async (transaction) => {
        const playerDoc = await transaction.get(playerRef);
        if (!playerDoc.exists) {
          throw new FunctionsError(
              "not-found",
              "Couldn't find player"
          );
        }
        const leagueDoc = await transaction.get(leagueRef);
        if (!leagueDoc.exists) {
          throw new FunctionsError(
              "not-found",
              "Couldn't find league"
          );
        }

        const membershipQuery = db.collection("memberships")
            .where("league_id", "==", leagueId)
            .where("player_id", "==", playerId);
        const membershipsSnapshot = await transaction.get(membershipQuery);

        if (membershipsSnapshot.empty) {
          throw new FunctionsError(
              "failed-precondition",
              "The player is not a member of the league"
          );
        }

        const membershipDoc = membershipsSnapshot.docs[0];
        const membership = membershipFromSnapshot(membershipDoc);
        if (membership.expires_at &&
          membership.expires_at <= admin.firestore.Timestamp.now()) {
          throw new FunctionsError(
              "failed-precondition",
              "The player is not a member of the league"
          );
        }

        const membershipRefs = membershipsSnapshot.docs.map((doc) => doc.ref);
        for (const membershipRef of membershipRefs) {
          transaction.update(membershipRef, {
            expired_at: admin.firestore.Timestamp.now(),
          });
        }

        return membershipRefs[0];
      }).then(async (membershipRef) => {
        const membershipDoc = await membershipRef.get();
        return membershipDoc;
      });
    });

exports.updateMembershipDetailsOnLeagueChange = functions.firestore
    .document("/leagues/{leagueId}").onUpdate(async (change) => {
      const updatedLeagueSnapshot = change.after;
      const db = admin.firestore();

      // Query memberships that need to be updated
      const membershipsSnapshot = await db
          .collection("memberships")
          .where("league_id", "==", updatedLeagueSnapshot.id)
          .get();

      // No work to do
      if (membershipsSnapshot.empty) return;

      db.runTransaction((transaction) => {
        const updatedMembershipIds: string[] = [];
        for (const membershipDoc of membershipsSnapshot.docs) {
          transaction.update(
              membershipDoc.ref,
              {league_snapshot: updatedLeagueSnapshot.data()}
          );

          updatedMembershipIds.push(membershipDoc.ref.id);
        }

        return Promise.resolve(updatedMembershipIds);
      }).then((memberships) => {
        logger.info(
            `Updated league snapshot on ${memberships.length} memberships`,
            memberships
        );
      }).catch((error) => {
        logger.error("Failed to update memberships", error);
      });
    });

exports.updateMembershipDetailsOnPlayerChange = functions.firestore
    .document("/players/{playerId}").onUpdate(async (change) => {
      const updatedPlayerSnapshot = change.after;
      const db = admin.firestore();

      // Query memberships that need to be updated
      const membershipsSnapshot = await db
          .collection("memberships")
          .where("player_id", "==", updatedPlayerSnapshot.id)
          .get();

      // No work to do
      if (membershipsSnapshot.empty) return;

      db.runTransaction((transaction) => {
        const updatedMembershipIds: string[] = [];
        for (const membershipDoc of membershipsSnapshot.docs) {
          transaction.update(
              membershipDoc.ref,
              {player_snapshot: updatedPlayerSnapshot.data()}
          );

          updatedMembershipIds.push(membershipDoc.ref.id);
        }

        return Promise.resolve(updatedMembershipIds);
      }).then((memberships) => {
        logger.info(
            `Updated player snapshot on ${memberships.length} memberships`,
            memberships
        );
      }).catch((error) => {
        logger.error("Failed to update memberships", error);
      });
    });
