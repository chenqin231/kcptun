#!/usr/bin/env node

/**
 * PostToolUse Hook: 检查编辑/写入后的文件行数
 *
 * 触发条件: Write 或 Edit 工具执行后
 *
 * 行为:
 *   ≤ 300 行: 静默通过
 *   301-500 行: 输出警告（非阻塞）
 *   > 500 行: 阻塞，要求拆分后重试
 *
 * 豁免: .json, .yaml, .yml, .toml, .lock, *test*, *spec*, *.generated.*, templates/
 */

const fs = require('fs');
const path = require('path');

// 豁免文件模式
const EXEMPT_EXTENSIONS = ['.json', '.yaml', '.yml', '.toml', '.lock', '.svg', '.csv'];
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

function countLines(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const lines = content.split('\n');
    // 末尾换行符会产生一个空元素，不计入行数
    return lines[lines.length - 1] === '' ? lines.length - 1 : lines.length;
  } catch {
    return 0;
  }
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
  if (!filePath || !fs.existsSync(filePath)) {
    console.log(data);
    process.exit(0);
  }

  // 豁免检查
  if (isExempt(filePath)) {
    console.log(data);
    process.exit(0);
  }

  const lineCount = countLines(filePath);
  const relPath = path.relative(process.cwd(), filePath);

  if (lineCount > 500) {
    console.error(`[Hook] BLOCKED: ${relPath} 有 ${lineCount} 行，超过 500 行硬上限`);
    console.error('[Hook] 遵循"8️⃣ 模块化设计原则"，必须拆分后重试');
    console.error('[Hook] 拆分维度：按功能领域 > 按层次 > 按依赖方向 > 按变更频率');
    // 输出但标记阻塞
    console.log(data);
    process.exit(2);
  }

  if (lineCount > 300) {
    console.error(`[Hook] WARNING: ${relPath} 有 ${lineCount} 行，超过 300 行警告阈值`);
    console.error('[Hook] 建议拆分为多个模块，保持单文件 ≤ 200 行');
  }

  console.log(data);
  process.exit(0);
}

main().catch(() => {
  console.log('');
  process.exit(0);
});
