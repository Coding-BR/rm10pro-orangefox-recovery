# TWRP / OrangeFox Recovery - REDMAGIC 11 Pro (NX809J)

Experimental recovery device tree for the REDMAGIC 11 Pro (`NX809J`), generated
from a rooted device running Android 16 / REDMAGIC OS 11.

![Device](https://img.shields.io/badge/Device-REDMAGIC%2011%20Pro-red?style=flat-square)
![Status](https://img.shields.io/badge/Status-Experimental-yellow?style=flat-square)
![Android](https://img.shields.io/badge/Android-16-green?style=flat-square)

## Safety

This tree is not proven booting yet. Test builds from RAM only (`fastboot boot`
if the bootloader allows it). Do not flash test images to `recovery_a` or
`recovery_b` until boot, display, touch, ADB, and partition mounting are
confirmed.

## Device

| Feature | Details |
|---------|---------|
| Device | REDMAGIC 11 Pro |
| Codename | NX809J |
| Product | NX809J-UN |
| Platform | canoe |
| Android | 16 |
| Architecture | arm64 |
| A/B Partitions | Yes |
| Dynamic Partitions | Yes, `qti_dynamic_partitions` |
| Recovery Partition | Yes, `recovery_a` / `recovery_b` |

## Current Status

| Feature | Status |
|---------|--------|
| Build config | Prepared |
| GitHub Actions | Prepared |
| Boot from RAM | Untested |
| Display | Untested |
| Touch | Untested |
| ADB | Untested |
| Decryption | Untested |
| Fastbootd | Untested |
| USB OTG | Untested |

## Source Data

The active slot on the connected phone was `_b`. These files were dumped or read
from the device and used for the port:

- `boot_b.img`
- `vendor_boot_b.img`
- `init_boot_b.img`
- `dtbo_b.img`
- `recovery_b.img`
- `vbmeta_b.img`
- `vbmeta_system_b.img`
- `/vendor/etc/fstab.qcom`
- VINTF manifests from `/vendor`, `/odm`, and `/system`
- Android 16 keystore libraries from `/system/lib64`

Local dumps are kept under `stock/NX809J/` and are ignored by Git.

## Building TWRP With GitHub Actions

Use `.github/workflows/build.yml`.

- `DEVICE_TREE_URL`: leave empty to build this repository
- `DEVICE_PATH`: `nubia/NX809J`
- `DEVICE_NAME`: `NX809J`
- `LUNCH_TARGET`: leave empty, or set `NX809J`
- `BUILD_PARTITION`: `recovery`

The output artifact should be named like:

```text
TWRP-3.7.1-16-NX809J-YYYY-MM-DD.img
```

## Building OrangeFox With GitHub Actions

Use `.github/workflows/build-orangefox.yml`.

Default build target:

```bash
lunch orangefox_NX809J-eng
mka adbd recoveryimage
```

## Manual Build

```bash
git clone https://gitlab.com/OrangeFox/sync.git ~/OrangeFox_sync
cd ~/OrangeFox_sync
./orangefox_sync.sh --branch 14.1 --path ~/fox_14.1

mkdir -p ~/fox_14.1/device/nubia
git clone https://github.com/YOUR_USERNAME/android_device_nubia_NX809J \
  ~/fox_14.1/device/nubia/NX809J

cd ~/fox_14.1
source build/envsetup.sh
lunch orangefox_NX809J-eng
mka adbd recoveryimage
```

Output:

```text
out/target/product/NX809J/recovery.img
```

## Testing

Prefer RAM boot testing only:

```bash
adb reboot bootloader
fastboot boot recovery.img
```

If `fastboot boot` is unsupported on this bootloader, do not flash blindly. Keep a
known-good EDL/stock restore path before any partition write tests.
