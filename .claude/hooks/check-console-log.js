#!/usr/bin/env node

/**
 * Stop Hook: Check for console.log statements in modified files
 * 
 * This hook runs after each response and checks if any modified
 * JavaScript/TypeScript files contain console.log statements.
 * It provides warnings to help developers remember to remove
 * debug statements before committing.
 */

const { execSync } = require('child_process');
const fs = require('fs');

let data = '';

// 读取 stdin
process.stdin.on('data', chunk => {
  data += chunk;
});

process.stdin.on('end', () => {
  // 解析 stdin JSON，提取 stop_hook_active 字段
  let input = {};
  try {
    input = JSON.parse(data);
  } catch {
    // 解析失败时按原始数据透传
    console.log(data);
    process.exit(0);
  }

  // 防循环：Stop Hook 被再次触发时直接放行
  if (input.stop_hook_active === true) {
    console.log(data);
    process.exit(0);
  }

  try {
    // 检查是否在 git 仓库中
    try {
      execSync('git rev-parse --git-dir', { stdio: 'pipe' });
    } catch {
      console.log(data);
      process.exit(0);
    }

    // 获取已修改文件列表
    const files = execSync('git diff --name-only HEAD', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe']
    })
      .split('\n')
      .filter(f => /\.(ts|tsx|js|jsx)$/.test(f) && fs.existsSync(f));

    let hasConsole = false;

    // 检查每个文件中的 console.log
    for (const file of files) {
      const content = fs.readFileSync(file, 'utf8');
      if (content.includes('console.log')) {
        console.error(`[Hook] WARNING: console.log found in ${file}`);
        hasConsole = true;
      }
    }

    if (hasConsole) {
      console.error('[Hook] Remove console.log statements before committing');
    }
  } catch (_error) {
    // 静默忽略错误
  }

  // 始终透传原始数据
  console.log(data);
});
