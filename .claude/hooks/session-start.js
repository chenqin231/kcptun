#!/usr/bin/env node
/**
 * SessionStart Hook - Load previous context on new session
 *
 * Cross-platform (Windows, macOS, Linux)
 *
 * Runs when a new Claude session starts. Checks for recent session
 * files and notifies Claude of available context to load.
 */

const path = require('path');
const { readFile } = require('fs/promises');
const {
  getSessionsDir,
  getLearnedSkillsDir,
  findFiles,
  ensureDir,
  log
} = require('../lib/utils');
const { getPackageManager, getSelectionPrompt } = require('../lib/package-manager');
const { listAliases } = require('../lib/session-aliases');
const { loadInstincts } = require('../lib/instinct-loader');

async function main() {
  const sessionsDir = getSessionsDir();
  const learnedDir = getLearnedSkillsDir();

  // Ensure directories exist
  ensureDir(sessionsDir);
  ensureDir(learnedDir);

  // Check for progress.json (structured progress tracking)
  const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const progressFile = path.join(projectDir, 'specs', 'progress.json');
  try {
    const raw = await readFile(progressFile, 'utf8');
    const progress = JSON.parse(raw);
    log('[SessionStart] ━━━ 📋 开发进度 ━━━');
    log(`[SessionStart] 需求：${progress.feature}`);
    if (progress.branch) log(`[SessionStart] 分支：${progress.branch}`);
    log(`[SessionStart] 阶段：${progress.stageLabel || progress.stage}`);
    if (progress.currentTask) {
      log(`[SessionStart] 任务：${progress.completedTasks}/${progress.totalTasks} - ${progress.currentTask.title}`);
    }
    const contextFile = path.join(projectDir, progress.specsDir, 'context.md');
    log(`[SessionStart] 上下文：${progress.specsDir}/context.md`);
    log(`[SessionStart] 任务清单：${progress.specsDir}/tasks.md`);
    log('[SessionStart] 💡 请先读取上述文件了解上次进展，再继续开发');
  } catch {
    // progress.json 不存在或解析失败，跳过
  }

  // Check for recent session files (last 7 days)
  // Match both old format (YYYY-MM-DD-session.tmp) and new format (YYYY-MM-DD-shortid-session.tmp)
  const recentSessions = findFiles(sessionsDir, '*-session.tmp', { maxAge: 7 });

  if (recentSessions.length > 0) {
    const latest = recentSessions[0];
    log(`[SessionStart] Found ${recentSessions.length} recent session(s)`);
    log(`[SessionStart] Latest: ${latest.path}`);
  }

  // Check for learned skills
  const learnedSkills = findFiles(learnedDir, '*.md');

  if (learnedSkills.length > 0) {
    log(`[SessionStart] ${learnedSkills.length} learned skill(s) available in ${learnedDir}`);
  }

  // Check for available session aliases
  const aliases = listAliases({ limit: 5 });

  if (aliases.length > 0) {
    const aliasNames = aliases.map(a => a.name).join(', ');
    log(`[SessionStart] ${aliases.length} session alias(es) available: ${aliasNames}`);
    log(`[SessionStart] Use /sessions load <alias> to continue a previous session`);
  }

  // Detect and report package manager
  const pm = getPackageManager();
  log(`[SessionStart] Package manager: ${pm.name} (${pm.source})`);

  // If package manager was detected via fallback, show selection prompt
  if (pm.source === 'fallback' || pm.source === 'default') {
    log('[SessionStart] No package manager preference found.');
    log(getSelectionPrompt());
  }

  // Load project-scoped instincts (learned experience)
  const instinctResult = loadInstincts();
  if (instinctResult.counts.loaded > 0) {
    log(`[SessionStart] ━━━ 🧠 已学经验 ━━━`);
    log(`[SessionStart] 项目: ${instinctResult.projectName} | 全局: ${instinctResult.counts.global} | 项目级: ${instinctResult.counts.project} | 已加载: ${instinctResult.counts.loaded}`);
    // stdout → 注入模型上下文
    console.log(instinctResult.summary);
  } else if (instinctResult.counts.global + instinctResult.counts.project > 0) {
    log(`[SessionStart] 🧠 ${instinctResult.counts.global + instinctResult.counts.project} 条经验未达加载阈值（confidence<0.7）`);
  }

  // 铁律摘要注入（stdout → 模型上下文）
  // .claude/rules/ 文件在 compact 后会重新加载，
  // 但 stdout 输出确保在 compact 过渡期内也有提醒
  console.log('[铁律摘要] 1.方案先行 2.任务拆解>50行 3.防御性交付 4.TDD先测试 5.自进化 6.Worktree隔离 9.Linus三问 10.Subagent策略');

  process.exit(0);
}

main().catch(err => {
  console.error('[SessionStart] Error:', err.message);
  process.exit(0); // Don't block on errors
});
