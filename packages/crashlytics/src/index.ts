import { registerPlugin } from '@capacitor/core';

import type { FirebaseCrashlyticsPlugin } from './definitions.js';

// No-op change to trigger CI release workflow (crashlytics).
const FirebaseCrashlytics = registerPlugin<FirebaseCrashlyticsPlugin>(
  'FirebaseCrashlytics',
  {
    web: () => import('./web.js').then(m => new m.FirebaseCrashlyticsWeb()),
  },
);

export * from './definitions.js';
export { FirebaseCrashlytics };
