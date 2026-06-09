/*
 * Copyright (C) 2026 The Android Open Source Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android-base/logging.h>
#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include <cstring>
#include <string>

using android::base::GetProperty;

void OverrideProperty(const char* name, const char* value) {
    prop_info* pi = const_cast<prop_info*>(__system_property_find(name));
    const size_t valuelen = strlen(value);

    if (pi != nullptr) {
        __system_property_update(pi, value, valuelen);
    } else {
        __system_property_add(name, strlen(name), value, valuelen);
    }
}

void vendor_load_properties() {
    const std::string sku = GetProperty("ro.boot.hardware.sku", "");
    const std::string project = GetProperty("ro.boot.project_name", "");
    const std::string board = GetProperty("ro.boot.board_id", "");

    if (!sku.empty() && sku != "NX809J") {
        LOG(INFO) << "NX809J recovery booted with hardware sku: " << sku;
    }
    if (!project.empty()) {
        LOG(INFO) << "NX809J recovery project name: " << project;
    }
    if (!board.empty()) {
        LOG(INFO) << "NX809J recovery board id: " << board;
    }

    OverrideProperty("ro.product.brand", "REDMAGIC");
    OverrideProperty("ro.product.manufacturer", "nubia");
    OverrideProperty("ro.product.device", "NX809J");
    OverrideProperty("ro.product.model", "NX809J");
    OverrideProperty("ro.product.name", "NX809J-UN");

    OverrideProperty("ro.product.system.device", "NX809J");
    OverrideProperty("ro.product.system.model", "NX809J");
    OverrideProperty("ro.product.product.device", "NX809J");
    OverrideProperty("ro.product.product.model", "NX809J");
    OverrideProperty("ro.product.system_ext.device", "NX809J");
    OverrideProperty("ro.product.system_ext.model", "NX809J");
    OverrideProperty("ro.product.vendor.device", "NX809J");
    OverrideProperty("ro.product.vendor.model", "NX809J");
    OverrideProperty("ro.product.odm.device", "NX809J");
    OverrideProperty("ro.product.odm.model", "NX809J");

    OverrideProperty("ro.twrp.device_version", "RedMagic-11-Pro");
    OverrideProperty("ro.build.date.utc", "0");
}
