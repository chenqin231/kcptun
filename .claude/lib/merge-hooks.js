#!/usr/bin/env node
/**
 * settings.json hooks 增量合并工具
 *
 * 以 hook 的 description 为唯一 key，对比 repo 与 target 的 hooks 条目，
 * 执行增量合并（新增 / 更新 / 废弃清理），保留用户自定义 hook。
 *
 * 用法:
 *   node merge-hooks.js <repo-settings> <target-settings> <repo-hooks-dir> [--dry-run]
 *
 * --dry-run: 仅输出 JSON 差异到 stdout，不修改文件
 * 无参数:   执行合并，变更日志输出到 stderr
 */

'use strict';

const fs = require('fs');
const path = require('path');

// 废弃的内联 hook（按 description 标识）。需要时在此添加。
const DEPRECATED_DESCRIPTIONS = [];

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

// 构建 description → {eventType, index, entry} 的映射
function buildHookMap(settings) {
  const map = new Map();
  const hooks = settings.hooks || {};
  for (const eventType of Object.keys(hooks)) {
    const entries = hooks[eventType];
    if (!Array.isArray(entries)) continue;
    entries.forEach((entry, idx) => {
      if (entry.description) {
        map.set(entry.description, { eventType, index: idx, entry });
      }
    });
  }
  return map;
}

// 检查 hook 条目是否引用了 .claude/hooks/*.js 文件
function referencesHookFile(entry) {
  const hooks = entry.hooks || [];
  for (const h of hooks) {
    if (h.command && /\.claude\/hooks\/[^"'\s]+\.js/.test(h.command)) {
      return true;
    }
  }
  return false;
}

// 从 hook 条目中提取引用的 .js 文件名
function extractHookFileName(entry) {
  const hooks = entry.hooks || [];
  for (const h of hooks) {
    if (!h.command) continue;
    const m = h.command.match(/\.claude\/hooks\/([^"'\s]+\.js)/);
    if (m) return m[1];
  }
  return null;
}

function main() {
  const args = process.argv.slice(2);
  const dryRun = args.includes('--dry-run');
  const positional = args.filter(a => a !== '--dry-run');

  if (positional.length < 3) {
    process.stderr.write('用法: merge-hooks.js <repo-settings> <target-settings> <repo-hooks-dir> [--dry-run]\n');
    process.exit(1);
  }

  const [repoSettingsPath, targetSettingsPath, repoHooksDir] = positional;

  const repoSettings = loadJson(repoSettingsPath);
  const targetSettings = loadJson(targetSettingsPath);

  const repoMap = buildHookMap(repoSettings);
  const targetMap = buildHookMap(targetSettings);

  const added = [];
  const updated = [];
  const removed = [];

  // 1. 检查 repo 中的 hook → 新增或更新
  for (const [desc, repoItem] of repoMap) {
    if (targetMap.has(desc)) {
      const targetItem = targetMap.get(desc);
      if (JSON.stringify(repoItem.entry) !== JSON.stringify(targetItem.entry)) {
        updated.push(desc);
      }
    } else {
      added.push(desc);
    }
  }

  // 2. 检查 target 中多出的 hook → 废弃清理或保留
  for (const [desc, targetItem] of targetMap) {
    if (repoMap.has(desc)) continue;

    // 检查是否在废弃列表中
    if (DEPRECATED_DESCRIPTIONS.includes(desc)) {
      removed.push(desc);
      continue;
    }

    // 检查是否引用了已不存在的 hook 文件
    if (referencesHookFile(targetItem.entry)) {
      const fileName = extractHookFileName(targetItem.entry);
      if (fileName && !fs.existsSync(path.join(repoHooksDir, fileName))) {
        removed.push(desc);
        continue;
      }
    }
    // 其余保留（用户自定义）
  }

  // dry-run 模式：输出 JSON 差异
  if (dryRun) {
    process.stdout.write(JSON.stringify({ added, updated, removed }) + '\n');
    return;
  }

  // 无变更时直接退出
  if (added.length === 0 && updated.length === 0 && removed.length === 0) {
    return;
  }

  // 执行合并
  const result = JSON.parse(JSON.stringify(targetSettings));
  if (!result.hooks) result.hooks = {};

  // 新增
  for (const desc of added) {
    const item = repoMap.get(desc);
    if (!result.hooks[item.eventType]) result.hooks[item.eventType] = [];
    result.hooks[item.eventType].push(item.entry);
    process.stderr.write(`[新增] ${desc}\n`);
  }

  // 更新
  for (const desc of updated) {
    const repoItem = repoMap.get(desc);
    const events = result.hooks[repoItem.eventType];
    if (events) {
      const idx = events.findIndex(e => e.description === desc);
      if (idx !== -1) {
        events[idx] = repoItem.entry;
      }
    }
    process.stderr.write(`[更新] ${desc}\n`);
  }

  // 移除
  for (const desc of removed) {
    for (const eventType of Object.keys(result.hooks)) {
      const entries = result.hooks[eventType];
      if (!Array.isArray(entries)) continue;
      const idx = entries.findIndex(e => e.description === desc);
      if (idx !== -1) {
        entries.splice(idx, 1);
        break;
      }
    }
    process.stderr.write(`[移除] ${desc}\n`);
  }

  fs.writeFileSync(targetSettingsPath, JSON.stringify(result, null, 2) + '\n', 'utf8');
  process.stderr.write(`已合并 settings.json hooks（新增 ${added.length} / 更新 ${updated.length} / 移除 ${removed.length}）\n`);
}

main();
