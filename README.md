# Kafka Connect PoC with DataBase, Kafka, Kafka Connect, Schema Registry, Hadoop, Hive

### Vagrant / Docker
For this PoC (If needed), you can use the attached VagrantFile or DockerFile. If you are already using the ubuntu. Just copy the files from this folder to the running Ubuntu system.

Attached VagrantFile, copies all the required files to the instance. Just hit :  

```sh
$ Vagrant up
```
### Installation

As we need Database, Hadoop, Kafka, Schema Registry along with Hive, Connectors. I created a Installation script. Just hit : 

```sh
$ deb.sh
```

### Hive MetaStore

Used MySQL as Hive MetaStore along with schematool. You can login to the mysql and check MetaStore is initlizaed properly.

### Setup the System to the Running Stage

Set the MySQL Password, create MetaStore Databases, JDBC Connector and other setup works. I combined and created a setup script, just hit :

```sh
setup.sh
```

### Start All Required Services MySQL, Kafka Connect, Hadoop, Hive etc

Created a start up script, just hit :

```sh
$ start.sh
```

**Note :** It is good Idea to check logs for the zookeeper, thrift, kafka, hadoop, hive, schema-registry along with confirmation of running.

### Copy .profile 

Ubuntu Systems need .profile for the user logged in, i created a .profile, just append this file contents to the existing.

### MySQL Setup

Create a demo Database 

```sh
CREATE DATABASE demo;
```
and Users Table :

```sh
CREATE TABLE users (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default CURRENT_TIMESTAMP NOT NULL,
  INDEX `modified_index` (`modified`)
);
```

Then, insert some records as follows:
```sh
INSERT INTO users (name, email, department) VALUES ('alice', 'alice@abc.com', 'engineering');
INSERT INTO users (name, email, department) VALUES ('bob', 'bob@abc.com', 'sales');
```

### Properties need by the Kafka Connect (MYSQL and Hadoop/HDFS SINKS) along with AVRO, Schema Registry and ZooKeeper

All the properties need by the ZooKeeper, Kafka Server Schema Registry. In addition, Kafka Connect properties along with the HDFS, MYSQL and AVRO SINKS properties are the respective files :

  - connect-avro-standalone.properties
  - connect-standalone.properties
  - hdfs.properties
  - mysql.properties
  - schema-registry.properties
  - server.properties
  - zookeeper.properties

### Things to note 

If your system can support more memory, it would great to tune the parameters in the start.sh file :

```sh
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
```

Also, in the connect-standalone.properties , if the database size and system memory grows up, tune the parameters :

```sh
    offset.flush.interval.ms=10000
	max.partition.fetch.bytes=250000
```

### Run Kafka Connect to Transfer Data From MySQL, Schema Registry to HDFS

To run Kafka Connect for copying data from Database Sink to HDFS Sink in conjuction with Schema using AVRO, just hit :

```sh
connect-standalone /mnt/etc/connect-avro-standalone.properties /mnt/etc/mysql.properties /mnt/etc/hdfs.properties
```

### After Kafka Connect Successfully Execution

After the Kafka Connect successfully executes Database, HDFS Sinks along with AVRO and Schem Registry. We can check the copied Hadoop data using the Hive as follows :

```sh
$ hive
hive> SHOW TABLES;
OK
test_jdbc_users
hive> SELECT * FROM test_jdbc_users;
OK
1 alice alice@abc.com engineering 1450305345000
2 bob   bob@abc.com   sales       1450305346000
```


