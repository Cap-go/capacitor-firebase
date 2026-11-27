import { registerPlugin } from '@capacitor/core';

import type { FirebaseRemoteConfigPlugin } from './definitions.js';

const FirebaseRemoteConfig = registerPlugin<FirebaseRemoteConfigPlugin>(
  'FirebaseRemoteConfig',
  {
    web: () => import('./web.js').then(m => new m.FirebaseRemoteConfigWeb()),
  },
);

export * from './definitions.js';
export { FirebaseRemoteConfig };
