// eslint-disable-next-line no-unused-vars
import * as admin from "firebase-admin";

export type Player = {
  id: string,
  name: string,
}

export const playerFromSnapshot = (
    documentSnapshot: admin.firestore.DocumentSnapshot
) => {
  return {
    id: documentSnapshot.id,
    ...documentSnapshot.data(),
  } as Player;
};
