import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as common from './common';

export const publishMessage = functions.region(common.region)
  .firestore.document('/messages/{messageId}').onCreate(
    (snapshot, context) => {
      const data = snapshot.data();
      const message = {
        notification: {
          title: `${data.sentBy} sent a message`,
          body: data.message,
        },
        topic: common.messagesTopicName,
      };

      return admin.messaging().send(message);
    },
  );
