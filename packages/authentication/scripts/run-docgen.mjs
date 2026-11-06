#!/usr/bin/env node
/**
 * Docgen reads process.env.npm_package_name for the /// <reference types="...">
 * snippet in generated capacitor.config.ts examples. The monorepo root name is
 * required to match historical README output. Setting env inline is POSIX-only;
 * this wrapper works on Windows cmd.exe and npm/bun script runners.
 */
import { spawnSync } from 'node:child_process';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const pkgRoot = dirname(dirname(fileURLToPath(import.meta.url)));
const require = createRequire(import.meta.url);
const docgenDir = dirname(require.resolve('@capacitor/docgen/package.json'));
const docgenCli = join(docgenDir, 'bin', 'docgen');

process.env.npm_package_name = '@capgo/capacitor-firebase';

const { status, error } = spawnSync(
  process.execPath,
  [docgenCli, ...process.argv.slice(2)],
  {
    cwd: pkgRoot,
    stdio: 'inherit',
    env: process.env,
  },
);

if (error) {
  console.error(error);
  process.exit(1);
}

process.exit(status === null ? 1 : status);
