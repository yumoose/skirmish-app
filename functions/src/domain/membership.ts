/* eslint-disable camelcase */
/* eslint-disable no-unused-vars */
import * as admin from "firebase-admin";
import {League} from "./league";
import {Player} from "./player";

export type Membership = {
  id: string,
  player_id: string,
  league_id: string,
  player: Player,
  league: League,
  // eslint-disable-next-line camelcase
  rating: number;
  expires_at?: admin.firestore.Timestamp;
}

export const membershipFromSnapshot = (
    documentSnapshot: admin.firestore.DocumentSnapshot
) => {
  return {
    id: documentSnapshot.id,
    ...documentSnapshot.data(),
  } as Membership;
};
