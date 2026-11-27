import { registerPlugin } from '@capacitor/core';

import type { FirebaseMessagingPlugin } from './definitions.js';

const FirebaseMessaging = registerPlugin<FirebaseMessagingPlugin>(
  'FirebaseMessaging',
  {
    web: () => import('./web.js').then(m => new m.FirebaseMessagingWeb()),
  },
);

export * from './definitions.js';
export { FirebaseMessaging };
