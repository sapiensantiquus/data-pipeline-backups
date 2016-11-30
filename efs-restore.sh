#!/bin/bash
# Example would be to run this script as follows:
# Every 6 hours; retain last 4 backups
# efs-backup.sh $src $dst hourly 4 efs-12345
# Once a day; retain last 31 days
# efs-backup.sh $src $dst daily 31 efs-12345
# Once a week; retain 4 weeks of backup
# efs-backup.sh $src $dst weekly 7 efs-12345
# Once a month; retain 3 months of backups
# efs-backup.sh $src $dst monthly 3 efs-12345
#
# Snapshots will look like:
# $dst/$backup_path/hourly.0-3; daily.0-30; weekly.0-3; monthly.0-2


# Input arguments
prod_efs=$1
backup_efs=$2
backup_number=$3
interval=$4
backup_path=$5

echo 'sudo yum -y install nfs-utils'
sudo yum -y install nfs-utils
echo 'sudo mkdir /prod_mnt'
sudo mkdir /prod_mnt
echo 'sudo mkdir /backup_mnt'
sudo mkdir /backup_mnt
echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $prod_efs /prod_mnt"
sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $prod_efs /prod_mnt
echo "sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $backup_efs /backup_mnt"
sudo mount -t nfs -o nfsvers=4.1 -o rsize=1048576 -o wsize=1048576 -o timeo=600 -o retrans=2 -o hard $backup_efs /backup_mnt
echo "sudo rsync -avh --stats --delete --numeric-ids --log-file=/tmp/efs-restore.log /backup_mnt/$backup_path/$interval.$backup_number/ /prod_mnt/"
sudo rsync -ah --stats --delete --numeric-ids --log-file=/tmp/efs-restore.log /backup_mnt/$backup_path/$interval.$backup_number/ /prod_mnt/
rsyncStatus=$?

exit $rsyncStatus
