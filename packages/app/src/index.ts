import { registerPlugin } from '@capacitor/core';

import type { FirebaseAppPlugin } from './definitions.js';

const FirebaseApp = registerPlugin<FirebaseAppPlugin>('FirebaseApp', {
  web: () => import('./web.js').then(m => new m.FirebaseAppWeb()),
});

export * from './definitions.js';
export { FirebaseApp };
