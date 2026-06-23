#!/usr/bin/env node

/**
 * PreToolUse Hook: 阻止在 master/main 分支直接编辑代码文件
 *
 * 触发条件: Edit 或 Write 工具执行前
 *
 * 行为:
 *   在 master/main 分支编辑代码文件 → 阻塞，提醒创建 worktree
 *   在 master/main 分支编辑 .md/.json/.yaml/.toml 等配置文件 → 放行
 *   在非 master/main 分支 → 放行
 */

const { execSync } = require('child_process');
const path = require('path');

// 允许在 master 分支直接编辑的文件扩展名
const ALLOWED_EXTENSIONS = [
  '.md', '.json', '.yaml', '.yml', '.toml', '.xml',
  '.txt', '.csv', '.lock', '.gitignore', '.env.example'
];

// 允许在 master 分支直接编辑的路径模式
const ALLOWED_PATHS = [
  /^specs\//,
  /^\.ai-rules\//,
  /^\.specify\//,
  /^\.claude\//,
  /^\.gemini\//,
  /^\.agent\//,
  /^\.github\//,
  /^docs\//,
  /README/i,
  /CLAUDE\.md$/,
  /GEMINI\.md$/,
  /VERSION$/
];

function getCurrentBranch() {
  try {
    return execSync('git rev-parse --abbrev-ref HEAD', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe']
    }).trim();
  } catch {
    return null;
  }
}

function isProtectedBranch(branch) {
  return ['master', 'main'].includes(branch);
}

function isAllowedFile(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  if (ALLOWED_EXTENSIONS.includes(ext)) return true;

  const relPath = path.relative(process.cwd(), filePath);
  return ALLOWED_PATHS.some(pattern => pattern.test(relPath));
}

async function main() {
  let data = '';
  for await (const chunk of process.stdin) {
    data += chunk;
  }

  let input = {};
  try {
    input = JSON.parse(data);
  } catch {
    console.log(data);
    process.exit(0);
  }

  // 双保险：仅处理 Edit/Write 工具（matcher 应已过滤，此处防御性检查）
  const tool = input.tool;
  if (tool !== 'Edit' && tool !== 'Write') {
    console.log(data);
    process.exit(0);
  }

  const filePath = input.tool_input?.file_path;
  if (!filePath) {
    console.log(data);
    process.exit(0);
  }

  const branch = getCurrentBranch();
  if (!branch || !isProtectedBranch(branch)) {
    // 不在保护分支，放行
    console.log(data);
    process.exit(0);
  }

  if (isAllowedFile(filePath)) {
    // 允许编辑的文件类型，放行
    console.log(data);
    process.exit(0);
  }

  const relPath = path.relative(process.cwd(), filePath);
  console.error(`[Hook] BLOCKED: 禁止在 ${branch} 分支直接编辑代码文件: ${relPath}`);
  console.error('[Hook] 遵循"6️⃣ 环境隔离原则"，请先创建 worktree：');
  console.error('[Hook]   git worktree add worktrees/<feature> -b <branch> master');
  console.error('[Hook] 或使用 /speckit.specify 自动创建 worktree');
  process.exit(2);
}

main().catch(() => {
  console.log('');
  process.exit(0);
});
