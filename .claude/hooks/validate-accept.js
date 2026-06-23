#!/usr/bin/env node

/**
 * Stop Hook: 验证 /accept 命令执行结果的完整性
 *
 * 工作原理：
 * 1. /accept 命令执行时创建 /tmp/claude-accept-pending 标记文件（内含时间戳）
 * 2. 本 Hook 在 AI 尝试停止时检查标记是否存在
 * 3. 如标记存在，验证 progress.json 和 context.md 是否被真正更新
 * 4. 未通过验证 → exit 2（阻止停止，强制 AI 继续完成）
 * 5. /accept 完成后清理标记文件
 */

const fs = require('fs');
const path = require('path');

const MARKER_FILE = '/tmp/claude-accept-pending';
const TIMEOUT_SECONDS = 120;

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
    // 解析失败，静默放行
    console.log(data);
    process.exit(0);
  }

  // 防循环：stop_hook_active 为 true 时直接放行
  if (input.stop_hook_active === true) {
    console.log(data);
    process.exit(0);
  }

  // 检查标记文件是否存在
  if (!fs.existsSync(MARKER_FILE)) {
    // 非 /accept 场景，静默放行
    console.log(data);
    process.exit(0);
  }

  // 读取标记时间戳
  let markerTimestamp;
  try {
    const markerContent = fs.readFileSync(MARKER_FILE, 'utf8').trim();
    markerTimestamp = parseInt(markerContent, 10);
  } catch {
    // 读取失败，清理并放行
    cleanup();
    console.log(data);
    process.exit(0);
  }

  // 检查是否超时（防止标记残留导致永久阻塞）
  const now = Math.floor(Date.now() / 1000);
  if (now - markerTimestamp > TIMEOUT_SECONDS) {
    console.error('[Hook] /accept 标记已超时（>120秒），自动清理并放行');
    cleanup();
    console.log(data);
    process.exit(0);
  }

  // 验证文件是否被真正更新
  const errors = [];
  const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();

  // 验证 1：progress.json 的 updatedAt 是否晚于标记时间
  const progressPath = path.join(projectDir, 'specs', 'progress.json');
  try {
    const progressContent = fs.readFileSync(progressPath, 'utf8');
    const progress = JSON.parse(progressContent);
    const updatedAt = new Date(progress.updatedAt).getTime() / 1000;
    if (updatedAt < markerTimestamp) {
      errors.push('progress.json 的 updatedAt 未更新');
    }
  } catch {
    errors.push('无法读取 progress.json');
  }

  // 验证 2：context.md 的文件修改时间是否晚于标记时间
  try {
    const progressContent = fs.readFileSync(progressPath, 'utf8');
    const progress = JSON.parse(progressContent);
    const contextPath = path.join(projectDir, progress.specsDir, 'context.md');
    if (fs.existsSync(contextPath)) {
      const stats = fs.statSync(contextPath);
      const mtimeSeconds = Math.floor(stats.mtimeMs / 1000);
      if (mtimeSeconds < markerTimestamp) {
        errors.push('context.md 未更新（文件修改时间早于 /accept 开始时间）');
      }
    } else {
      errors.push('context.md 不存在（/accept 应创建此文件）');
    }
  } catch {
    errors.push('无法验证 context.md');
  }

  // 输出结果
  if (errors.length > 0) {
    console.error('[Hook] /accept 验证未通过，以下文件未正确更新：');
    errors.forEach(err => console.error(`  - ${err}`));
    console.error('[Hook] 请补充完成 /accept 的步骤 6 自检清单中的未完成项');
    // exit 2 阻止 AI 停止，强制继续完成
    process.exit(2);
  }

  // 全部通过，清理标记
  cleanup();
  console.log(data);
  process.exit(0);
}

function cleanup() {
  try {
    fs.unlinkSync(MARKER_FILE);
  } catch {
    // 忽略清理错误
  }
}

main().catch(() => {
  // 异常情况下放行，避免阻塞
  console.log('');
  process.exit(0);
});
