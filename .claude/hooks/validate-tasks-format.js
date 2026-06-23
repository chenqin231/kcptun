#!/usr/bin/env node

/**
 * PostToolUse Hook: 验证 tasks.md 的 5 要素格式
 *
 * 触发条件：Write 工具写入 specs/<feature>/tasks.md 时
 * 检查每个 Task 区块是否包含 4 个必要关键字：
 *   - 目标
 *   - 具体步骤
 *   - 涉及文件
 *   - 验收标准
 */

const fs = require('fs');

async function main() {
  // 读取 stdin
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

  // 提取文件路径
  const filePath = input.tool_input?.file_path;
  if (!filePath) {
    console.log(data);
    process.exit(0);
  }

  // 读取文件内容
  let content;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch {
    console.log(data);
    process.exit(0);
  }

  // 分割 Task 区块（匹配 #### Task-N 或 ### Task-N 格式）
  const taskRegex = /^#{2,4}\s+Task[- ]?\d+/gm;
  const taskHeaders = [];
  let match;
  while ((match = taskRegex.exec(content)) !== null) {
    taskHeaders.push({ index: match.index, header: match[0] });
  }

  if (taskHeaders.length === 0) {
    // 没有 Task 区块，跳过检查
    console.log(data);
    process.exit(0);
  }

  // 必要要素（支持带/不带 emoji 前缀）
  const requiredElements = [
    { key: '目标', pattern: /\*\*(?:🎯\s*)?目标\*\*/ },
    { key: '具体步骤', pattern: /\*\*(?:📋\s*)?具体步骤\*\*/ },
    { key: '涉及文件', pattern: /\*\*(?:📁\s*)?涉及文件\*\*/ },
    { key: '验收标准', pattern: /\*\*(?:✅\s*)?验收标准\*\*/ }
  ];

  const warnings = [];

  // 检查每个 Task 区块
  for (let i = 0; i < taskHeaders.length; i++) {
    const start = taskHeaders[i].index;
    const end = i + 1 < taskHeaders.length ? taskHeaders[i + 1].index : content.length;
    const taskBlock = content.substring(start, end);
    const taskName = taskHeaders[i].header.trim();

    const missing = [];
    for (const element of requiredElements) {
      if (!element.pattern.test(taskBlock)) {
        missing.push(element.key);
      }
    }

    if (missing.length > 0) {
      warnings.push(`${taskName} 缺少要素：${missing.join('、')}`);
    }
  }

  // 输出警告
  if (warnings.length > 0) {
    console.error('[Hook] tasks.md 格式检查警告：');
    warnings.forEach(w => console.error(`  - ${w}`));
    console.error('[Hook] 每个 Task 应包含：目标、具体步骤、涉及文件、验收标准');
  }

  // 始终透传原始数据（仅警告，不阻止）
  console.log(data);
}

main().catch(() => {
  process.exit(0);
});
