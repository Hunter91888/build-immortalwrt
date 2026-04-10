#!/bin/bash
# 自动指定目标设备为高通MSM8916 UFI003（粤百讯410）
sed -i 's|^CONFIG_TARGET.*|# CONFIG_TARGET_qualcommax=y\nCONFIG_TARGET_qualcommax_msm8916=y\nCONFIG_TARGET_qualcommax_msm8916_DEVICE_ufi003=y|' .config

# 确保只开ECM，关RNDIS
sed -i '/CONFIG_KERNEL_USB_GADGET_RNDIS/d' .config
echo "# CONFIG_KERNEL_USB_GADGET_RNDIS is not set" >> .config
sed -i '/CONFIG_PACKAGE_kmod-usb-gadget-rndis/d' .config
echo "# CONFIG_PACKAGE_kmod-usb-gadget-rndis is not set" >> .config
# 1. 写入USB Gadget配置，只启用ECM模式
mkdir -p files/etc/config
echo "config gadget
    option vendor_id '0x18d1'
    option product_id '0x4ee2'
    config usb_ether
        option type 'ecm'
        option ifname 'usb0'
" > files/etc/config/usb_gadget

# 2. 彻底禁用RNDIS相关模块，防止Windows识别
mkdir -p files/etc/modules.d
echo "blacklist rndis_usb
blacklist usb_f_rndis
blacklist kmod-usb-net-rndis
" > files/etc/modules.d/99-disable-rndis
