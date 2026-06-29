#!/usr/bin/env bash
# Install all skills from manifest and custom folder
# Usage: bash install-skills.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$SCRIPT_DIR/skills.json"
CUSTOM_DIR="$SCRIPT_DIR/custom"
TARGET_DIR="$HOME/.agents/skills"

# Step 1: Install skills from manifest
if [ -f "$MANIFEST" ]; then
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
  "
else
  echo "No manifest found, skipping manifest installation"
fi

# Step 2: Install custom skills (direct copy)
if [ -d "$CUSTOM_DIR" ]; then
  echo "Installing custom skills from ./custom folder..."
  
  custom_skills=$(ls -1 "$CUSTOM_DIR")
  
  if [ -z "$custom_skills" ]; then
    echo "  No custom skills found"
  else
    for skill_dir in $CUSTOM_DIR/*/; do
      skill_name=$(basename "$skill_dir")
      target_path="$TARGET_DIR/$skill_name"
      
      echo "  Copying: $skill_name"
      
      # Remove existing if present
      if [ -d "$target_path" ]; then
        rm -rf "$target_path"
      fi
      
      # Copy new version
      cp -r "$skill_dir" "$target_path"
      
      echo "    Success!"
    done
  fi
else
  echo "No custom folder found, skipping custom skills"
fi

echo ""
echo "All skills installed!"