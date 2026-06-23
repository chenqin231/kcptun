/**
 * Instinct Loader - Load project-scoped instincts for session context
 *
 * Scans global/ + projects/<name>/ directories, filters by confidence,
 * and returns a compact summary for model context injection.
 */

const fs = require('fs');
const path = require('path');
const {
  getGlobalInstinctsDir,
  getProjectInstinctsDir,
  getProjectName,
  ensureDir
} = require('./utils');

const MIN_CONFIDENCE = 0.7;
const MAX_SUMMARY_LENGTH = 2000;

/**
 * Parse instinct frontmatter from a markdown file
 * @param {string} filePath - Path to .md file
 * @returns {object|null} Parsed instinct with id, trigger, confidence, action
 */
function parseInstinct(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
    if (!fmMatch) return null;

    const fm = fmMatch[1];
    const getId = () => {
      const m = fm.match(/(?:^|\n)id:\s*(.+)/);
      return m ? m[1].trim() : path.basename(filePath, '.md');
    };
    const getField = (name) => {
      const m = fm.match(new RegExp(`(?:^|\\n)${name}:\\s*(.+)`));
      return m ? m[1].trim().replace(/^["']|["']$/g, '') : null;
    };
    const getConfidence = () => {
      const m = fm.match(/(?:^|\n)confidence:\s*([\d.]+)/);
      return m ? parseFloat(m[1]) : 0;
    };

    // Extract first line of ## Action section as summary
    const actionMatch = content.match(/## Action\n+(.+)/);
    const action = actionMatch ? actionMatch[1].trim() : null;

    return {
      id: getId(),
      trigger: getField('trigger'),
      confidence: getConfidence(),
      domain: getField('domain'),
      action,
      path: filePath
    };
  } catch {
    return null;
  }
}

/**
 * Scan a directory for instinct files and parse them
 * @param {string} dir - Directory to scan
 * @returns {Array} Parsed instincts
 */
function scanInstincts(dir) {
  if (!fs.existsSync(dir)) return [];

  try {
    return fs.readdirSync(dir)
      .filter(f => f.endsWith('.md'))
      .map(f => parseInstinct(path.join(dir, f)))
      .filter(Boolean);
  } catch {
    return [];
  }
}

/**
 * Load instincts for the current project
 * @param {object} options
 * @param {string} options.projectName - Override project name detection
 * @param {number} options.minConfidence - Minimum confidence threshold (default 0.7)
 * @param {number} options.maxLength - Maximum summary length in chars (default 2000)
 * @returns {object} { instincts, summary, projectName, counts }
 */
function loadInstincts(options = {}) {
  const projectName = options.projectName || getProjectName();
  const minConfidence = options.minConfidence || MIN_CONFIDENCE;
  const maxLength = options.maxLength || MAX_SUMMARY_LENGTH;

  if (!projectName) {
    return { instincts: [], summary: '', projectName: null, counts: { global: 0, project: 0, loaded: 0 } };
  }

  const globalDir = getGlobalInstinctsDir();
  const projectDir = getProjectInstinctsDir(projectName);

  // Ensure directories exist for future use
  ensureDir(globalDir);
  ensureDir(projectDir);

  const globalInstincts = scanInstincts(globalDir);
  const projectInstincts = scanInstincts(projectDir);
  const all = [...globalInstincts, ...projectInstincts];

  // Filter by confidence and sort descending
  const qualified = all
    .filter(i => i.confidence >= minConfidence)
    .sort((a, b) => b.confidence - a.confidence);

  if (qualified.length === 0) {
    return {
      instincts: [],
      summary: '',
      projectName,
      counts: { global: globalInstincts.length, project: projectInstincts.length, loaded: 0 }
    };
  }

  // Build compact summary, respecting max length
  const lines = [];
  let totalLen = 0;
  const header = `[instincts] 项目 ${projectName} 已学经验（confidence≥${minConfidence}）：`;
  totalLen += header.length + 1;
  lines.push(header);

  for (const inst of qualified) {
    const line = `- [${inst.confidence}] ${inst.id}: ${inst.action || inst.trigger || '(no summary)'}`;
    if (totalLen + line.length + 1 > maxLength) break;
    lines.push(line);
    totalLen += line.length + 1;
  }

  const summary = lines.join('\n');

  return {
    instincts: qualified,
    summary,
    projectName,
    counts: {
      global: globalInstincts.length,
      project: projectInstincts.length,
      loaded: lines.length - 1 // exclude header
    }
  };
}

module.exports = { parseInstinct, scanInstincts, loadInstincts };
