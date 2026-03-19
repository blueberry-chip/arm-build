# Rockchip RK3588 SoC octa core 4-16GB SoC 1GBe eMMC USB3 SATA WiFi/BT
BOARD_NAME="Mekotronics R58S2"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER="blueberry"
BOOTCONFIG="mekotronics_r58s2-rk3588_defconfig" 
KERNEL_TARGET="vendor"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3588s-blueberry-rp01a-v10.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SOC="rk3588"
IMAGE_PARTITION_TABLE="gpt"


# hciattach
declare -g BLUETOOTH_HCIATTACH_PARAMS="-s 115200 /dev/ttyS9 bcm43xx 115200 noflow nosleep"
enable_extension "bluetooth-hciattach"

export RK_WIFIBT_CHIP=ALL_AP
# Define BT ttySX
export RK_WIFIBT_TTY=ttyS9
export RK_KERNEL_DEFCONFIG=rockchip_linux_defconfig


function post_family_config__uboot_rock5c() {
	display_alert "$BOARD" "Configuring armsom u-boot" "info"
	declare -g BOOTSOURCE='https://github.com/blueberry-chip/armbian-uboot.git'
	declare -g BOOTBRANCH="branch:next-dev-v2024.03_58s2"
	declare -g OVERLAY_PREFIX='rockchip-rk3588'
	declare -g BOOTDELAY=1 # build injects this into u-boot config. we can then get into UMS mode and avoid the whole rockusb/rkdeveloptool thing
}

function post_family_tweaks__r58s2_naming_audios() {
	display_alert "$BOARD" "Renaming r58s2 audios" "info"

	mkdir -p $SDCARD/etc/udev/rules.d/
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI0 Audio"' > $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8316-sound", ENV{SOUND_DESCRIPTION}="ES8316 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules

	return 0
}
