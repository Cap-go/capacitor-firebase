import { registerPlugin } from '@capacitor/core';

import type { FirebaseAppCheckPlugin } from './definitions.js';

const FirebaseAppCheck = registerPlugin<FirebaseAppCheckPlugin>('FirebaseAppCheck', {
  web: () => import('./web.js').then((m) => new m.FirebaseAppCheckWeb()),
});

export * from './definitions.js';
export { FirebaseAppCheck };
