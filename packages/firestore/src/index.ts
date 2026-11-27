import { registerPlugin } from '@capacitor/core';

import { FirebaseFirestoreClient } from './client.js';
import type { FirebaseFirestorePlugin } from './definitions.js';

const plugin = registerPlugin<FirebaseFirestorePlugin>('FirebaseFirestore', {
  web: () => import('./web.js').then(m => new m.FirebaseFirestoreWeb()),
});

const FirebaseFirestore = new FirebaseFirestoreClient(
  plugin,
) as unknown as FirebaseFirestorePlugin;

export * from './definitions.js';
export { FirebaseFirestore };
export { Bytes } from './bytes.js';
export { DocumentReference } from './document-reference.js';
export { FieldValue } from './field-value.js';
export { GeoPoint } from './geopoint.js';
export { Timestamp } from './timestamp.js';
