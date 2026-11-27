import { registerPlugin } from '@capacitor/core';

import type { FirebaseStoragePlugin } from './definitions.js';

const FirebaseStorage = registerPlugin<FirebaseStoragePlugin>(
  'FirebaseStorage',
  {
    web: () => import('./web.js').then(m => new m.FirebaseStorageWeb()),
  },
);

export * from './definitions.js';
export { FirebaseStorage };
