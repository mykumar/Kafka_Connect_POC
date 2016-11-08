ALTER TABLE users DROP COLUMN name;
INSERT INTO users (email, department) VALUES ('charlie@abc.com', 'sales');
INSERT INTO users (email, department) VALUES ('daniel@abc.com', 'engineering');