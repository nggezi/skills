#!/usr/bin/env pwsh
# Install all skills from skills.json manifest (Windows PowerShell)
# Usage: .\install-skills.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Manifest = Join-Path $ScriptDir "skills.json"

if (-not (Test-Path $Manifest)) {
    Write-Error "Error: skills.json not found in $ScriptDir"
    exit 1
}

Write-Host "Reading skills from manifest..." -ForegroundColor Cyan

$manifestContent = Get-Content $Manifest -Raw | ConvertFrom-Json
$skills = $manifestContent.skills

Write-Host "Found $($skills.Count) skills to install" -ForegroundColor Green
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

Write-Host "Done!" -ForegroundColor Green