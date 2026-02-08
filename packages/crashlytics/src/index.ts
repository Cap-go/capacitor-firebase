import { registerPlugin } from '@capacitor/core';

import type { FirebaseCrashlyticsPlugin } from './definitions';

// No-op change to trigger CI release workflow (crashlytics).
const FirebaseCrashlytics = registerPlugin<FirebaseCrashlyticsPlugin>('FirebaseCrashlytics', {
  web: () => import('./web').then((m) => new m.FirebaseCrashlyticsWeb()),
});

export * from './definitions';
export { FirebaseCrashlytics };
