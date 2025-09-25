[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)

Note: This setup is based on and slightly modified from Maxi-gasti’s repo:
https://github.com/Maxi-gasti/My-Linux-Rice-hypr-waybar-eww-# — big thanks to them for the great Waybar and Eww widget!

Use at your own risk: configs and scripts are provided as-is without warranties.

## Hyprland + Waybar + Eww (Wayland Rice)

Opinionated Wayland setup powered by Hyprland, Waybar and Eww. It includes media widgets, quick service toggles, wallpaper controls, and a few handy scripts written for fish shell.

- Waybar preview:
  <br><img width="1600" height="45" alt="Waybar" src="https://github.com/user-attachments/assets/aaf18d67-04f7-4b0c-902f-b0706a1c43cf" />
- Eww preview:
  <br><img width="263" height="483" alt="Eww" style="margin: auto" src="https://github.com/user-attachments/assets/05f63f10-26fa-43c7-9d05-40c350380b22" />

Demo video: https://youtu.be/96BC5EuXEQc?si=sCzbWejNkBqxM-xl

### About

This is a modified variant tailored for:

- Kitty (terminal)
- Fish (shell)
- Wofi (launcher)

Other terminals/launchers will work with small edits in `~/.config/hypr/hyprland.conf` and Waybar `config.jsonc`.

### Highlights

- Hyprland as the compositor/WM (Wayland)
- Waybar with workspace, hardware, media, tray and menu modules
- Eww “Services” window: CPU/RAM/Disk, music panel (art/title/time), quick buttons
- swww-based wallpaper switching via `~/.local/bin/wall` (hotkeys + Eww buttons)
- fish shell scripts for music state, weather, and quick service actions
- Default terminal: kitty; App launcher: wofi

---

## Folder layout

- `~/.config/hypr/` – Hyprland config (`hyprland.conf`)
- `~/.config/waybar/` – Waybar config (`config.jsonc`, `style.css`, icons)
- `~/.config/eww/` – Eww widgets (`eww.yuck`, `eww.scss`, scripts, assets)
- `~/.local/bin/` – Helper scripts (fish)

---

## Dependencies

Core (official repos):

- fish, hyprland, xdg-desktop-portal-hyprland, waybar
- wofi (launcher), kitty (terminal)
- swww (wallpaper daemon)
- pipewire, pipewire-pulse, pavucontrol (audio)
- playerctl (MPRIS), jq (JSON), curl (HTTP)
- dhcpcd (network DHCP client), upower (battery/power)
- noto-fonts, noto-fonts-emoji, ttf-nerd-fonts-symbols, ttf-nerd-fonts-symbols-mono (icons/emojis)

Optional:

- eww (AUR package name is usually `eww-wayland`)
- discord, steam, zen browser, xampp/lampp (if you use those buttons)

One-liner install (Arch):

```bash
sudo pacman -S --needed fish hyprland xdg-desktop-portal-hyprland waybar wofi swww \
	kitty neovim fastfetch pipewire pipewire-pulse pavucontrol playerctl jq curl \
	dhcpcd upower noto-fonts noto-fonts-emoji ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

Eww (Wayland) from AUR, e.g. with yay:

```bash
yay -S eww
```

---

## The `wall` script (wallpapers)

The repo now includes a helper `fish` script at `~/.local/bin/wall` to set wallpapers consistently:

- Expected files: numbers 1..8, zero-padded to 3 digits: `001`, `002`, …, `008`.
- Default directory: `~/Pictures/wallpapers/quick` (override with `WALL_DIR`).
- Supported extensions: jpg, jpeg, png, webp, avif, bmp (case-insensitive).
- Starts the swww daemon if it isn’t running.
- Adds default transition if you don’t provide one: `--transition-type grow` and a random corner `--transition-pos`.

Usage:

```bash
# basic
wall 1          # same as wall 001
wall 003        # use file 003.* from WALL_DIR

# with custom transitions (overrides defaults)
wall 004 --transition-type wipe --transition-pos center

# choose a different folder (fish, persistent universal var)
set -Ux WALL_DIR "$HOME/Pictures/wallpapers/myset"

# or export for current shell only
set -x WALL_DIR "$HOME/Pictures/wallpapers/myset"
```

### Transition examples (swww)

Here are a few ready-to-use transition examples you can pass to `wall`:

```bash
# simple fade
wall 003 --transition-type simple --transition-fps 60 --transition-step 2

# grow from center
wall 004 --transition-type center --transition-fps 60 --transition-step 90

# from edges to center
wall 005 --transition-type outer --transition-fps 60 --transition-step 90

# angled wipe (30°)
wall 006 --transition-type wipe --transition-angle 30 --transition-fps 60 --transition-step 90

# top-to-bottom slide
wall 007 --transition-type top --transition-fps 60 --transition-step 90

# right-to-left slide
wall 008 --transition-type right --transition-fps 60 --transition-step 90

# random transition type
wall 002 --transition-type random --transition-fps 60 --transition-step 90

# random start point (center/outer)
wall 001 --transition-type any --transition-fps 60 --transition-step 90

# with a named position (corner)
wall 005 --transition-type grow --transition-pos bottom-right
```

For the full list of transition types, angle/position options, defaults, and details, see the swww man page:

- https://man.archlinux.org/man/swww-img.1.en

Keybindings (in `~/.config/hypr/hyprland.conf`):

- `SUPER + CTRL + 1..8` → `~/.local/bin/wall 001..008`

Eww integration (in `~/.config/eww/eww.yuck`):

- The Services window has a “Backgrounds” grid (8 buttons) that calls `~/.local/bin/wall 001..008`.

Daemon autostart:

- Hyprland config includes `exec-once = swww init`, so the daemon is ready on login. The `wall` script also safeguards this by starting `swww-daemon` if needed.

If you see “No wallpaper found for 00X in DIR”, ensure a file like `00X.jpg/png/webp/...` exists in `WALL_DIR`.

---

## Configuration you’ll likely change

1. Wallpapers

- Hyprland autostart: `exec-once = swww init`
- Place 8 images named `001`..`008` in `~/Pictures/wallpapers/quick` (or set `WALL_DIR`). Any supported extension works.
- Hotkeys in `hyprland.conf`: `SUPER + CTRL + [1-8]` call the `wall` script for fast changes.
- Eww “Backgrounds” buttons call the same `wall` script.

2. Weather script (`~/.config/waybar/scripts/weather.fish`)

- Uses wttr.in. City is set via `CITY` (currently `Tashkent_Uzbekistan`).
- Example: `curl -s "wttr.in/$CITY?format=%c+%t&lang=ru"` for localized icon+temp output.
- The Waybar weather module `custom/weather` is enabled by default (see `modules-right` and the `custom/weather` block in `config.jsonc`).

3. Terminal & Launcher

- Default terminal: kitty (Waybar modules use `kitty -e ...`).
- Launcher: wofi (`wofi --show drun`).
- You can switch to other apps by editing `~/.config/hypr/hyprland.conf` and Waybar `config.jsonc`.

4. Media & Audio

- Media controls/readout rely on `playerctl` (MPRIS). Works with players exposing MPRIS.
- Audio module in Waybar uses PipeWire via `pipewire-pulse` and `pavucontrol`.

5. Eww “Services”

- Buttons for `dhcpcd` (network client start) and optional XAMPP start/stop.
- If you don’t use XAMPP, remove those buttons or keep them unused.
- The Backgrounds grid uses `~/.local/bin/wall` for 8 presets.

6. Fonts & Icons

- Nerd Fonts symbols are required for the icons used throughout the bar/widgets.

---

## Install on Arch Linux (Wayland + Hyprland)

1. Install required packages

```bash
sudo pacman -S --needed fish hyprland xdg-desktop-portal-hyprland waybar wofi swww \
	kitty neovim fastfetch pipewire pipewire-pulse pavucontrol playerctl jq curl \
	dhcpcd upower noto-fonts noto-fonts-emoji ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

2. (Optional) Install Eww (Wayland) from AUR

```bash
yay -S eww-wayland
```

3. Place configs

- Copy the repository contents into your home: `~/.config/hypr`, `~/.config/waybar`, `~/.config/eww`, `~/.local/bin`.
- Make scripts executable:

```bash
# general scripts (fish)
chmod +x ~/.local/bin/*.fish ~/.config/waybar/scripts/*.fish ~/.config/eww/scripts/*.fish
# the wallpaper helper is named just 'wall' (no .fish suffix)
chmod +x ~/.local/bin/wall
```

4. Start Hyprland session (display manager or TTY), Waybar autostarts from `hyprland.conf`.
5. Make sure wallpapers work

- Run once in a terminal: `swww init` (Hyprland autostarts this too), then switch images with the hotkeys or Eww buttons.

---

## Tips & Troubleshooting

- Missing icons? Make sure Nerd Fonts packages are installed.
- No audio or volume module not reacting? Ensure PipeWire and `pipewire-pulse` are running; check `pavucontrol`.
- Weather empty? Check internet and your `CITY` in `weather.fish`.
- Media info not showing? Use a player that exposes MPRIS (e.g., Spotify, VLC); verify `playerctl status`.
- `wofi` not launching? Install `wofi` and ensure you’re in a Wayland session.
- Want animations for `swww`? Example: `swww img --transition-type grow --transition-fps 60 --transition-step 90 <image>`.
- `wall` errors about missing files? Check `WALL_DIR` and that `001..008` exist with a supported extension (jpg/jpeg/png/webp/avif/bmp).

---

## Notes

- All shell scripts in this repo target fish shell and use `#!/usr/bin/env fish` shebang (including `wall`).
- Paths in the sample configs (like `~/Downloads/wall/...` or `/home/ecty/...`) are examples—adjust for your system.

---

## License

MIT — see [LICENSE](./LICENSE).
