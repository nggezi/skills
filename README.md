# nggezi/skills

My personal AI agent skills manifest.

## Quick Install

Run the install script to install all skills:

**Windows PowerShell:**
```powershell
.\install-skills.ps1
```

**Bash (Linux/Mac/WSL):**
```bash
bash install-skills.sh
```

The script will:
1. Install all skills listed in `skills.json` (from public ecosystem)
2. Copy all custom skills from the `custom/` folder

## Repository Structure

```
skills/
├── skills.json              # Public skills manifest
├── install-skills.ps1       # Windows install script
├── install-skills.sh        # Bash install script
├── README.md
├── custom/                  # Your own custom skills (not on public registry)
│   └── add-api-provider/
│       └── SKILL.md
└── evals/                   # (optional) Test cases for skill development
```

## Skills Locations

**Public skills** (installed via `skills.json`):
- Installed to `~/.agents/skills/` using `npx skills add`
- Updated from original sources each time you run the install script

**Custom skills** (in `custom/` folder):
- Copied directly to `~/.agents/skills/`
- You maintain these yourself — they're not on any public registry
- Edit them in this repo and reinstall to update

## Adding/Removing Skills

### Public skills
Edit `skills.json` and add/remove entries from the `skills` array:

```json
{
  "skills": [
    "owner/repo@skill-name"
  ]
}
```

### Custom skills
Add a new folder under `custom/` with a `SKILL.md` file inside. The folder name becomes the skill name.

## What are Skills?

Skills are reusable capabilities for AI agents. They extend your agent with specialized knowledge, workflows, and tools.

## Current Public Skills

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

## Current Custom Skills

| Skill | Description |
|-------|-------------|
| add-api-provider | Add custom API providers to opencode configuration |

## Updating Skills

To update all public skills to their latest versions, just run the install script again:

```powershell
.\install-skills.ps1
```

Or use the skills CLI directly:

```bash
npx skills update
```

Custom skills are updated by editing the files in `custom/` and reinstalling.