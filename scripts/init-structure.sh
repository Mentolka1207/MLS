#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────
# MLS — init-structure.sh
# Создаёт дерево каталогов репозитория Mentolka Linux System
# Запускать из корня репо: bash scripts/init-structure.sh
# ───────────────────────────────────────────────────────────
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "→ Создаём структуру в: $ROOT"

# ── Список каталогов ────────────────────────────────────────
dirs=(
  # artools profile
  "profiles/mls/airootfs/etc/runit/runsvdir/default"
  "profiles/mls/airootfs/etc/calamares/modules"
  "profiles/mls/airootfs/etc/lightdm"
  "profiles/mls/airootfs/etc/NetworkManager/conf.d"
  "profiles/mls/airootfs/etc/skel/.config/xfce4"
  "profiles/mls/airootfs/usr/share/backgrounds/mls"
  "profiles/mls/airootfs/usr/share/icons"
  "profiles/mls/airootfs/usr/bin"

  # Calamares branding
  "branding/mls"

  # GRUB config
  "configs/grub"

  # Build helpers
  "scripts"

  # Documentation
  "docs"
)

for d in "${dirs[@]}"; do
  mkdir -p "$ROOT/$d"
  echo "  ✔ $d"
done

# ── profiledef.sh ───────────────────────────────────────────
cat > "$ROOT/profiles/mls/profiledef.sh" << 'EOF'
#!/usr/bin/env bash
# artools profile definition for MLS
iso_name="mls"
iso_label="MLS_$(date +%Y%m)"
iso_publisher="Mentolka1207 <https://github.com/Mentolka1207/MLS>"
iso_application="Mentolka Linux System"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '5')
EOF
echo "  ✔ profiles/mls/profiledef.sh"

# ── Packages-Root ────────────────────────────────────────────
cat > "$ROOT/profiles/mls/Packages-Root" << 'EOF'
# Base system
base
base-devel
linux
linux-firmware
runit
runit-rc
elogind-runit
NetworkManager
networkmanager-runit
grub
efibootmgr
os-prober
dosfstools
e2fsprogs
EOF
echo "  ✔ profiles/mls/Packages-Root"

# ── Packages-Desktop ─────────────────────────────────────────
cat > "$ROOT/profiles/mls/Packages-Desktop" << 'EOF'
# XFCE desktop
xfce4
xfce4-goodies
lightdm
lightdm-gtk-greeter
lightdm-gtk-greeter-settings

# Flatpak
flatpak
xdg-desktop-portal-gtk

# Apps
firefox
thunar
mousepad
ristretto

# Fonts
noto-fonts
noto-fonts-emoji
ttf-dejavu
EOF
echo "  ✔ profiles/mls/Packages-Desktop"

# ── Packages-Live ─────────────────────────────────────────────
cat > "$ROOT/profiles/mls/Packages-Live" << 'EOF'
# Installer
calamares
calamares-config-mls

# Live utilities
gparted
networkmanager-applet
EOF
echo "  ✔ profiles/mls/Packages-Live"

# ── pacman.conf ───────────────────────────────────────────────
cat > "$ROOT/profiles/mls/pacman.conf" << 'EOF'
[options]
HoldPkg      = pacman glibc
Architecture = auto
CheckSpace
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional

[system]
Include = /etc/pacman.d/mirrorlist-arch

[world]
Include = /etc/pacman.d/mirrorlist-arch

[galaxy]
Include = /etc/pacman.d/mirrorlist-arch

[lib32]
Include = /etc/pacman.d/mirrorlist-arch

[extra]
Include = /etc/pacman.d/mirrorlist-arch
EOF
echo "  ✔ profiles/mls/pacman.conf"

# ── runit: включаем NetworkManager и lightdm ──────────────────
ln -sfn /etc/runit/sv/NetworkManager \
  "$ROOT/profiles/mls/airootfs/etc/runit/runsvdir/default/NetworkManager" 2>/dev/null || true
ln -sfn /etc/runit/sv/lightdm \
  "$ROOT/profiles/mls/airootfs/etc/runit/runsvdir/default/lightdm" 2>/dev/null || true
echo "  ✔ runit symlinks (NetworkManager, lightdm)"

# ── LightDM autologin для live-сессии ────────────────────────
cat > "$ROOT/profiles/mls/airootfs/etc/lightdm/lightdm.conf" << 'EOF'
[Seat:*]
autologin-user=liveuser
autologin-user-timeout=0
user-session=xfce
EOF
echo "  ✔ airootfs/etc/lightdm/lightdm.conf"

# ── NetworkManager: не трогать resolv.conf ────────────────────
cat > "$ROOT/profiles/mls/airootfs/etc/NetworkManager/conf.d/dns.conf" << 'EOF'
[main]
dns=none
EOF
echo "  ✔ airootfs/etc/NetworkManager/conf.d/dns.conf"

# ── GRUB: тема и параметры ────────────────────────────────────
cat > "$ROOT/configs/grub/grub.cfg" << 'EOF'
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Mentolka Linux System"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_TERMINAL_OUTPUT="console"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
EOF
echo "  ✔ configs/grub/grub.cfg"

# ── Calamares branding.desc ───────────────────────────────────
cat > "$ROOT/branding/mls/branding.desc" << 'EOF'
---
componentName: mls

welcomeStyleCalamares: true
welcomeExpandingLogo: true

strings:
    productName:      "Mentolka Linux System"
    shortProductName: "MLS"
    version:          "Rolling"
    shortVersion:     "Rolling"
    versionedName:    "Mentolka Linux System (Rolling)"
    bootloaderEntryName: "MLS"
    productUrl:       "https://github.com/Mentolka1207/MLS"
    supportUrl:       "https://github.com/Mentolka1207/MLS/issues"
    releaseNotesUrl:  "https://github.com/Mentolka1207/MLS/releases"

images:
    productLogo:      "logo.png"
    productIcon:      "logo.png"
    productWelcome:   "slide1.png"

slideshowAPI: 2
slideshow:
    - "slide1.png"
    - "slide2.png"

style:
    sidebarBackground:  "#1a3d2b"
    sidebarText:        "#d8f3dc"
    sidebarTextSelect:  "#ffffff"
    sidebarTextHighlight: "#95d5b2"
EOF
echo "  ✔ branding/mls/branding.desc"

# ── build.sh ──────────────────────────────────────────────────
cat > "$ROOT/scripts/build.sh" << 'EOF'
#!/usr/bin/env bash
# MLS build helper
set -euo pipefail

PROFILE="mls"
ISO_DIR="/var/cache/artools/iso"

echo "[MLS] Копируем профиль..."
sudo cp -r "$(dirname "$0")/../profiles/$PROFILE" /usr/share/artools/iso-profiles/

echo "[MLS] Запускаем buildiso..."
sudo buildiso -p "$PROFILE" -v

echo "[MLS] Готово. ISO в $ISO_DIR:"
ls -lh "$ISO_DIR"/*.iso
EOF
chmod +x "$ROOT/scripts/build.sh"
echo "  ✔ scripts/build.sh"

# ── .gitkeep в пустых каталогах ───────────────────────────────
for d in \
  "profiles/mls/airootfs/usr/share/backgrounds/mls" \
  "profiles/mls/airootfs/usr/share/icons" \
  "profiles/mls/airootfs/etc/skel/.config/xfce4" \
  "branding/mls" \
  "docs"
do
  touch "$ROOT/$d/.gitkeep"
done
echo "  ✔ .gitkeep в пустых каталогах"

echo ""
echo "✅ Структура MLS создана."
echo ""
echo "Следующие шаги:"
echo "  1. Добавь logo.png и slide*.png в branding/mls/"
echo "  2. Отредактируй profiles/mls/Packages-* под нужный набор пакетов"
echo "  3. git add . && git commit -m 'init: repository structure'"
echo "  4. bash scripts/build.sh"
