import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as common from './common';

export const subscribeToMessagesTopic = _fcmToken().onCreate(
  (snapshot, context) => {
    return admin.messaging().subscribeToTopic(snapshot.id, common.messagesTopicName);
  },
);

export const unsubscribeFromMessagesTopic = _fcmToken().onDelete(
  (snapshot, context) => {
    return admin.messaging().unsubscribeFromTopic(snapshot.id, common.messagesTopicName);
  },
);

function _fcmToken() {
  return functions.region(common.region)
    .firestore.document('/users/{userId}/fcmTokens/{fcmToken}');
}
