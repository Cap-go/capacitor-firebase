import { registerPlugin } from '@capacitor/core';

import type { FirebaseAuthenticationPlugin } from './definitions.js';

// No-op change to trigger CI release workflow (auth).
const FirebaseAuthentication = registerPlugin<FirebaseAuthenticationPlugin>(
  'FirebaseAuthentication',
  {
    web: () => import('./web.js').then(m => new m.FirebaseAuthenticationWeb()),
  },
);

export * from './definitions.js';
export { FirebaseAuthentication };
