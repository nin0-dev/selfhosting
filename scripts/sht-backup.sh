#!/usr/bin/env bash

source .env

yap() {
    echo -e "{\"content\": \"-# $@ (<t:$(date +%s):D> at <t:$(date +%s):T>)\"}"
    curl -H "Content-Type: application/json" -d "{\"content\": \"-# $(echo $@) (<t:$(date +%s):D> at <t:$(date +%s):T>)\"}" "https://discord.com/api/webhooks/1346922376603893831/$DISCORD_WEBHOOK"
    echo -e "\033[1;33m>>> $@ <<<\033[0m"
}

start_time=$(date +%s)

# Checks
if [[ $EUID -ne 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi
basedir=$(basename "$(pwd)")
if [[ "$basedir" != "sht" && "$basedir" != "selfhosting" ]]; then
    echo "go to the base selfhosting root dir"
    exit 1
fi

curl -sH "Content-Type: application/json" -d "{\"content\": \":floppy_disk: **Starting backup (<t:$(date +%s):D> at <t:$(date +%s):T>).**\"}" "https://discord.com/api/webhooks/1346922376603893831/$DISCORD_WEBHOOK" > /dev/null &

# Prepare
working_dir="$(hostname)-backup-$(date +'%d-%m-%Y-%H-%M-%S')"
yap creating backup $working_dir
mkdir $working_dir

# Container data backup (raw)
yap pausing containers
for stack in stacks/*; do
    docker compose -f $stack/compose.yaml pause &> /dev/null
done
yap packing container data
tar -cf $working_dir/data.tar data
yap unpausing containers
for stack in stacks/*; do
    docker compose -f $stack/compose.yaml unpause &> /dev/null
done

# Host postgres backup
yap backing up host postgres
sudo -u postgres pg_dumpall > $working_dir/postgres-host-backup.sql

# Container postgres backup
for container in $(docker ps --format '{{.Names}}' | grep db | awk '{print $1}'); do
    yap backing up postgres in container $container
    docker exec $container pg_dumpall -U postgres > $working_dir/postgres-$container-backup.sql
done

# Compress and encrypt backup
yap compressing backup...
tar -czf $working_dir.tgz $working_dir
chown nin0:nin0 $working_dir.tgz

# Upload backup
yap uploading backup...
sudo -u nin0 rclone copy $working_dir.tgz iCloud:Backup/

yap removing old backups...
sudo -u nin0 /sht/scripts/sht-clean-backup.sh $working_dir

# Clean up
contents="Archive content: $(ls -L $working_dir | tr '\n' ' ')\\n\\nDocker data: $(ls -L data | tr '\n' ' ')"
yap done!
rm -rf $working_dir*

# Notify
curl -sH "Content-Type: application/json" -d "{\"content\": \"**:floppy_disk: Backup done:** <t:$(date +%s):D> at <t:$(date +%s):T>.\\nName is \`$working_dir\`, took $(( $(date +%s) - $start_time )) seconds.\\n\`\`\`\\n$contents\\n\`\`\`\\n-# ||<@886685857560539176>||\"}" "https://discord.com/api/webhooks/1346922376603893831/$DISCORD_WEBHOOK" > /dev/null
