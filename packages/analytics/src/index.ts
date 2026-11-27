import { registerPlugin } from '@capacitor/core';

import type { FirebaseAnalyticsPlugin } from './definitions.js';

const FirebaseAnalytics = registerPlugin<FirebaseAnalyticsPlugin>(
  'FirebaseAnalytics',
  {
    web: () => import('./web.js').then(m => new m.FirebaseAnalyticsWeb()),
  },
);

export * from './definitions.js';
export { FirebaseAnalytics };
