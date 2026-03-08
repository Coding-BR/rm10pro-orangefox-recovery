#!/system/bin/sh
#=================================================
# Auto-set device properties based on hardware SKU
#=================================================
set -e

variant="NX789J"
base_name="RedMagic"
log_file="/tmp/recovery.log"

log() {
    echo "variant-props-override.sh: $1" | tee -a "$log_file"
}

#-------------------------------------------------
# Variant-specific configuration
#-------------------------------------------------
model="$base_name 10 Pro"
resetprop ro.twrp.device_version "RedMagic_10_Pro"
# Default vibrator props (generic)
resetprop ro.odm.mm.vibrator.sys_path "/sys/class/qcom-haptics"

#-------------------------------------------------
# Common configuration
#-------------------------------------------------
echo "$model" >/config/usb_gadget/g1/strings/0x409/product
resetprop vendor.usb.product_string "$model"
mkdir -p /usbotg

#-------------------------------------------------
# Set product & model properties
#-------------------------------------------------
device_props=(
    ro.build.product
    ro.product.device
    ro.product.odm.device
    ro.product.vendor.device
    ro.product.product.device
    ro.product.system_ext.device
    ro.product.system.device
    ro.product.bootimage.device
    ro.product.name
    ro.product.odm.name
    ro.product.vendor.name
    ro.product.product.name
    ro.product.system_ext.name
    ro.product.system.name
)

model_props=(
    ro.product.model
    ro.product.odm.model
    ro.product.vendor.model
    ro.product.product.model
    ro.product.system_ext.model
    ro.product.system.model
)

for prop in "${device_props[@]}"; do
    resetprop "$prop" "$variant"
done

for prop in "${model_props[@]}"; do
    resetprop "$prop" "$model"
done

#-------------------------------------------------
# Done
#-------------------------------------------------
log "Applied variant props for: $model ($variant)"
exit 0
