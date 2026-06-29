# nggezi/skills

My personal AI agent skills manifest.

## Quick Install

Run the install script to install all skills from the manifest:

**Windows PowerShell:**
```powershell
.\install-skills.ps1
```

**Bash (Linux/Mac/WSL):**
```bash
bash install-skills.sh
```

## What are Skills?

Skills are reusable capabilities for AI agents. They extend your agent with specialized knowledge, workflows, and tools.

## Current Skills

| Category | Skill | Description |
|----------|-------|-------------|
| General | find-skills | Search and install new skills from the ecosystem |
| General | skill-creator | Create your own skills |
| General | agent-browser | Browser automation |
| Frontend | frontend-design | Distinctive UI design guidance |
| Frontend | vercel-react-best-practices | React/Vercel best practices |
| Frontend | web-design-guidelines | Web design guidelines |
| Frontend | shadcn | shadcn/ui component library |
| Dev Flow | tdd | Test-driven development |
| Dev Flow | grill-me | Code review and refactoring |
| Dev Flow | improve-codebase-architecture | Improve code architecture |
| Dev Flow | caveman | Code compression, review, commit tools |
| Dev Flow | systematic-debugging | Systematic debugging methodology |

## How It Works

This repo contains a `skills.json` manifest file that lists all skills with their sources. When you run the install script, it reads the manifest and installs the latest versions of each skill from their original sources.

## Updating Skills

To update all skills to their latest versions:

```powershell
# First update the manifest if needed (edit skills.json)
# Then reinstall
.\install-skills.ps1
```

Or use the skills CLI directly:

```bash
npx skills update
```