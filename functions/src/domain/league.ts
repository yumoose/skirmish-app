// eslint-disable-next-line no-unused-vars
import * as admin from "firebase-admin";

export type League = {
  id: string,
  name: string,
  // eslint-disable-next-line camelcase
  initial_rating: number;
}

const DEFAULT_INTIIAL_RATING = 1000;

const LEAGUE_DEFAULTS: Partial<League> = {
  initial_rating: DEFAULT_INTIIAL_RATING,
};

export const leagueFromSnapshot = (
    documentSnapshot: admin.firestore.DocumentSnapshot
) => {
  return {
    id: documentSnapshot.id,
    ...LEAGUE_DEFAULTS,
    ...documentSnapshot.data(),
  } as League;
};
