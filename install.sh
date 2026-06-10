#!/bin/bash

# ╭──────────────────────────────────────────────────────╮
# │          gENiuS Desktop Theme — Installer            │
# │          Rincol Tech Solutions                       │
# │          github.com/RincolTech-Solutions-ltd/        │
# │                  gENiuS-desktop-theme                │
# ╰──────────────────────────────────────────────────────╯

CYAN='\033[0;36m'
PINK='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="gENiuS-Dark"
GTK_THEME_DEST="$HOME/.themes/$THEME_NAME"
CINNAMON_THEME_DEST="$HOME/.themes/$THEME_NAME/cinnamon"
CONKY_DEST="$HOME/.config/conky"
BG_DEST="/usr/share/backgrounds/gENiuS"
FONTS_DEST="$HOME/.local/share/fonts"

banner() {
  echo ""
  echo -e "${CYAN}╭──────────────────────────────────────────────────────╮${RESET}"
  echo -e "${CYAN}│${WHITE}          gENiuS Desktop Theme — Installer            ${CYAN}│${RESET}"
  echo -e "${CYAN}│${PINK}                 Rincol Tech Solutions                ${CYAN}│${RESET}"
  echo -e "${CYAN}╰──────────────────────────────────────────────────────╯${RESET}"
  echo ""
}

step() { echo -e "${CYAN}  ⟳  ${WHITE}$1${RESET}"; }
ok()   { echo -e "${GREEN}  ✓  $1${RESET}"; }
warn() { echo -e "${YELLOW}  ⚠  $1${RESET}"; }
fail() { echo -e "${RED}  ✗  $1${RESET}"; }

banner

# ── 1. Dependencies ──────────────────────────────────────
step "Installing dependencies..."
sudo apt install -y \
  conky-all \
  papirus-icon-theme \
  fonts-jetbrains-mono \
  lightdm-gtk-greeter \
  lightdm-gtk-greeter-settings \
  imagemagick \
  x11-utils \
  dconf-cli 2>&1 | grep -E "(Setting up|already)" | sed 's/^/    /'
ok "Dependencies ready"
echo ""

# ── 2. GTK Theme ─────────────────────────────────────────
step "Installing GTK theme to ~/.themes/$THEME_NAME..."
mkdir -p "$GTK_THEME_DEST/gtk-3.0"
mkdir -p "$GTK_THEME_DEST/gtk-4.0"
mkdir -p "$GTK_THEME_DEST/metacity-1"
cp "$THEME_DIR/gtk-theme/gtk-3.0/gtk.css"       "$GTK_THEME_DEST/gtk-3.0/"
cp "$THEME_DIR/gtk-theme/gtk-4.0/gtk.css"       "$GTK_THEME_DEST/gtk-4.0/"
cp "$THEME_DIR/gtk-theme/metacity-1/metacity-theme-3.xml" "$GTK_THEME_DEST/metacity-1/"
cp "$THEME_DIR/gtk-theme/index.theme"            "$GTK_THEME_DEST/"
ok "GTK theme installed"

# ── 3. Cinnamon Shell Theme ───────────────────────────────
step "Installing Cinnamon shell theme..."
mkdir -p "$CINNAMON_THEME_DEST"
cp "$THEME_DIR/cinnamon-theme/cinnamon.css"  "$CINNAMON_THEME_DEST/"
cp "$THEME_DIR/cinnamon-theme/metadata.json" "$CINNAMON_THEME_DEST/"
ok "Cinnamon shell theme installed"
echo ""

# ── 4. Wallpaper & Assets ─────────────────────────────────
step "Copying wallpaper and icons..."
sudo mkdir -p "$BG_DEST"
sudo cp "$THEME_DIR/wallpapers/gENiuS_wallpaper.jpeg" "$BG_DEST/"
sudo cp "$THEME_DIR/icons/genius_ico.png"             "$BG_DEST/"
ok "Wallpaper and icons copied to /usr/share/backgrounds/gENiuS/"
echo ""

# ── 5. Conky ─────────────────────────────────────────────
step "Installing Conky config..."
mkdir -p "$CONKY_DEST"
cp "$THEME_DIR/conky/genius.conkyrc" "$CONKY_DEST/genius.conkyrc"
# Auto-start Conky on login
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/genius-conky.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=gENiuS Conky
Comment=gENiuS system monitor widget
Exec=conky -c $HOME/.config/conky/genius.conkyrc
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
ok "Conky installed + autostart configured"
echo ""

# ── 6. LightDM Login Theme ────────────────────────────────
step "Applying LightDM login theme..."
sudo cp "$THEME_DIR/lightdm/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf
ok "LightDM theme applied"
echo ""

# ── 7. Apply GTK + Cinnamon Theme via gsettings ───────────
step "Applying GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme        "$THEME_NAME"
gsettings set org.gnome.desktop.interface icon-theme       "Papirus-Dark"
gsettings set org.gnome.desktop.interface font-name        "JetBrains Mono 11"
gsettings set org.gnome.desktop.interface cursor-theme     "Adwaita"
ok "GTK theme applied"

step "Applying Cinnamon shell theme..."
gsettings set org.cinnamon.theme name "$THEME_NAME" 2>/dev/null || warn "Cinnamon shell gsettings failed — apply manually in Themes settings"

step "Applying wallpaper..."
gsettings set org.gnome.desktop.background picture-uri \
  "file:///usr/share/backgrounds/gENiuS/gENiuS_wallpaper.jpeg"
gsettings set org.gnome.desktop.background picture-options "zoom"
ok "Wallpaper applied"
echo ""

# ── 8. Workspace Names ────────────────────────────────────
step "Setting workspace names..."
gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-1 "['<Super>1']" 2>/dev/null
dconf write /org/cinnamon/muffin/workspace-names "['Brain', 'Code', 'Launch', 'Chill']" 2>/dev/null || true
ok "Workspace names: Brain, Code, Launch, Chill"
echo ""

# ── 9. Hot Corners ────────────────────────────────────────
step "Configuring hot corners..."
dconf write /org/cinnamon/overview-corner "['expo:false:false', 'scale:false:false', 'expo:false:false', 'desktop:false:false']" 2>/dev/null || true
ok "Hot corners configured"
echo ""

# ── 10. Launch Conky ─────────────────────────────────────
step "Starting Conky widget..."
pkill conky 2>/dev/null || true
sleep 1
conky -c "$CONKY_DEST/genius.conkyrc" &
ok "Conky running"
echo ""

# ── 11. Reload Cinnamon ──────────────────────────────────
step "Reloading Cinnamon shell..."
nohup bash -c 'sleep 1 && cinnamon --replace &' >/dev/null 2>&1 &
ok "Cinnamon reloading..."
echo ""

echo -e "${CYAN}╭──────────────────────────────────────────────────────╮${RESET}"
echo -e "${CYAN}│${GREEN}           gENiuS Theme — INSTALLED ✓                 ${CYAN}│${RESET}"
echo -e "${CYAN}│                                                      │${RESET}"
echo -e "${CYAN}│${WHITE}  • Dark navy + colorful gENiuS accents               ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  • gENiuS wallpaper active                           ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  • Conky widget on desktop (top-right)               ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  • Workspaces: Brain | Code | Launch | Chill         ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  • JetBrains Mono font system-wide                   ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  • LightDM login screen themed                       ${CYAN}│${RESET}"
echo -e "${CYAN}│                                                      │${RESET}"
echo -e "${CYAN}│${PINK}  To apply shell theme manually if needed:            ${CYAN}│${RESET}"
echo -e "${CYAN}│${WHITE}  Menu → Themes → Window Borders → gENiuS-Dark        ${CYAN}│${RESET}"
echo -e "${CYAN}╰──────────────────────────────────────────────────────╯${RESET}"
echo ""
