#!/bin/bash

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
