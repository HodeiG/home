#!/bin/bash
#
# Script to mount files encrypted with dm-crypt
# Guide: https://www.digitalocean.com/community/tutorials/how-to-use-dm-crypt-to-create-an-encrypted-volume-on-an-ubuntu-vps
# cryptsetup issue:
# https://superuser.com/questions/237599/crypsetup-unix-is-not-reading-my-device
#
# Create new encrypted file:
#   apt-get update
#   apt-get install cryptsetup
#   dd if=/dev/urandom of=${HOME}/encrypted_file bs=1M count=16
#   cryptsetup -y luksFormat ${HOME}/encrypted_file
#   cryptsetup luksOpen ${HOME}/encrypted_file encrypted_file
#   mkfs.ext4 -j /dev/mapper/encrypted_file
#   mkdir /mnt/encrypted_file
#   mount /dev/mapper/encrypted_file /mnt/encrypted_file
#
# Mount a previously created encrypted file:
#   cryptsetup luksOpen ${HOME}/encrypted_file encrypted_file
#   mkdir /mnt/encrypted_file
#   mount /dev/mapper/encrypted_file /mnt/encrypted_file
#
# Umount a encrypted file:
#   umount /dev/mapper/encrypted_file /mnt/encrypted_file
#   cryptsetup luksClose encrypted_file

declare -r RED='\033[0;31m'
declare -r GREEN='\033[0;32m'
declare -r NC='\033[0m' # No Color

# $0 - program
function usage() {
    local program="$0"
    echo -e "Usage:\n\
    $program {mount|umount|create} file [size]\n
    size = size of file in MB\n
Example:\n
    $program create new_file 512\n
    Will create an encrypted file called "new_file"
    of 512MB
"
}

# $1 - error
function error() {
    set +x
    local error="$1"; shift
    echo -e "${RED}$error.${NC}"
    exit 1
}

# $1 - file
# $2 - mapper
function mapper_already_exists() {
    local file="$1"; shift
    local mapper="$1"; shift
    echo -e "${RED}Mount device $mapper already exists.${NC}"
    echo -e "${RED}Check that $(readlink -f $file) is not already mounted.${NC}"
    exit 1
}

# $1 - file
function umount_encrypted_file() {
    local file="$1"; shift
    test -f "$file" || error "Encrypted file not provided."
    MAPPING_NAME=$(basename ${file})
    LOOP=$(losetup -a | grep $MAPPING_NAME | awk '{print $1}' | tr ':' ' ')
    MOUNT_DIR=/mnt/${MAPPING_NAME}

    set -x
    umount $MOUNT_DIR || error "Error while umount device."
    cryptsetup luksClose $MAPPING_NAME || error "Error while closing LUKS device."
    losetup -d $LOOP || error "Error while closing loopback device."
    rmdir $MOUNT_DIR || error "Error while deleting mount directory."
    set +x
}

# $1 - file
function mounted_succesfully() {
    local mount_dir="$1"; shift
    echo -e "${GREEN}File mounted at ${mount_dir}.${NC}"
    echo -e "${GREEN}Don't forget to exit root before editing any file.${NC}"
}

# $1 - file
function mount_encrypted_file() {
    local file="$1"; shift
    test -f "$file" || error "Encrypted file not provided."
    # Test if it is a block device
    test ! -b "$MAPPER" || mapper_already_exists $file $MAPPER

    MAPPING_NAME=$(basename ${file})
    LOOP=$(losetup -f)
    MAPPER=/dev/mapper/${MAPPING_NAME}
    MOUNT_DIR=/mnt/${MAPPING_NAME}

    set -x
    losetup $LOOP $file || error "Error setting loopback device."
    cryptsetup luksOpen $LOOP $MAPPING_NAME || error "Error while opening LUKS device."
    mkdir -p ${MOUNT_DIR}
    mount $MAPPER $MOUNT_DIR || error "Error while mounting encrypted file."
    mounted_succesfully $MOUNT_DIR
    set +x
}

function create_encrypted_file() {
    local file="$1"; shift
    test ! -f "$file" || error "Provided file exists."
    local size="$1"; shift
    test -n "$size" || error "File size not provided."

    MAPPING_NAME=$(basename ${file})
    LOOP=$(losetup -f)
    MAPPER=/dev/mapper/${MAPPING_NAME}

    set -x
    dd if=/dev/zero of=$file bs=1M count=$size
    losetup $LOOP $file
    cryptsetup luksFormat $LOOP || error "Error while formatting LUKS device."
    cryptsetup luksOpen $LOOP $MAPPING_NAME || error "Error while opening LUKS device."
    mkfs.ext4 -j $MAPPER
    cryptsetup luksClose $MAPPING_NAME || error "Error while closing LUKS device."
    losetup -d $LOOP || error "Error while closing loopback device."
    set +x
}

# $1 - action
# $2 - file
# $3 - size
function main() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${RED}This script must be run as root.${NC}" 1>&2
       exit 1
    fi

    local action="$1"; shift
    case  "${action}" in 
    "create")
        create_encrypted_file "$@"
        ;;
    "mount")
        mount_encrypted_file "$@"
        ;;
    "umount")
        umount_encrypted_file "$@"
        ;;
    *)
        echo -e "${RED}Action '$action' not recognised.${NC}"
        usage "$@"
        ;;
    esac
}

# https://bashinglinux.wordpress.com/2009/08/01/conventions/
main "$@"
