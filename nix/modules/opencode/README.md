# OpenCode Skills (Home Manager Managed)

This directory contains OpenCode skills managed **declaratively** by Home
Manager.

## Why Home Manager owns skills

- **Reproducibility** – every machine in the flake gets the exact same skills.
- **No drift** – manually installed skills in `~/.config/opencode/skills` are
  overwritten at every `home-manager switch` or `nixos-rebuild switch`.
- **VCS tracking** – changes to skills are versioned alongside dotfiles.

## Why NOT to install directly into `~/.config/opencode/skills`

Because Home Manager declares
`programs.opencode.skills = ./nix/modules/opencode/skills`, any file placed
directly under `~/.config/opencode/skills` will be **removed** on the next
rebuild. The directory is a Home Manager-managed symlink target.

## Adding a skill manually

```bash
# 1. Create a subdirectory under skills/
mkdir -p nix/modules/opencode/skills/my-skill

# 2. Write SKILL.md
cat > nix/modules/opencode/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Skill description here.
---

Instructions here.
EOF

# 3. Rebuild
sudo nixos-rebuild switch --flake /home/quesadx/dotfiles#thinkpad-x13
```

## Importing npx-based skills

Use the helper script to stage npx-based skills into this directory:

```bash
./nix/modules/opencode/scripts/import-opencode-skill \
  'npx skills add vercel-labs/agent-skills --yes'
```

The script runs the installer in a temp location, discovers SKILL.md files,
and copies them into `nix/modules/opencode/skills/` so Home Manager takes
ownership.

## Rebuild after adding skills

```bash
sudo nixos-rebuild switch --flake /home/quesadx/dotfiles#thinkpad-x13
```

## Verify installed skills

```bash
ls ~/.config/opencode/skills
opencode list skills  # if supported by your opencode version
```
