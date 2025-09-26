[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)

Note: This setup is based on and slightly modified from Maxi-gasti’s repo:
https://github.com/Maxi-gasti/My-Linux-Rice-hypr-waybar-eww-# — big thanks to them for the great Waybar and Eww widget!

Use at your own risk: configs and scripts are provided as-is without warranties.

# Hyprland + Waybar + Eww (Kitty/Fish/Wofi)

Opinionated Wayland setup powered by Hyprland, Waybar and Eww. It includes media widgets, quick service toggles, wallpaper controls, and a few handy scripts written for fish shell.

- Waybar preview:
  <br><img width="1600" height="45" alt="Waybar" src="https://github.com/user-attachments/assets/aaf18d67-04f7-4b0c-902f-b0706a1c43cf" />
- Eww preview:
  <br><img width="263" height="483" alt="Eww" style="margin: auto" src="https://github.com/user-attachments/assets/05f63f10-26fa-43c7-9d05-40c350380b22" />

Demo video: https://youtu.be/96BC5EuXEQc?si=sCzbWejNkBqxM-xl

## About

This is a tailored setup for:
- Kitty (terminal)
- Fish (shell)
- Wofi (launcher)
- Hyprland (Wayland compositor)
- Waybar, Eww widgets
- swww-based wallpapers with a helper (`wall`) and preview resolver (`wall_path`)

## Highlights

- Waybar with workspace, hardware, media, tray, weather, and menu modules
- Eww “Services” window: CPU/RAM/Disk, music panel (art/title/time), quick buttons
- Wallpapers: 8 presets (001..008) switched via hotkeys and Eww buttons
- fish scripts: music state, weather, service actions
- Default terminal: kitty; launcher: wofi

---

## Folder layout

- `~/.config/hypr/` – Hyprland config (`hyprland.conf`)
- `~/.config/waybar/` – Waybar (`config.jsonc`, `style.css`, icons, scripts)
- `~/.config/eww/` – Eww (`eww.yuck`, `eww.scss`, scripts, assets)
- `~/.local/bin/` – helper scripts (fish), including `wall` and `wall_path`

---

## Dependencies

Core (official repos):

- fish, hyprland, xdg-desktop-portal-hyprland, waybar
- wofi (launcher), kitty (terminal)
- swww (wallpaper daemon)
- pipewire, pipewire-pulse, pavucontrol (audio)
- playerctl (MPRIS), jq (JSON), curl (HTTP)
- wl-clipboard (for wl-copy), grim, slurp, swappy (screenshots)
- dhcpcd (optional service button), upower (battery/power)
- noto-fonts, noto-fonts-emoji, ttf-nerd-fonts-symbols, ttf-nerd-fonts-symbols-mono (icons/emojis)

One-liner install (Arch):

```bash
sudo pacman -S --needed fish hyprland xdg-desktop-portal-hyprland waybar wofi swww \
    kitty neovim fastfetch pipewire pipewire-pulse pavucontrol playerctl jq curl \
    wl-clipboard grim slurp swappy \
    dhcpcd upower noto-fonts noto-fonts-emoji ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

Eww from AUR (Wayland support in your environment is provided by the `eww` package):

```bash
yay -S eww
```

Note: On some systems the package may be called `eww-wayland`. Use the package that matches your setup.

---

## Install

1) Place configs

Copy the repository contents into your home:
- `~/.config/hypr`
- `~/.config/waybar`
- `~/.config/eww`
- `~/.local/bin`

2) Make scripts executable

```bash
chmod +x ~/.local/bin/*.fish ~/.config/waybar/scripts/*.fish ~/.config/eww/scripts/*.fish
chmod +x ~/.local/bin/wall ~/.local/bin/wall_path
```

3) Start Hyprland; Waybar autostarts from `hyprland.conf`.

4) Initialize swww (once)

Hyprland config includes `exec-once = swww init`. The `wall` script also starts `swww-daemon` if needed.

---

## Wallpapers: `wall` and `wall_path`

We use 8 numbered images in `~/Pictures/wallpapers/quick`:

- Expected names: `001..008` (you can pass `1` and it becomes `001`)
- Supported extensions (case-insensitive): jpg, jpeg, png, webp, avif, bmp
- Default directory override via `WALL_DIR`

`wall` — set wallpaper with optional swww transitions. If you don’t pass transitions, defaults are added:
- `--transition-type grow`
- Random corner alias for `--transition-pos` from: `top-left`, `top-right`, `bottom-left`, `bottom-right`

Usage:

```bash
# basic
wall 1           # same as wall 001
wall 003         # use 003.* from WALL_DIR

# custom transitions (override defaults)
wall 004 --transition-type wipe --transition-pos center

# different folder (persistent universal var in fish)
set -Ux WALL_DIR "$HOME/Pictures/wallpapers/myset"

# per-shell only
set -x WALL_DIR "$HOME/Pictures/wallpapers/myset"
```

`wall_path` — print the resolved absolute file path for a given index (001..008), matching any supported extension. Used by Eww to show live previews without hardcoding extensions.

```bash
wall_path 005
# -> /home/you/Pictures/wallpapers/quick/005.png  (for example)
```

Hotkeys (in `~/.config/hypr/hyprland.conf`):

- `SUPER + CTRL + 1..8` → `~/.local/bin/wall 001..008`

Eww integration (`~/.config/eww/eww.yuck`):

- The Backgrounds grid uses `:style "background-image: url('${bgX}');"` where `bgX` is set by `defpoll` calling `~/.local/bin/wall_path 00X`.

---

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

## Waybar notes

- Waybar image path may not expand `~` or `$HOME`. Use a full absolute path and replace `YOUR_USER_NAME` with your user:

```jsonc
"image": {
  "path": "/home/YOUR_USER_NAME/.config/waybar/img/arch.png",
  "size": 18,
  "tooltip": false,
  "on-click": "wofi --show drun",
  "format": ""
}
```

- To show the active window title, enable the Hyprland window module:

```jsonc
"modules-center": ["custom/media", "hyprland/window"],

"hyprland/window": {
  "tooltip": false,
  "max-length": 40,
  "format": "{title}"
}
```

---

## Eww notes

- Music panel uses `playerctl` and `jq`.
- Services buttons call `~/.local/bin/dhcpcd.fish` and `~/.local/bin/xampp*.fish` (optional, require sudo).
- Background previews dynamically resolve actual files (`wall_path`), so no thumbnail maintenance is needed.

---

## Tips & Troubleshooting

- Missing icons? Make sure Nerd Fonts packages are installed.
- No audio or volume module not reacting? Ensure PipeWire and `pipewire-pulse` are running; check `pavucontrol`.
- Weather empty? Check internet and your `CITY` in `weather.fish`.
- Media info not showing? Use a player that exposes MPRIS (e.g., Spotify, VLC); verify `playerctl status`.
- `wofi` not launching? Install `wofi` and ensure you’re in a Wayland session.
- Want animations for `swww`? Example: `swww img --transition-type grow --transition-fps 60 --transition-step 90 <image>`.
- `wall` errors about missing files? Check `WALL_DIR` and that `001..008` exist with a supported extension (jpg/jpeg/png/webp/avif/bmp).
- If hyprland/window shows nothing, the app may not set a title or Waybar’s Hyprland support may be missing.

---

## License

MIT — see [LICENSE](./LICENSE).
