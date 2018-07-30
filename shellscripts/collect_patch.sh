#!/bin/bash
Android_version="8.x"
function usage()
{
    echo "===================================="
    echo "USAGE: "
    echo "    " $0 " [platform] + [project-name] + [Manufacturer name] [Eabi(32/64)] [sdrpmb]"
    echo "    [platform] such as [mt6735] [mt6750] [mt6580] [mt6757] [mt6797] [...]"
    echo "    [Manufacturer name] is under device folder"
    echo "    [project-name] is under Manufacturer name folder"
    echo "    [Eabi] is 32 or 64"
    echo "    [sdrpmb] wether patch sdrpmb"
    echo "===================================="
    return 0
}

function create_dir()
{
    mkdir -p $1
}

function judge_ret()
{
 	if [ $1 -ne 0 ];then
		echo "file not exist"
		exit 1
	fi
	return 0
}

function collect_device_patched_file()
{
    # Projectconfig
    dir="device/${MF_NAME}/${PROJECT_NAME}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/ProjectConfig.mk  ${dir}
	judge_ret $?
	
	# *.rc
    dir="device/mediatek/${PLATFORM}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/factory_init.rc ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/meta_init.rc ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/init.${PLATFORM}.rc ${dir}
	judge_ret $?
    if [ x"${PLATFORM}" == x"mt6763" ];then
        cp -a ${ROOTPATH}/${dir}/ueventd.${PLATFORM}.emmc.rc ${dir}
	    judge_ret $?
    else
        cp -a ${ROOTPATH}/${dir}/ueventd.${PLATFORM}.rc ${dir}
	    judge_ret $?
    fi
    cp -a ${ROOTPATH}/${dir}/device.mk ${dir} 
	judge_ret $?
    
    # sepolicy file    
    if [ x${Android_version}==x"8.x" ];then
        dir="device/mediatek/sepolicy/bsp/non_plat"
    else
        dir="device/mediatek/common/sepolicy/bsp/"
    fi
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/file_contexts ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/property_contexts ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/tkcore_daemon.te ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/untrusted_app.te ${dir} 
	judge_ret $?
}

function collect_cryptofs()
{
    dir="system/vold/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Android.mk ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/cryptfs.c ${dir}
	judge_ret $?
}

function collect_kernel_common_patch()
{
    # tkcore driver
    dir="${KVERSION}/drivers/misc/mediatek/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Kconfig ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/tkcore ${dir}
	judge_ret $?
     
    # spi
    dir="${KVERSION}/drivers/spi/mediatek/${PLATFORM}" 
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/spi.c ${dir}
	judge_ret $?
    
    # emmc
    if [ x"${PLATFORM}" == x"mt6763" ];then
        dir="${KVERSION}/drivers/char/rpmb"
    else
        dir="${KVERSION}/drivers/mmc/host/mediatek/"
    fi
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?
    
    if [ x"${PLATFORM}" == x"mt6763" ];then
        cp -a ${ROOTPATH}/${dir}/rpmb-mtk.c ${dir}    
        judge_ret $?
    else
        cp -a ${ROOTPATH}/${dir}/emmc_rpmb.c ${dir}    
        judge_ret $?
    fi

    if [ x${Android_version} != x"8.x" ];then
        if [ x"PLATFORM" != x"mt6580" ];then
            dir="${KVERSION}/drivers/mmc/host/mediatek/${PLATFORM}/"
            create_dir ${dir}
            cp -a ${ROOTPATH}/${dir}/sd.c ${dir}
        fi
    fi
}

function collect_kernel_configs()
{
    if [ ${EABI} == "64" ];then
        dir="${KVERSION}/arch/arm64/configs/"
    else 
        dir="${KVERSION}/arch/arm/configs/"
    fi
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}_debug_defconfig ${dir}
    judge_ret $?
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}_defconfig ${dir}
    judge_ret $?
}

function collect_dts_configs()
{
    if [ x${Android_version}==x"8.x" ];then
        if [ ${EABI} == "64" ];then
            dir="${KVERSION}/arch/arm64/boot/dts/mediatek/"
        else
            dir="${KVERSION}/arch/arm/boot/dts/mediatek/"
        fi
    else
        if [ ${EABI} == "64" ];then
            dir="${KVERSION}/arch/arm64/boot/dts/"
        else
            dir="${KVERSION}/arch/arm/boot/dts/"
        fi
    fi
    create_dir ${dir}
    if [ x${PLATFORM} == x"mt6735" ];then
        cp -a ${ROOTPATH}/${dir}/${PLATFORM}.dtsi ${dir}
        judge_ret $?
        cp -a ${ROOTPATH}/${dir}/${PLATFORM}m.dtsi ${dir}
        judge_ret $?
    elif [ x${PLATFORM} == x"mt6763" ];then
        cp -a ${ROOTPATH}/${dir}/${PLATFORM}.dts ${dir}
        judge_ret $?
    else
        cp -a ${ROOTPATH}/${dir}/${PLATFORM}.dtsi ${dir}
        #judge_ret $?
        cp -a ${ROOTPATH}/${dir}/${PLATFORM}.dts ${dir}
        #judge_ret $?
    fi
}

function collect_mt6580_kernel()
{
    dir="${KVERSION}/arch/arm/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Kconfig ${dir}
	judge_ret $?
    
    dir="${KVERSION}/arch/arm/configs/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}_debug_defconfig ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}_defconfig ${dir}
	judge_ret $?
    
    dir="${KVERSION}/drivers/misc/mediatek/aee/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Kconfig ${dir}
    judge_ret $?

    dir="${KVERSION}/drivers/misc/mediatek/base/power/cpuidle_v1/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/mt_cpuidle.c ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?

    dir="${KVERSION}/drivers/misc/mediatek/base/power/mt6580/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/hotplug.c ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/mt-smp.c ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?

    dir="${KVERSION}/drivers/misc/mediatek/mach/mt6580/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/ca7_timer.c ${dir}
	judge_ret $?
}

function collect_kernel_patch()
{
    if [ x${PLATFORM} == x"mt6580" ];then
        collect_mt6580_kernel
    else
        collect_kernel_configs
    fi
    collect_kernel_common_patch
    collect_dts_configs 
}

function collect_bootloader_patch()
{
    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?
    
    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${PROJECT_NAME}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/cust_bldr.mak ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}.mak ${dir}
	judge_ret $?

    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader/platform/${PLATFORM}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/default.mak ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/feature.mak ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/makefile.mak ${dir}
	judge_ret $?
   
    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader/platform/${PLATFORM}/src/security/trustzone/inc/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/tz_tkcore.h ${dir}
	judge_ret $?

    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader//platform/${PLATFORM}/src/security/trustzone/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/makefile ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/tz_init.c ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/tz_tkcore.c ${dir} 
	judge_ret $?
    
	dir="vendor/mediatek/proprietary/bootable/bootloader/preloader//platform/${PLATFORM}/src/core/"
	create_dir ${dir}
	cp -a ${ROOTPATH}/${dir}/main.c ${dir}/

    if [ x${PLATFORM} = x"mt6580" ];then
        dir="vendor/mediatek/proprietary/bootable/bootloader/preloader//platform/${PLATFORM}/src/core/"
        cp -a ${ROOTPATH}/${dir}/partition.c ${dir}/
        dir="vendor/mediatek/proprietary/bootable/bootloader/preloader//platform/${PLATFORM}/src/security/"
        cp -a ${ROOTPATH}/${dir}/makefile ${dir}/
    fi 
}

function collect_atf_patch()
{
    dir="vendor/mediatek/proprietary/trustzone/atf/${ATFVERSION}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Makefile ${dir}
	judge_ret $?

    dir="vendor/mediatek/proprietary/trustzone/atf/${ATFVERSION}/include/bl32/tkcore/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/tkcore.h ${dir}
	judge_ret $?
    
    if [ x"${ATFVERSION}" == x"v1.3" ];then
        dir="vendor/mediatek/proprietary/trustzone/atf/${ATFVERSION}/plat/mediatek/${PLATFORM}/"
    else
        dir="vendor/mediatek/proprietary/trustzone/atf/${ATFVERSION}/plat/${PLATFORM}/"
    fi 
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/plat_tkcore.c ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/platform.mk ${dir}
	judge_ret $?
    
    dir="vendor/mediatek/proprietary/trustzone/atf/${ATFVERSION}/services/spd/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/tkcored ${dir}
	judge_ret $?
}

function collect_custom_build_patch()
{
    dir="vendor/mediatek/proprietary/trustzone/custom/build/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Android.mk ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/common_config.mk ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/fast_build.sh ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/trustkernel_config.mk ${dir}
	judge_ret $?
    
    dir="vendor/mediatek/proprietary/trustzone/custom/build/project/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}.mk ${dir}
	judge_ret $?
}

function collect_trustkernel_bsp()
{
	# delete .git
	dir="vendor/mediatek/proprietary/trustzone/trustkernel/source/"
	if [ -d "${ROOTPATH}/${dir}/.git" ];then
		rm -rf ${ROOTPATH}/${dir}/.git
	fi
	
	dir="vendor/mediatek/proprietary/trustzone/"
    if [ ! -d ${dir} ];then
        create_dir ${dir}
    fi
    cp -a ${ROOTPATH}/${dir}/trustkernel  ${dir}
	judge_ret $?
}

function collect_meta_patch()
{
    meta_v1=-1
    dir="vendor/mediatek/proprietary/hardware/meta/common/inc"
    if [ -f "${ROOTPATH}/${dir}/TrustkernelExternal.h" ];then
    	echo "patch meta v1..."
        meta_v1=1
	elif [ -f "${ROOTPATH}/${dir}/TrustkernelExternalCommand.h" ];then
    	echo "patch meta v2...."
        meta_v1=0
    else
        echo "not patch meta v1/v2, do you patched..."
        return 1
    fi
    
    dir="vendor/mediatek/proprietary/hardware/meta/common/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/Android.mk ${dir}
	judge_ret $?
    if [ ${meta_v1} -eq 1 ];then 
    dir="vendor/mediatek/proprietary/hardware/meta/common/inc"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/TrustkernelExternal.h ${dir}
	judge_ret $?
    
    elif [ ${meta_v1} -eq 0 ];then
    dir="vendor/mediatek/proprietary/hardware/meta/common/inc"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/TrustkernelExternalCommand.h ${dir}
	judge_ret $?
    
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/TrustkernelExternalPrivate.h ${dir}
	judge_ret $?
    fi
    dir="vendor/mediatek/proprietary/hardware/meta/common/src"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/TrustkernelExternal.cpp ${dir}
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/FtModule.cpp ${dir}
	judge_ret $?
}

function collect_xml()
{
    if [ x"${PLATFORM}" == x"mt6763" ];then
        PLF="MT6763"
    elif [ x"${PLATFORM}" == x"mt6580" ];then
        PLF="MT6580"
    fi
    dir="device/mediatek/build/build/tools/ptgen/${PLF}"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/partition_table_${PLF}.xls ${dir}
	judge_ret $?

}
function collect_lk_path()
{
    dir="vendor/mediatek/proprietary/bootable/bootloader/lk/kernel"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/main.c ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/rules.mk ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/tkcore_wp.c ${dir} 
	judge_ret $?
    cp -a ${ROOTPATH}/${dir}/main.c ${dir} 
	judge_ret $?

    dir="vendor/mediatek/proprietary/bootable/bootloader/lk/platform/${PLATFORM}/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/rules.mk ${dir} 
	judge_ret $?
    if [ x${Android_version} == x"8.x" ];then
    dir="vendor/mediatek/proprietary/bootable/bootloader/lk/project/"
    else
    dir="vendor/mediatek/proprietary/bootable/bootloader/lk/project/${PROJECT_NAME}"
    fi
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/${PROJECT_NAME}.mk ${dir} 
	judge_ret $?
}

function collect_sdrpmb_pl()
{
    dir="vendor/mediatek/proprietary/bootable/bootloader/preloader/platform/${PLATFORM}/src/drivers/"
    create_dir ${dir}
    cp -a ${ROOTPATH}/${dir}/mmc_core.c ${dir} 
	judge_ret $?
}
function package_patch_file()
{
	cd ${ROOTPATH}
	tar zcf TrustKernel_Patch.tar.gz TrustKernel_Patch
}

function collect_system_vold()
{
    dir="system/vold"
    create_dir ${dir}
    cp ${ROOTPATH}/${dir}/Android.mk ${dir}
    judge_ret $?
    cp ${ROOTPATH}/${dir}/cryptfs.c ${dir}
    judge_ret $?
}

function collect_sdrpmb()
{
    collect_xml 
    collect_lk_path 
    collect_sdrpmb_pl
}

if [ $# -lt 3 ];then
    usage
	exit 1
fi
ATFVERSION="v1.0"
PLATFORM=$1
PROJECT_NAME=$2
MF_NAME=$3
EABI=$4
SDRPMB=$5
ROOTPATH=$(pwd)
KVERSION="kernel-3.18"
if [ x${PLATFORM} == x"mt6580" ];then
    EABI=32
fi
if [ x${PLATFORM} == x"mt6757" -o x${PLATFORM} == x"mt6763" ];then
    KVERSION="kernel-4.4"
fi

create_dir "TrustKernel_Patch"
cd TrustKernel_Patch
collect_device_patched_file
collect_kernel_patch
collect_bootloader_patch
if [ x${PLATFORM} != x"mt6580" ];then
    
    if [ x${PLATFORM} == x"mt6763" ];then
        ATFVERSION="v1.3"
    fi
    
    if [ x${PLATFORM} == x"mt6757" ];then
        ATFVERSION="v1.2"
    fi
    collect_atf_patch
fi
collect_trustkernel_bsp
collect_meta_patch
collect_custom_build_patch
if [ x${Android_version} != x"8.x" ];then
    collect_system_vold
fi
if [ x$SDRPMB == x"sdrpmb" ];then
    collect_sdrpmb
fi
package_patch_file

echo "collect succefully...."
