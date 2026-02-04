# Development Environment Templates

These are flake templates for project-specific development shells.

## Usage

### Starting a new project

```bash
# 1. Create your project directory
mkdir ~/my-new-project
cd ~/my-new-project

# 2. Copy the template you need
cp ~/dotfiles/dev-templates/cpp/flake.nix .
# OR
cp ~/dotfiles/dev-templates/java/flake.nix .
# OR
cp ~/dotfiles/dev-templates/python/flake.nix .
# OR
cp ~/dotfiles/dev-templates/web/flake.nix .

# 3. Enable automatic environment activation
echo "use flake" > .envrc
direnv allow

# That's it! The environment auto-loads when you enter the directory
```

## Available Templates

- **cpp/** - C++ with GCC, CMake, GDB
- **java/** - Java 21 + JavaFX + Maven
- **python/** - Python 3.12 + venv + common packages
- **web/** - Node.js 22 + pnpm + TypeScript

## Manual activation (without direnv)

```bash
# Enter the development shell
nix develop

# Exit the shell
exit
```

## Tips

- Commit `flake.nix` and `flake.lock` to your git repo
- DON'T commit `.direnv/` or `.envrc` (add to .gitignore)
- Customize the flake.nix for each project's specific needs
