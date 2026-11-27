import { registerPlugin } from '@capacitor/core';

import type { FirebasePerformancePlugin } from './definitions.js';

const FirebasePerformance = registerPlugin<FirebasePerformancePlugin>(
  'FirebasePerformance',
  {
    web: () => import('./web.js').then(m => new m.FirebasePerformanceWeb()),
  },
);

export * from './definitions.js';
export { FirebasePerformance };
