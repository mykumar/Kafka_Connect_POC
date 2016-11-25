#!/bin/bash

set -e

if [ ! -d /tmp/vagrant-downloads ]; then
    mkdir -p /tmp/vagrant-downloads
fi
chmod a+rw /tmp/vagrant-downloads

if [ -z `which javac` ]; then
    apt-get -y update
    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:webupd8team/java
    apt-get -y update

    mkdir -p /var/cache/oracle-jdk7-installer
    if [ -e "/tmp/oracle-jdk7-installer-cache/" ]; then
        find /tmp/oracle-jdk7-installer-cache/ -not -empty -exec cp '{}' /var/cache/oracle-jdk7-installer/ \;
    fi

    /bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get -y install oracle-java7-installer oracle-java7-set-default

    if [ -e "/tmp/oracle-jdk7-installer-cache/" ]; then
        cp -R /var/cache/oracle-jdk7-installer/* /tmp/oracle-jdk7-installer-cache
    fi
fi

chmod a+rw /opt

if [ ! -e /mnt ]; then
    mkdir /mnt
fi
chmod a+rwx /mnt

if [ -h /opt/hadoop ]; then
    rm -f /opt/hadoop
fi

pushd /opt/
if [ ! -e hadoop ]; then
    pushd /tmp/vagrant-downloads
    if [ ! -e hadoop-2.6.0.tar.gz ]; then
        wget http://mirrors.koehn.com/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
    fi
    popd

    tar xvzf /tmp/vagrant-downloads/hadoop-2.6.0.tar.gz
fi
ln -s /opt/hadoop-2.6.0 /opt/hadoop
popd

if [ -h /opt/hive ]; then
    rm -f /opt/hive
fi

pushd /opt/
if [ ! -e apache-hive-1.2.1-bin ]; then
    pushd /tmp/vagrant-downloads
    if [ ! -e apache-hive-1.2.1-bin.tar.gz ]; then
        wget http://ftp.wayne.edu/apache/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz
    fi
    popd

    tar xvzf /tmp/vagrant-downloads/apache-hive-1.2.1-bin.tar.gz
fi
ln -s /opt/apache-hive-1.2.1-bin /opt/hive
popd

pushd /opt/
if [ ! -e confluent ]; then
    pushd /tmp/vagrant-downloads
    if [ ! -e confluent-2.0.0-2.11.7.tar.gz ]; then
        wget http://packages.confluent.io/archive/2.0/confluent-2.0.0-2.11.7.tar.gz
    fi
    popd

    tar xvzf /tmp/vagrant-downloads/confluent-2.0.0-2.11.7.tar.gz
fi
popd

chown vagrant:vagrant /home/vagrant/.profile

cp -r ./etc /mnt/
chown -R vagrant:vagrant /mnt/etc
mkdir -p /mnt/logs
chown -R vagrant:vagrant /mnt/logs

mkdir -p /mnt/dfs/name
mkdir -p /mnt/dfs/data

chown -R vagrant:vagrant /mnt/dfs
chown -R vagrant:vagrant /mnt/dfs/name
chown -R vagrant:vagrant /mnt/dfs/data

chown vagrant:vagrant /home/vagrant/setup.sh
chmod +x /home/vagrant/setup.sh

chown vagrant:vagrant /home/vagrant/start.sh
chmod +x /home/vagrant/start.sh

chown vagrant:vagrant /home/vagrant/clean_up.sh
chmod +x /home/vagrant/clean_up.sh

chown vagrant:vagrant /home/vagrant/*.sql

