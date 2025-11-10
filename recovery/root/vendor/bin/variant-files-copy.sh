#!/system/bin/sh
# Copy variant files

variant=$(getprop ro.boot.hardware.sku)

cp -rf /vendor/variant/$variant/vendor/* /vendor
chmod -R 755 /vendor/bin/*
resetprop variant.files_copied "1"

echo "Copy variant files copied for $variant." >/tmp/recovery.log

exit 0