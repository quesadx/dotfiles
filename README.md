# dotfiles

Minimal and clean configuration files for my Arch/CachyOS setup.

## Environment

- **WM:** [Hyprland](https://hyprland.org/) (Wayland)
- **Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Shell:** [Bash](https://www.gnu.org/software/bash/)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Launcher:** [Fuzzel](https://github.com/davatorium/rofi)
- **Editor:** [Nvim](https://neovim.io/)
- **Font:** JetBrains Mono & Fira Code

## Structure

```text
.
├── hypr/       # Window manager config
├── waybar/     # Status bar styling (CSS/JSON)
├── bash/       # Shell configurations
├── kitty/      # Terminal themes & config
├── scripts/    # Custom utility scripts
└── themes/     # UI/UX themes
```

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/quesadx/dotfiles.git ~/.config/dotfiles
   ```

2. **Install Dependencies:**
   Refer to `dependencies.txt` for the full list of required packages. Pending update for updated list.

3. **Apply Configurations:**
   Symlink the desired folders to your `~/.config` directory.
