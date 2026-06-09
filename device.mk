#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nubia/NX809J

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure virtual_ab_ota launch_with_vendor_ramdisk.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp config common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

# API
BOARD_SHIPPING_API_LEVEL := 36
PRODUCT_SHIPPING_API_LEVEL := 36

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
# Required for Android 16 CrashRecovery APEX

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# magiskboot in the TWRP tree is a 4 KiB-page prebuilt. The stock NX809J reports
# 4 KiB pages even though Android 16 advertises a 16 KiB max page size.
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/releasekey

# Required modules
TWRP_REQUIRED_MODULES += \
    prebuilt

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# fstab — copied to both recovery root and vendor ramdisk for first-stage init
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/recovery.fstab:$(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.canoe \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/lib/modules/modules.blocklist:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/modules.blocklist \
    $(DEVICE_PATH)/prebuilt/system/bin/keystore2:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/keystore2 \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore2_aaid.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore2_aaid.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore2_apc_compat.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore2_apc_compat.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkeystore2_crypto.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeystore2_crypto.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libkm_compat_service.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkm_compat_service.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/libbinder_ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libbinder_ndk.so \
    $(DEVICE_PATH)/prebuilt/system/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml

# Init scripts
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc
