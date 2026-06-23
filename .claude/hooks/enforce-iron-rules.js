#!/usr/bin/env node
/**
 * PreToolUse Hook: 铁律提醒（方案先行 #1 + Linus 三问 #9）
 *
 * Trigger: first code file edit per session (deduped with flag file)
 * Action: check for specs/tasks.md, output stderr reminder (non-blocking)
 * Exclude: json/yaml/md/config files, test/spec files, .claude/.agent dirs
 */

const fs = require('fs');
const path = require('path');

const FLAG_DIR = path.join(process.env.TMPDIR || '/tmp', 'claude-iron-rules');
const projectKey = (process.env.CLAUDE_PROJECT_DIR || process.cwd()).replace(/[^a-zA-Z0-9]/g, '_');
const FLAG_FILE = path.join(FLAG_DIR, `session-${projectKey}`);
const SESSION_WINDOW_MS = 600000; // 10 分钟内视为同一 session

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

    // 排除非代码文件
    if (/\.(json|yaml|yml|toml|lock|md|csv|svg|txt|css|scss|less)$/.test(filePath)) {
      process.stdout.write(input);
      return;
    }

    // 排除测试文件和配置目录
    if (/(test|spec|__tests__|\.claude|\.agent|node_modules|vendor|generated|templates)/.test(filePath)) {
      process.stdout.write(input);
      return;
    }

    // Session 级去重：同一项目 10 分钟内只提醒一次
    try {
      if (fs.existsSync(FLAG_FILE)) {
        const age = Date.now() - fs.statSync(FLAG_FILE).mtimeMs;
        if (age < SESSION_WINDOW_MS) {
          process.stdout.write(input);
          return;
        }
      }
    } catch {}

    // 检查是否存在规划文档
    const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
    const specsDir = path.join(projectDir, 'specs');
    let hasSpecs = false;

    try {
      if (fs.existsSync(specsDir)) {
        const entries = fs.readdirSync(specsDir);
        for (const entry of entries) {
          const tasksFile = path.join(specsDir, entry, 'tasks.md');
          if (fs.existsSync(tasksFile)) {
            hasSpecs = true;
            break;
          }
        }
      }
    } catch {}

    // 写入 flag 文件（后续不再提醒）
    try {
      fs.mkdirSync(FLAG_DIR, { recursive: true });
      fs.writeFileSync(FLAG_FILE, Date.now().toString());
    } catch {}

    // 输出提醒
    if (!hasSpecs) {
      console.error('[Hook] 铁律提醒：方案先行(#1) + Linus三问(#9)');
      console.error('[Hook] 未检测到 specs/*/tasks.md — 确认已完成规划审批再编码');
    } else {
      console.error('[Hook] 铁律提醒：Linus三问(#9) — 编码前确认已输出三问自检');
    }

    process.stdout.write(input);
  });
}

main();
