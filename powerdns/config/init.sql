CREATE TABLE IF NOT EXISTS domains (
id INT auto_increment,
name VARCHAR(255) ,
master VARCHAR(128) DEFAULT NULL,
last_check INT DEFAULT NULL,
type VARCHAR(6) NOT NULL,
notified_serial INT DEFAULT NULL,
account VARCHAR(40) DEFAULT NULL,
primary key (id),
UNIQUE INDEX name_index (name)
);


CREATE TABLE IF NOT EXISTS records (
id INT auto_increment,
domain_id INT DEFAULT NULL,
name VARCHAR(255) DEFAULT NULL,
type VARCHAR(6) DEFAULT NULL,
content VARCHAR(255) DEFAULT NULL,
ttl INT DEFAULT NULL,
prio INT DEFAULT NULL,
change_date INT DEFAULT NULL,
primary key(id), 
INDEX rec_name_index (name),
INDEX nametype_index (name,type),
INDEX domain_id (domain_id)
);


CREATE TABLE IF NOT EXISTS supermasters (
ip VARCHAR(25) NOT NULL,
nameserver VARCHAR(255) NOT NULL,
account VARCHAR(40) DEFAULT NULL
);
