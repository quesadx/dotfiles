# Agents & Skills for this dotfiles repository

This document maps the repository layout to the small, focused "agents" and "skills" that live in the repo, documents what's present today, and gives guidelines for adding new agents/skills.

**Overview**

- Repository purpose: collection of dotfiles, NixOS configuration, helper scripts, and templates used to provision personal systems.
- Agents / skills: lightweight tools or configuration snippets that automate or assist workflows (e.g. chat agents, shell helpers, templating helpers).

**Existing agents & skills**

- openclaw/skills/caveman.skill
  - Location: openclaw/skills/caveman.skill
  - Purpose: ultra-compressed communication mode (short, token-efficient replies). Useful for constrained channels or terse automation.

**Related helper scripts (not agents, but useful helpers)**
- local/bin/clipboard-fuzzel.sh — clipboard helper used in local workflows
- local/bin/init_swww.sh — swww/wayland wallpaper init helper
- local/bin/waybar_auto_hide — helper for auto-hiding waybar

**Where agents/skills belong**

- Primary skills directory: `openclaw/skills/` — small text-based skill definitions and agent configurations belong here.
- Repo-level scripts and small utilities: `local/bin/` — shell helpers and wrappers.
- Larger automation or generator code (scaffolding, templating): `templates/` and `docs/` (documented usage).

**Conventions & guidelines**

- Name & location: place each skill under `openclaw/skills/` with a clear filename and a short header describing purpose.
- Format: prefer small, focused files. Include a one-paragraph description, expected inputs, and outputs, plus example usage.
- Versioning: keep skills simple and text-based so they can be reviewed with Git. Use conventional commit messages when updating.
- Tests: where feasible, add small smoke-checks or usage examples in `docs/` or adjacent README files.

**Adding a new agent/skill**

1. Create a new file under `openclaw/skills/` named after the skill (e.g. `my-skill.skill`).
2. Add a short header: purpose, usage, and optional example invocation.
3. If the skill requires helper scripts, place them in `local/bin/` and document the dependency in the skill file.
4. Update this `AGENTS.md` to list the new skill (PR description should include rationale and usage examples).

**Documentation & discovery**

- Read the repository README for top-level context.
- See `docs/agent.md` for any repo-specific agent design notes and examples.

**Maintainers / Contact**

- Repo owner: (you). For changes, open a PR with usage examples and tests where appropriate.

---

This file is intentionally concise. If you'd like, I can:

- expand entries with usage examples for each skill,
- add a short template file for new skills,
- or scan files to auto-generate a more detailed inventory.
