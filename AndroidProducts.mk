#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/orangefox_NX809J.mk \
    $(LOCAL_DIR)/twrp_NX809J.mk

COMMON_LUNCH_CHOICES := \
    orangefox_NX809J-eng \
    orangefox_NX809J-userdebug \
    twrp_NX809J-eng \
    twrp_NX809J-userdebug \
    twrp_NX809J-aosp_current-eng \
    twrp_NX809J-aosp_current-userdebug

