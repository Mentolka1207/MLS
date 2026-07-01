<div align="center">

<!-- Replace with your actual logo -->
<img src="https://placehold.co/200x200/1a3d2b/a8d5b5?text=MLS" alt="MLS Logo" width="200"/>

# Mentolka Linux System

**A minimal, fast Artix-based desktop distribution with runit, XFCE and dark green aesthetics**

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-green.svg)](LICENSE)
[![Based on: Artix Linux](https://img.shields.io/badge/Based%20on-Artix%20Linux-4e9a06)](https://artixlinux.org)
[![Init: runit](https://img.shields.io/badge/Init-runit-1a3d2b)](http://smarden.org/runit/)
[![Desktop: XFCE](https://img.shields.io/badge/Desktop-XFCE-5cb85c)](https://xfce.org)
[![Build: artools](https://img.shields.io/badge/Build-artools-2d6a4f)](https://gitea.artixlinux.org/artix/artools)

</div>

---

## 📥 Download

**Latest release: [v1.0.0](https://github.com/Mentolka1207/MLS/releases/tag/1.0.0)**

| File | Size |
|------|------|
| [artix-mls-runit-20260627-x86_64.iso](https://github.com/Mentolka1207/MLS/releases/download/1.0.0/artix-mls-runit-20260627-x86_64.iso) | 1.85 GB |

All releases: [github.com/Mentolka1207/MLS/releases](https://github.com/Mentolka1207/MLS/releases)

---

## 📸 Screenshots

> _Screenshots will be added after first stable release._

| Desktop | Installer | Terminal |
|--------|-----------|----------|
| ![Desktop placeholder](https://placehold.co/380x240/1a3d2b/a8d5b5?text=XFCE+Desktop) | ![Calamares placeholder](https://placehold.co/380x240/2d6a4f/d8f3dc?text=Calamares+Installer) | ![Terminal placeholder](https://placehold.co/380x240/081c15/95d5b2?text=Terminal) |

---

## 🌿 About

**MLS (Mentolka Linux System)** is a custom Linux distribution built on top of [Artix Linux](https://artixlinux.org) (no systemd). It is assembled with [artools](https://gitea.artixlinux.org/artix/artools) and targets a clean, fast desktop experience out of the box.

### Key properties

- **No systemd** — uses **runit** as init and service manager
- **XFCE** desktop environment — lightweight, stable, configurable
- **Flatpak** support out of the box
- **GRUB** bootloader with UEFI support
- **Calamares** graphical installer
- Dark green visual theme throughout

---

## ✅ System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | x86_64, 1 GHz | x86_64, 2+ GHz |
| RAM | 1 GB | 4 GB |
| Disk | 10 GB | 20 GB |
| Boot | UEFI or BIOS | UEFI |
| GPU | Any with framebuffer | Mesa / proprietary |

---

## 🗂️ Repository Structure

```
MLS/
├── profiles/               # artools build profiles
│   └── mls/
│       ├── Packages-Root   # base packages
│       ├── Packages-Desktop
│       ├── Packages-Live
│       ├── profiledef.sh
│       └── airootfs/       # overlay filesystem
│           ├── etc/
│           │   ├── runit/  # runit service links
│           │   └── calamares/
│           └── usr/
├── branding/               # Calamares branding assets
│   ├── logo.png
│   ├── slide1.png
│   └── branding.desc
├── configs/                # additional config files
│   └── grub/
├── scripts/                # helper build scripts
│   └── build.sh
└── README.md
```

---

## 🔧 Building the ISO

### 1. Prerequisites

Install `artools` on an Artix or Arch Linux host:

```bash
# Artix host (from repos)
sudo pacman -S artools

# Arch host (from AUR)
yay -S artools-git
```

Install required base tools:

```bash
sudo pacman -S git squashfs-tools libisoburn dosfstools
```

### 2. Clone this repository

```bash
git clone https://github.com/Mentolka1207/MLS.git
cd MLS
```

### 3. Configure artools

Edit `/etc/artools/artools.conf` — set compression level to avoid memory issues:

```bash
# /etc/artools/artools.conf
COMPRESSION_OPTION=(-comp zstd -Xcompression-level 5)
```

Copy the profile into artools work directory:

```bash
sudo cp -r profiles/mls /usr/share/artools/iso-profiles/
```

### 4. Build the ISO

```bash
sudo buildiso -p mls -v
```

The finished ISO will appear in `/var/cache/artools/iso/`.

### 5. Write to USB

```bash
# Replace /dev/sdX with your USB device
sudo dd if=/var/cache/artools/iso/mls-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

> ⚠️ **Warning:** `dd` will erase all data on the target device. Double-check the device path with `lsblk`.

---

## 📦 Package Highlights

| Category | Packages |
|----------|----------|
| Desktop | `xfce4`, `xfce4-goodies` |
| Display manager | `lightdm`, `lightdm-gtk-greeter` |
| Init | `runit`, `runit-rc`, `runit-backports-openrc` |
| Networking | `networkmanager`, `nm-connection-editor` |
| Flatpak | `flatpak`, `xdg-desktop-portal-gtk` |
| Bootloader | `grub`, `efibootmgr`, `os-prober` |
| Installer | `calamares` |
| Browser | `firefox` |
| File manager | `thunar` |

---

## 🚀 Installation

1. Boot from the MLS ISO
2. The **Calamares** installer launches automatically
3. Follow the on-screen steps: language → partitioning → user → install
4. Reboot and enjoy

---

## 🤝 Contributing

Pull requests are welcome. For major changes please open an issue first.

1. Fork the repo
2. Create your branch: `git checkout -b feature/my-feature`
3. Commit: `git commit -m 'Add my feature'`
4. Push: `git push origin feature/my-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0** — see [LICENSE](LICENSE) for details.

---

<div align="center">
  Made with 🌿 by <a href="https://github.com/Mentolka1207">Mentolka1207</a>
</div>
