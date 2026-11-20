import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";

import { decideSync, readMarker, writeMarker } from "./upstream-sync-decision.mjs";

const UPSTREAM_A = "599906dded8327acd5995a909edb35c444b5bc0e";
const UPSTREAM_B = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

test("decideSync skips when upstream HEAD matches marker", () => {
  const decision = decideSync({
    lastIntegratedUpstreamSha: UPSTREAM_A,
    upstreamSha: UPSTREAM_A,
  });
  assert.equal(decision.shouldSync, false);
  assert.equal(decision.reason, "upstream_head_matches_last_integrated_marker");
});

test("decideSync runs when upstream HEAD differs from marker", () => {
  const decision = decideSync({
    lastIntegratedUpstreamSha: UPSTREAM_A,
    upstreamSha: UPSTREAM_B,
  });
  assert.equal(decision.shouldSync, true);
  assert.equal(decision.reason, "upstream_head_differs_from_last_integrated_marker");
});

test("decideSync runs when marker is missing", () => {
  const decision = decideSync({
    lastIntegratedUpstreamSha: null,
    upstreamSha: UPSTREAM_A,
  });
  assert.equal(decision.shouldSync, true);
  assert.equal(decision.reason, "no_last_integrated_marker");
});

test("writeMarker persists SHA for squash merges", () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "upstream-sync-"));
  const markerPath = path.join(dir, "upstream-sync.json");
  writeMarker(markerPath, {
    upstreamSha: UPSTREAM_B,
    upstreamRepo: "capawesome-team/capacitor-firebase",
    upstreamBranch: "main",
  });
  const marker = readMarker(markerPath);
  assert.equal(marker.lastIntegratedUpstreamSha, UPSTREAM_B);
});