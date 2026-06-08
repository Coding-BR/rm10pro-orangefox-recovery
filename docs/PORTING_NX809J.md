# NX809J Port Notes

This tree was converted from an NX789J base to REDMAGIC 11 Pro (`NX809J`) using
a rooted phone connected over ADB. No partition was flashed during extraction.

## Device Data

- Device: REDMAGIC 11 Pro
- Model/codename: `NX809J`
- Product: `NX809J-UN`
- Android: 16
- Platform: `canoe`
- Active slot during extraction: `_b`
- Build fingerprint:
  `REDMAGIC/NX809J-UN/NX809J:16/BQ2A.250705.001-BP2A.250605.031.A3/20260408.075725:user/release-keys`

## Extracted Partitions

The following images were dumped from `/dev/block/bootdevice/by-name` into
`stock/NX809J/images/`:

- `boot_b.img`
- `vendor_boot_b.img`
- `init_boot_b.img`
- `dtbo_b.img`
- `recovery_b.img`
- `vbmeta_b.img`
- `vbmeta_system_b.img`

`prebuilt/kernel` was extracted from `boot_b.img`. `prebuilt/dtbo.img` was
replaced with `dtbo_b.img`.

## Partition Values

- `BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296`
- `BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296`
- `BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600`
- `BOARD_DTBOIMG_PARTITION_SIZE := 75497472`
- `BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608`
- `BOARD_SUPER_PARTITION_SIZE := 19327352832`
- `BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 19323158528`

Dynamic group: `qti_dynamic_partitions`

Logical partitions seen in stock metadata:

- `system`
- `system_ext`
- `product`
- `vendor`
- `vendor_dlkm`
- `odm`
- `system_dlkm`

## Testing Rule

Test only from RAM while this tree is experimental:

```bash
adb reboot bootloader
fastboot boot recovery.img
```

Do not flash to `recovery_a` or `recovery_b` until boot, display, touch, ADB,
and mounts are confirmed.
