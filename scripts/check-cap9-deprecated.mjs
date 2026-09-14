#!/usr/bin/env node
/**
 * Capacitor 9 removed-API guard for native plugin sources.
 *
 * Scans packages/* (Capacitor plugin packages) for symbols removed in Cap 9.
 * Does not flag Cordova SPM product dependencies in Package.swift.
 *
 * Usage:
 *   node scripts/check-cap9-deprecated.mjs
 *   node scripts/check-cap9-deprecated.mjs --dir packages/crashlytics
 */

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const SKIP_DIRS = new Set([
  "node_modules",
  "dist",
  "build",
  ".build",
  ".gradle",
  "Pods",
  "DerivedData",
  ".swiftpm",
  ".git",
]);

const NATIVE_EXTS = new Set([".java", ".kt", ".swift", ".m", ".mm"]);

/** @type {{ id: string, regex: RegExp, hint: string }[]} */
const RULES = [
  {
    id: "plugin-call-hasOption",
    regex: /\.hasOption\s*\(/,
    hint: "Use typed PluginCall/CAPPluginCall accessors instead of hasOption (removed in Cap 9).",
  },
  {
    id: "plugin-call-save",
    regex: /\b(?:call|pluginCall)\.save\s*\(\s*\)/i,
    hint: "Use PluginCall.setKeepAlive(true) instead of save() (removed in Cap 9).",
  },
  {
    id: "plugin-call-isSaved",
    regex: /\.isSaved\s*\(\s*\)/,
    hint: "Use isKeptAlive() instead of isSaved() (removed in Cap 9).",
  },
  {
    id: "plugin-call-isReleased",
    regex: /\.isReleased\s*\(\s*\)/,
    hint: "PluginCall.isReleased() was removed in Cap 9.",
  },
  {
    id: "plugin-getConfigValue",
    regex: /\.getConfigValue\s*\(/,
    hint: "Use getConfig() and PluginConfig typed accessors instead of getConfigValue (removed in Cap 9).",
  },
  {
    id: "android-native-plugin-annotation",
    regex: /@NativePlugin\b/,
    hint: "Use @CapacitorPlugin instead of @NativePlugin (removed in Cap 9).",
  },
  {
    id: "android-capconfig-asset-manager-ctor",
    regex: /\bCapConfig\s*\(\s*[^,]+,\s*[^)]+\)/,
    hint: "CapConfig(AssetManager, JSONObject) was removed in Cap 9.",
  },
  {
    id: "android-https-interceptor-legacy",
    regex: /\bCAPACITOR_HTTPS_INTERCEPTOR_START\b/,
    hint: "Use CAPACITOR_HTTP_INTERCEPTOR_START instead (Cap 9).",
  },
  {
    id: "android-message-handler-legacy-ctor",
    regex: /\bMessageHandler\s*\(\s*[^,]+,\s*[^,]+,\s*[^)]+\)/,
    hint: "MessageHandler(Bridge, WebView, Object) was removed in Cap 9.",
  },
  {
    id: "ios-cap-bridge-class",
    regex: /\bCAPBridge\./,
    hint: "CAPBridge compatibility shims were removed in Cap 9.",
  },
  {
    id: "ios-cap-notifications-enum",
    regex: /\bCAPNotifications\b/,
    hint: "Use Notification.Name.capacitor* constants instead of CAPNotifications (Cap 9).",
  },
  {
    id: "ios-plugin-call-typealiases",
    regex: /\b(?:PluginCallErrorData|PluginResultData|JSResultBody)\b/,
    hint: "Use PluginCallResultData instead of removed Cap 9 typealiases.",
  },
  {
    id: "ios-portable-path-legacy",
    regex: /\bgetPortablePath\s*\(\s*host\s*:/,
    hint: "Use portablePath(fromLocalURL:) on the bridge instead (Cap 9).",
  },
  {
    id: "ios-https-interceptor-legacy",
    regex: /\bhttpsInterceptorStartIdentifier\b/,
    hint: "Use httpInterceptorStartIdentifier instead (Cap 9).",
  },
];

function readText(p) {
  try {
    return fs.readFileSync(p, "utf8");
  } catch {
    return "";
  }
}

function exists(p) {
  try {
    fs.accessSync(p);
    return true;
  } catch {
    return false;
  }
}

function walkFiles(rootDir) {
  const out = [];
  const stack = [rootDir];
  while (stack.length) {
    const dir = stack.pop();
    let entries;
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const e of entries) {
      if (e.isDirectory()) {
        if (SKIP_DIRS.has(e.name)) continue;
        stack.push(path.join(dir, e.name));
        continue;
      }
      if (!e.isFile()) continue;
      const ext = path.extname(e.name);
      if (NATIVE_EXTS.has(ext)) out.push(path.join(dir, e.name));
    }
  }
  out.sort();
  return out;
}

function stripLineComments(line) {
  let out = line;
  const block = out.indexOf("/*");
  if (block >= 0) out = out.slice(0, block);
  const slash = out.indexOf("//");
  if (slash >= 0) out = out.slice(0, slash);
  return out;
}

function isCordovaSpmDependencyLine(line) {
  return (
    /\.product\s*\(\s*name\s*:\s*"Cordova"/.test(line) ||
    /product\s*\(\s*name:\s*"Cordova"/.test(line)
  );
}

function parseArgs(argv) {
  const out = { dirs: [] };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--dir") {
      out.dirs.push(path.resolve(argv[++i] || "."));
      continue;
    }
  }
  return out;
}

function isCapacitorPluginPackage(dir) {
  const pkgPath = path.join(dir, "package.json");
  if (!exists(pkgPath)) return false;
  try {
    const pkg = JSON.parse(readText(pkgPath));
    const cap = typeof pkg.capacitor === "object" && pkg.capacitor ? pkg.capacitor : {};
    return Boolean(cap.android || cap.ios);
  } catch {
    return false;
  }
}

function listPluginPackageDirs(repoRoot) {
  const packagesRoot = path.join(repoRoot, "packages");
  if (!exists(packagesRoot)) return [];
  return fs
    .readdirSync(packagesRoot, { withFileTypes: true })
    .filter((e) => e.isDirectory())
    .map((e) => path.join(packagesRoot, e.name))
    .filter(isCapacitorPluginPackage)
    .sort();
}

function scanFile(filePath) {
  const rel = path.relative(process.cwd(), filePath);
  const isPackageSwift = path.basename(filePath) === "Package.swift";
  const hits = [];
  const lines = readText(filePath).split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];
    if (isPackageSwift && isCordovaSpmDependencyLine(raw)) continue;
    const line = stripLineComments(raw);
    if (!line.trim()) continue;
    for (const rule of RULES) {
      if (rule.regex.test(line)) {
        hits.push({
          file: rel,
          line: i + 1,
          rule: rule.id,
          hint: rule.hint,
          snippet: raw.trim(),
        });
      }
    }
  }
  return hits;
}

function scanPluginDir(pluginDir) {
  const hits = [];
  const roots = [
    path.join(pluginDir, "android"),
    path.join(pluginDir, "ios"),
    path.join(pluginDir, "Package.swift"),
  ].filter((p) => exists(p));

  for (const root of roots) {
    if (root.endsWith("Package.swift")) {
      hits.push(...scanFile(root));
      continue;
    }
    for (const file of walkFiles(root)) {
      hits.push(...scanFile(file));
    }
  }

  const podspecs = fs
    .readdirSync(pluginDir, { withFileTypes: true })
    .filter((e) => e.isFile() && e.name.endsWith(".podspec"))
    .map((e) => path.join(pluginDir, e.name));
  for (const podspec of podspecs) hits.push(...scanFile(podspec));

  return hits;
}

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const args = parseArgs(process.argv);
const pluginDirs = args.dirs.length ? args.dirs : listPluginPackageDirs(repoRoot);

if (!pluginDirs.length) {
  console.error("[cap9-deprecated] ERROR: no Capacitor plugin packages found under packages/*");
  process.exit(2);
}

const allHits = [];
for (const dir of pluginDirs) {
  allHits.push(...scanPluginDir(dir));
}

if (allHits.length) {
  console.error(`[cap9-deprecated] FAIL: ${allHits.length} Capacitor 9 removed API usage(s) found`);
  for (const hit of allHits) {
    console.error(`- ${hit.file}:${hit.line} [${hit.rule}] ${hit.hint}`);
    console.error(`  ${hit.snippet}`);
  }
  process.exit(1);
}

console.log(`[cap9-deprecated] OK (${pluginDirs.length} plugin package(s) scanned)`);
process.exit(0);
