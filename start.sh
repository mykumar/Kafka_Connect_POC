#!/bin/bash
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024

/sbin/mkswap /var/swap.1

/sbin/swapon /var/swap.1
echo "-------------------------";
echo "Start";
echo "-------------------------";
set -e

echo "Starting Hadoop"
hadoop namenode -format -force -nonInteractive
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode

zookeeper-server-start /mnt/etc/zookeeper.properties 1>> /mnt/logs/zk.log 2>>/mnt/logs/zk.log &
sleep 5

kafka-server-start /mnt/etc/server.properties 1>> /mnt/logs/kafka.log 2>> /mnt/logs/kafka.log &
sleep 5

schema-registry-start /mnt/etc/schema-registry.properties 1>> /mnt/logs/schema-registry.log 2>> /mnt/logs/schema-registry.log &
sleep 5
echo "Starting Hive metastore"
hive --service metastore 1>> /mnt/logs/metastore.log 2>> /mnt/logs/metastore.log &
