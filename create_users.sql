-- Mysql
CREATE DATABASE demo;
USE demo;

CREATE TABLE users (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default CURRENT_TIMESTAMP NOT NULL,
  INDEX `modified_index` (`modified`)
);

INSERT INTO users (name, email, department) VALUES ('alice', 'alice@abc.com', 'engineering');
INSERT INTO users (name, email, department) VALUES ('bob', 'bob@abc.com', 'sales');