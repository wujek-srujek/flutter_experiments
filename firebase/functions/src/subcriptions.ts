import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const subscribeToMessagesTopic = _fcmToken().onCreate(
  (snapshot, context) => {
    return admin.messaging().subscribeToTopic(snapshot.id, _messagesTopicName);
  },
);

export const unsubscribeFromMessagesTopic = _fcmToken().onDelete(
  (snapshot, context) => {
    return admin.messaging().unsubscribeFromTopic(snapshot.id, _messagesTopicName);
  },
);

function _fcmToken() {
  return functions.region('europe-west3')
    .firestore.document('/users/{userId}/fcmTokens/{fcmToken}');
}

const _messagesTopicName = 'messages';
