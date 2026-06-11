# gENiuS Desktop Theme

A custom Cinnamon-based desktop theme for **gEN!u$** — built by [Rincol Tech Solutions](https://github.com/RincolTech-Solutions-ltd).

Deep navy background with a colorful accent system extracted from the gENiuS brand palette.

---

## Requirements

- Linux Mint (any recent version) or Ubuntu 22.04+
- Cinnamon desktop environment
- Internet connection (for package installs)

---

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/RincolTech-Solutions-ltd/gENiuS-desktop-theme.git
```

### 2. Run the installer

```bash
bash gENiuS-desktop-theme/install.sh
```

That's it. The script handles everything automatically:

- Installs all dependencies (Conky, Papirus icons, JetBrains Mono font, etc.)
- Installs the GTK3/4 theme to `~/.themes/gENiuS-Dark`
- Installs the Cinnamon shell theme
- Sets the gENiuS wallpaper
- Deploys the Conky dashboard widget (auto-starts on login)
- Auto-detects your WiFi interface
- Applies the LightDM login screen theme
- Sets workspace names: Brain, Code, Launch, Chill
- Sets up the Matrix screensaver (XScreenSaver `glmatrix`), active after 5 minutes of inactivity

### 3. Apply the shell theme manually (one-time)

After the script finishes, open **Menu → Themes** and set:

| Setting | Value |
|---|---|
| Window borders | gENiuS-Dark |
| Controls | gENiuS-Dark |
| Desktop | gENiuS-Dark |

---

## What's included

| Component | Description |
|---|---|
| GTK3/4 theme | Dark navy windows, cyan borders, colorful buttons |
| Cinnamon shell | Semi-transparent navy panel with cyan glow |
| Conky dashboard | Live system stats — CPU, RAM, disk, network, top 10 processes, 3 time zones |
| Wallpaper | gENiuS brand wallpaper |
| LightDM theme | gENiuS-branded login screen |
| Icons | Papirus-Dark |
| Font | JetBrains Mono |
| Screensaver | Matrix digital rain (XScreenSaver `glmatrix`), 5 min idle timeout |

---

## Color Palette

| Role | Hex |
|---|---|
| Background | `#0D1B3E` |
| Cyan (primary) | `#00D4FF` |
| Pink | `#FF3D9A` |
| Green | `#00E676` |
| Yellow | `#FFD600` |
| Purple | `#C147E9` |

---

## Screensaver

The Matrix digital rain (`glmatrix`) is set as the only screensaver, activating after 5 minutes
of inactivity. To tweak speed, density, color, or effects, open **xscreensaver-settings**.

`Super+L` still locks the screen via Cinnamon as normal — locking and the screensaver are independent.

## Uninstall

```bash
rm -rf ~/.themes/gENiuS-Dark
rm -f ~/.config/conky/genius.conkyrc
rm -f ~/.config/autostart/genius-conky.desktop
rm -f ~/.config/autostart/xscreensaver.desktop
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.background picture-uri
gsettings reset org.cinnamon.desktop.screensaver idle-activation-enabled
```
