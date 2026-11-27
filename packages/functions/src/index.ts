import { registerPlugin } from '@capacitor/core';

import type { FirebaseFunctionsPlugin } from './definitions.js';

const FirebaseFunctions = registerPlugin<FirebaseFunctionsPlugin>(
  'FirebaseFunctions',
  {
    web: () => import('./web.js').then(m => new m.FirebaseFunctionsWeb()),
  },
);

export * from './definitions.js';
export { FirebaseFunctions };
