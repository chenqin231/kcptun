#!/usr/bin/env node
/**
 * Stop Hook: 防御性交付提醒（铁律 #3）
 *
 * 触发：Claude 停止响应时
 * 行为：检查是否有未提交的代码变更，提醒 4 件套
 * 防循环：用 flag 文件防止连续触发
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const FLAG_DIR = path.join(process.env.TMPDIR || '/tmp', 'claude-delivery-flags');
const projectKey = (process.env.CLAUDE_PROJECT_DIR || process.cwd()).replace(/[^a-zA-Z0-9]/g, '_');
const FLAG_FILE = path.join(FLAG_DIR, `stop-${projectKey}`);

// 防止连续触发（30 秒内不重复提醒）
const COOLDOWN_MS = 30000;

function hasCodeChanges() {
  const cwd = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const opts = { encoding: 'utf8', cwd, stdio: ['pipe', 'pipe', 'pipe'] };
  const isCode = f =>
    /\.(ts|tsx|js|jsx|py|go|rs|java|rb|php|vue|svelte|sh)$/.test(f) &&
    !/(test|spec|__tests__)/.test(f);

  try {
    // 已追踪文件的变更（staged + unstaged vs HEAD）
    let tracked = '';
    try { tracked = execSync('git diff --name-only HEAD', opts); } catch {}

    // 未追踪的新文件（Claude Write 创建的文件在这里）
    let untracked = '';
    try { untracked = execSync('git ls-files --others --exclude-standard', opts); } catch {}

    return (tracked + '\n' + untracked).split('\n').some(isCode);
  } catch {
    return false;
  }
}

function main() {
  let input = '';
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
    // 冷却期检查
    try {
      if (fs.existsSync(FLAG_FILE)) {
        const lastTime = parseInt(fs.readFileSync(FLAG_FILE, 'utf8'), 10);
        if (Date.now() - lastTime < COOLDOWN_MS) {
          process.stdout.write(input);
          return;
        }
      }
    } catch {}

    if (hasCodeChanges()) {
      console.error('[Hook] 防御性交付提醒(#3)：检测到未提交的代码变更');
      console.error('[Hook] 请确认已附带：1.Bug清单 2.测试清单 3.交付自检 4.实现回顾');

      // 写入冷却标志
      try {
        fs.mkdirSync(FLAG_DIR, { recursive: true });
        fs.writeFileSync(FLAG_FILE, Date.now().toString());
      } catch {}
    }

    process.stdout.write(input);
  });
}

main();
