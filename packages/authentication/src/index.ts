import { registerPlugin } from '@capacitor/core';

import type { FirebaseAuthenticationPlugin } from './definitions';

// No-op change to trigger CI release workflow (auth).
const FirebaseAuthentication = registerPlugin<FirebaseAuthenticationPlugin>('FirebaseAuthentication', {
  web: () => import('./web').then((m) => new m.FirebaseAuthenticationWeb()),
});

export * from './definitions';
export { FirebaseAuthentication };
