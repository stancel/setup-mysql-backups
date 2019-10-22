setup-mysql-backups
===================

This Ansible role copies a bash script to the machine that uses mysqldump to backup one or more databases on a nightly cron job. It keeps the latest backup in a folder called `/backups/mysql/current` so that a nightly offsite backup copy/include that file into a backup system. It then moves non-current DB backups into the `/backups/mysql` folder and retains backups up to the number specified by the `setup_mysql_backups_num_db_backups_to_keep` variable (default of 30 backups to keep). 

Requirements
------------

Some MySQL database(s) that you would like to backup on the server(s) you are running this against. MySQL and mysqldump installed on the server you are running this against.

Role Variables
--------------

List of databases to backup

```
	setup_mysql_backups_dbs_to_backup: 
	  - "business"
```
MySQL / MariaDB / Percona Server root password

```
	setup_mysql_backups_mysql_root_password: "your password here"
```
Number of DB Backups to keep

```
	setup_mysql_backups_num_db_backups_to_keep: 30
```

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
	- hosts: your_server
	  vars_files:
	    - vars/main.yml
	  roles:
	    - { role: stancel.setup-mysql-backups }
```

or 

```
	- hosts: your_server 
	  vars:
		setup_mysql_backups_num_db_backups_to_keep: 30
		setup_mysql_backups_mysql_root_password: "some password here"
		setup_mysql_backups_dbs_to_backup: 
          - 'db1'
          - 'db2'
	  roles:
	    - stancel.apache-webserver
```

License
-------

BSD

Author Information
------------------

[Brad Stancel](https://github.com/stancel)
