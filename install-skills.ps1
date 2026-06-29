#!/usr/bin/env pwsh
# Install all skills from manifest and custom folder (Windows PowerShell)
# Usage: .\install-skills.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Manifest = Join-Path $ScriptDir "skills.json"
$CustomDir = Join-Path $ScriptDir "custom"
$TargetSkillsDir = "$env:USERPROFILE\.agents\skills"

# Step 1: Install skills from manifest
if (Test-Path $Manifest) {
    Write-Host "Reading skills from manifest..." -ForegroundColor Cyan

    $manifestContent = Get-Content $Manifest -Raw | ConvertFrom-Json
    $skills = $manifestContent.skills

    Write-Host "Found $($skills.Count) skills to install from manifest" -ForegroundColor Green
    Write-Host ""

    foreach ($skill in $skills) {
        Write-Host "Installing: $skill" -ForegroundColor Yellow
        
        try {
            npx skills add $skill -g -y 2>&1 | Out-Null
            Write-Host "  Success!" -ForegroundColor Green
        }
        catch {
            Write-Host "  Failed!" -ForegroundColor Red
        }
        
        Write-Host ""
    }
} else {
    Write-Host "No manifest found, skipping manifest installation" -ForegroundColor Yellow
}

# Step 2: Install custom skills (direct copy)
if (Test-Path $CustomDir) {
    Write-Host "Installing custom skills from ./custom folder..." -ForegroundColor Cyan
    
    $customSkills = Get-ChildItem -Path $CustomDir -Directory
    
    if ($customSkills.Count -eq 0) {
        Write-Host "  No custom skills found" -ForegroundColor Yellow
    } else {
        foreach ($skillDir in $customSkills) {
            $targetPath = Join-Path $TargetSkillsDir $skillDir.Name
            
            Write-Host "  Copying: $($skillDir.Name)" -ForegroundColor Yellow
            
            # Remove existing if present
            if (Test-Path $targetPath) {
                Remove-Item -Path $targetPath -Recurse -Force
            }
            
            # Copy new version
            Copy-Item -Path $skillDir.FullName -Destination $targetPath -Recurse
            
            Write-Host "    Success!" -ForegroundColor Green
        }
    }
} else {
    Write-Host "No custom folder found, skipping custom skills" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "All skills installed!" -ForegroundColor Green