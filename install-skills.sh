#!/usr/bin/env bash
# Install all skills from skills.json manifest
# Usage: bash install-skills.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$SCRIPT_DIR/skills.json"

if [ ! -f "$MANIFEST" ]; then
  echo "Error: skills.json not found in $SCRIPT_DIR"
  exit 1
fi

echo "Reading skills from manifest..."

# Parse JSON and install each skill
# Using node to parse JSON since it's more reliable
node -e "
const fs = require('fs');
const { execSync } = require('child_process');

const manifest = JSON.parse(fs.readFileSync('$MANIFEST', 'utf8'));
const skills = manifest.skills || [];

console.log('Found ' + skills.length + ' skills to install');
console.log('');

for (const skill of skills) {
  console.log('Installing: ' + skill);
  try {
    execSync('npx skills add ' + skill + ' -g -y', { stdio: 'inherit' });
    console.log('');
  } catch (error) {
    console.error('Failed to install: ' + skill);
    console.error('');
  }
}

console.log('Done!');
"