#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const DEFAULT_MARKER = ".github/upstream-sync.json";

/**
 * @param {string} filePath
 */
export function readMarker(filePath) {
  const abs = path.resolve(filePath);
  if (!fs.existsSync(abs)) {
    return {
      upstreamRepo: null,
      upstreamBranch: null,
      lastIntegratedUpstreamSha: null,
    };
  }
  const raw = fs.readFileSync(abs, "utf8");
  const data = JSON.parse(raw);
  return {
    upstreamRepo: data.upstreamRepo ?? null,
    upstreamBranch: data.upstreamBranch ?? null,
    lastIntegratedUpstreamSha: data.lastIntegratedUpstreamSha ?? null,
  };
}

/**
 * @param {{ lastIntegratedUpstreamSha: string | null, upstreamSha: string }} input
 */
export function decideSync({ lastIntegratedUpstreamSha, upstreamSha }) {
  const upstream = upstreamSha.trim().toLowerCase();
  if (!/^[0-9a-f]{40}$/.test(upstream)) {
    throw new Error(`Invalid upstream SHA: ${upstreamSha}`);
  }

  const last = (lastIntegratedUpstreamSha ?? "").trim().toLowerCase();
  if (last && last === upstream) {
    return {
      shouldSync: false,
      reason: "upstream_head_matches_last_integrated_marker",
    };
  }

  return {
    shouldSync: true,
    reason: last
      ? "upstream_head_differs_from_last_integrated_marker"
      : "no_last_integrated_marker",
  };
}

/**
 * @param {string} filePath
 * @param {{
 *   upstreamSha: string;
 *   upstreamRepo?: string;
 *   upstreamBranch?: string;
 * }} input
 */
export function writeMarker(filePath, { upstreamSha, upstreamRepo, upstreamBranch }) {
  const upstream = upstreamSha.trim().toLowerCase();
  if (!/^[0-9a-f]{40}$/.test(upstream)) {
    throw new Error(`Invalid upstream SHA: ${upstreamSha}`);
  }

  const abs = path.resolve(filePath);
  const prior = readMarker(abs);
  const payload = {
    upstreamRepo: upstreamRepo ?? prior.upstreamRepo ?? "capawesome-team/capacitor-firebase",
    upstreamBranch: upstreamBranch ?? prior.upstreamBranch ?? "main",
    lastIntegratedUpstreamSha: upstream,
    recordedAt: new Date().toISOString(),
    note: "Updated by sync-upstream workflow when opening an automated sync pull request.",
  };
  fs.mkdirSync(path.dirname(abs), { recursive: true });
  fs.writeFileSync(abs, `${JSON.stringify(payload, null, 2)}\n`, "utf8");
  return payload;
}

function appendGithubOutput(key, value) {
  const out = process.env.GITHUB_OUTPUT;
  if (!out) {
    return;
  }
  fs.appendFileSync(out, `${key}=${value}\n`, "utf8");
}

function printUsage() {
  process.stderr.write(
    "Usage:\n" +
      "  upstream-sync-decision.mjs evaluate --upstream-sha <sha> [--marker-file path]\n" +
      "  upstream-sync-decision.mjs write-marker --upstream-sha <sha> [--marker-file path] [--upstream-repo repo] [--upstream-branch branch]\n",
  );
}

function parseArgs(argv) {
  const command = argv[0];
  const opts = {
    command,
    upstreamSha: null,
    markerFile: DEFAULT_MARKER,
    upstreamRepo: null,
    upstreamBranch: null,
    json: false,
  };

  for (let i = 1; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--upstream-sha") {
      opts.upstreamSha = argv[++i];
    } else if (arg === "--marker-file") {
      opts.markerFile = argv[++i];
    } else if (arg === "--upstream-repo") {
      opts.upstreamRepo = argv[++i];
    } else if (arg === "--upstream-branch") {
      opts.upstreamBranch = argv[++i];
    } else if (arg === "--json") {
      opts.json = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  if (!command || (command !== "evaluate" && command !== "write-marker")) {
    printUsage();
    process.exit(1);
  }
  if (!opts.upstreamSha) {
    throw new Error("--upstream-sha is required");
  }

  return opts;
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  const marker = readMarker(opts.markerFile);

  if (opts.command === "evaluate") {
    const decision = decideSync({
      lastIntegratedUpstreamSha: marker.lastIntegratedUpstreamSha,
      upstreamSha: opts.upstreamSha,
    });
    const result = {
      ...decision,
      upstreamCommit: opts.upstreamSha.trim().toLowerCase(),
      lastIntegratedUpstreamSha: marker.lastIntegratedUpstreamSha,
      markerFile: opts.markerFile,
    };

    if (opts.json) {
      process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
    }

    appendGithubOutput("should_sync", decision.shouldSync ? "true" : "false");
    appendGithubOutput("sync_reason", decision.reason);
    appendGithubOutput("upstream_commit", result.upstreamCommit);
    if (marker.lastIntegratedUpstreamSha) {
      appendGithubOutput("last_integrated_upstream_sha", marker.lastIntegratedUpstreamSha);
    }

    if (!opts.json && !process.env.GITHUB_OUTPUT) {
      process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
    }
    return;
  }

  if (opts.command === "write-marker") {
    const payload = writeMarker(opts.markerFile, {
      upstreamSha: opts.upstreamSha,
      upstreamRepo: opts.upstreamRepo ?? undefined,
      upstreamBranch: opts.upstreamBranch ?? undefined,
    });
    if (opts.json || !process.env.GITHUB_OUTPUT) {
      process.stdout.write(`${JSON.stringify(payload, null, 2)}\n`);
    }
  }
}

if (import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href) {
  try {
    main();
  } catch (err) {
    process.stderr.write(`${err instanceof Error ? err.message : String(err)}\n`);
    process.exit(1);
  }
}