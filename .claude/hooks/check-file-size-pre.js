#!/usr/bin/env node

/**
 * PreToolUse Hook: 在 Write/Edit 执行前检查文件行数
 *
 * 触发条件: Write 或 Edit 工具执行前
 *
 * Write 工具：直接数 content 的行数
 * Edit 工具：读当前文件行数，已超限则阻止继续编辑
 *
 * 行为:
 *   ≤ 300 行: 静默通过
 *   301-500 行: 输出警告（非阻塞）
 *   > 500 行: 阻塞，要求先拆分
 *
 * 豁免: .json, .yaml, .yml, .toml, .lock, *test*, *spec*, *.generated.*, templates/
 */

const fs = require('fs');
const path = require('path');

const WARN_THRESHOLD = 300;
const BLOCK_THRESHOLD = 500;

const EXEMPT_EXTENSIONS = ['.json', '.yaml', '.yml', '.toml', '.lock', '.svg', '.csv', '.md'];
const EXEMPT_PATTERNS = [
  /[/\\]tests?[/\\]/i,        // test/ or tests/ 目录
  /\.test\./i,                 // .test. 后缀（如 foo.test.ts）
  /\.tests\./i,                // .tests. 后缀
  /_test\./i,                  // _test. 后缀（如 foo_test.go）
  /[/\\]specs?[/\\]/i,        // spec/ or specs/ 目录
  /\.spec\./i,                 // .spec. 后缀（如 foo.spec.ts）
  /\.generated\./,             // 自动生成代码
  /[/\\]templates[/\\]/i,     // templates/ 目录
  /[/\\]node_modules[/\\]/,   // node_modules/
  /[/\\]vendor[/\\]/,         // vendor/
  /\.min\./,                   // 压缩文件
  /[/\\]migrations?[/\\]/i    // migrations/ 目录
];

function isExempt(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  if (EXEMPT_EXTENSIONS.includes(ext)) return true;
  return EXEMPT_PATTERNS.some(pattern => pattern.test(filePath));
}

function countContentLines(content) {
  if (!content) return 0;
  const lines = content.split('\n');
  return lines[lines.length - 1] === '' ? lines.length - 1 : lines.length;
}

function countFileLines(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    return countContentLines(content);
  } catch {
    return 0;
  }
}

function outputBlock(relPath, lineCount, reason) {
  console.error(`[Hook] BLOCKED: ${relPath} ${reason}（${lineCount} 行，硬上限 ${BLOCK_THRESHOLD}）`);
  console.error('[Hook]');
  console.error('[Hook] 请先拆分此文件再继续：');
  console.error('[Hook]   1. 分析文件中有哪些不同职责');
  console.error('[Hook]   2. 按职责拆分为多个文件（每个 ≤ 200 行）');
  console.error('[Hook]   3. 先提交拆分（纯重构），再添加新功能');
  console.error('[Hook]');
  console.error('[Hook] 拆分参考：查看 .agent/rules/modularity.md 和对应语言的 patterns skill');
}

function outputWarn(relPath, lineCount) {
  console.error(`[Hook] WARNING: ${relPath} 已有 ${lineCount} 行（警告阈值 ${WARN_THRESHOLD}）`);
  console.error('[Hook] 建议在添加新代码前评估是否需要拆分');
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
    process.exit(0);
  }

  const tool = input.tool;
  if (tool !== 'Edit' && tool !== 'Write') {
    process.exit(0);
  }

  const filePath = input.tool_input?.file_path;
  if (!filePath) {
    process.exit(0);
  }

  if (isExempt(filePath)) {
    process.exit(0);
  }

  const relPath = path.relative(process.cwd(), filePath);

  if (tool === 'Write') {
    // Write 工具：检查即将写入的内容行数
    const content = input.tool_input?.content || '';
    const lineCount = countContentLines(content);

    if (lineCount > BLOCK_THRESHOLD) {
      outputBlock(relPath, lineCount, '即将写入的内容超过硬上限');
      process.exit(2);
    }

    if (lineCount > WARN_THRESHOLD) {
      outputWarn(relPath, lineCount);
    }
  }

  if (tool === 'Edit') {
    // Edit 工具：检查当前文件已有行数
    if (!fs.existsSync(filePath)) {
      process.exit(0);
    }

    const currentLines = countFileLines(filePath);

    if (currentLines > BLOCK_THRESHOLD) {
      outputBlock(relPath, currentLines, '当前文件已超过硬上限，禁止继续编辑');
      process.exit(2);
    }

    if (currentLines > WARN_THRESHOLD) {
      outputWarn(relPath, currentLines);
    }
  }

  process.exit(0);
}

main().catch(() => {
  process.exit(0);
});
