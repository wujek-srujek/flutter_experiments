import * as functions from 'firebase-functions';

export const hello = functions.region('europe-west3').https.onCall(
  (data, context) => {
    if (context.app == undefined) {
      functions.logger.error('Unverified app', { structuredData: true });
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Unverified app',
      );
    }

    functions.logger.info('Hello, logs!', { structuredData: true });

    return `Hello @ ${new Date().toISOString()}!`;
  },
);
