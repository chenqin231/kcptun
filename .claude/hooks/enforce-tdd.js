#!/usr/bin/env node
/**
 * PreToolUse Hook: TDD 提醒（铁律 #4）
 *
 * 触发：编辑非测试源文件时
 * 行为：检查 git diff --name-only 是否包含对应测试文件变更
 * 去重：每个源文件只提醒一次（session 级标志文件）
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const FLAG_DIR = path.join(process.env.TMPDIR || '/tmp', 'claude-tdd-flags');
const SESSION_WINDOW_MS = 600000; // 10 分钟内视为同一 session

function isTestFile(filePath) {
  return /(test|spec|__tests__|\.test\.|\.spec\.|_test\.go|_test\.py)/i.test(filePath);
}

function isSourceFile(filePath) {
  return /\.(ts|tsx|js|jsx|py|go|rs|java|rb|php|vue|svelte|sh)$/.test(filePath);
}

function main() {
  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
    let data;
    try {
      data = JSON.parse(input);
    } catch {
      process.stdout.write(input);
      return;
    }
    const filePath = data.tool_input?.file_path || '';

    // 只检查源文件，排除测试文件
    if (!isSourceFile(filePath) || isTestFile(filePath)) {
      process.stdout.write(input);
      return;
    }

    // 排除配置目录
    if (/(\.claude|\.agent|node_modules|vendor|generated|templates)/.test(filePath)) {
      process.stdout.write(input);
      return;
    }

    // Session 级去重：每个源文件 10 分钟内只提醒一次
    const flagKey = filePath.replace(/[^a-zA-Z0-9]/g, '_');
    const flagFile = path.join(FLAG_DIR, flagKey);

    try {
      if (fs.existsSync(flagFile)) {
        const age = Date.now() - fs.statSync(flagFile).mtimeMs;
        if (age < SESSION_WINDOW_MS) {
          process.stdout.write(input);
          return;
        }
      }
    } catch {}

    // 检查是否有测试文件变更（tracked + untracked）
    let hasTestChanges = false;
    const cwd = process.env.CLAUDE_PROJECT_DIR || process.cwd();
    const opts = { encoding: 'utf8', cwd, stdio: ['pipe', 'pipe', 'pipe'] };
    try {
      let tracked = '';
      try { tracked = execSync('git diff --name-only HEAD', opts); } catch {}
      let untracked = '';
      try { untracked = execSync('git ls-files --others --exclude-standard', opts); } catch {}
      hasTestChanges = (tracked + '\n' + untracked).split('\n').some(f => isTestFile(f));
    } catch {}

    // 写入 flag 文件
    try {
      fs.mkdirSync(FLAG_DIR, { recursive: true });
      fs.writeFileSync(flagFile, Date.now().toString());
    } catch {}

    if (!hasTestChanges) {
      const basename = path.basename(filePath);
      console.error(`[Hook] TDD 提醒(#4)：编辑 ${basename} 但未检测到测试文件变更`);
      console.error('[Hook] 铁律要求：先写测试 → 确认失败 → 再实现');
    }

    process.stdout.write(input);
  });
}

main();
