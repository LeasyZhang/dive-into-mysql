# How to duplicate table in MySQL

## Given database and table

```sql
create database db1;
use db1;

create table t (id int primary key, a int, b int, index(a)) engine = innodb;

delimiter ;;

    create procedure idata()
    begin
        declare i int;
        set i = 1;
        while(i <= 1000) do
            insert into t values(i,i,i);
            set i = i + 1;
        end while;
    end;;
delimiter ;

call idata();

create database db2;
create table db2.t like db1.t;
```

we are going to export data from db1.t where a  > 900 and import to db2.t table.

## mysqldump solution

```bash
mysqldump -h$host -P$port -u$user --add-locks = 0 --no-create-info --single-transaction --set-gtid-purged=OFF db1 t --where="a>900" --result-file=/client/t.sql

# --single-transaction means apply none lock on db1.t table, instead it uses "start transaction with consistent snapshot"
# --add-locks = 0 means do not add "lock tables t write" on output file
# --no-create-info means do not export table structure
# --set-gtid-purged=off means do not export gtid information
# --result-file specified output files, client means output file was generated on client machine
```

Then we can execute exported sqls on db2

```bash
mysql -h127.0.0.1 -P13000 -uroot db2 -e "source /client_tmp/t.sql"
```

## Export csv file

```sql
seelct * from db1.t where a > 900 into outfile '/server_tmp/t.csv'
```

Then import use

```sql
load data infile '/server_tmp/t.csv' into table db2.t;
```

## Physical copy

This solution works after MySQL 5.6, this version introduce transportable tablespace solution to make physical copy applicable.

- execute `create table t like t` to create a empty table
- execute `alter table r discard tablespace`, after this sql, the r.ibd file will be deleted
- execute `flush table t for export` and there will be a t.cfg file under db1 directory
- execute `cp t.cfg r.cfg; cp t.ibd r.ibd` command under db1 directory
- execute `unlock tables` this time t.cfg file will be deleted
- execute `alter table r import tablespace`, then table r have data exactly like table t


## Compare

- Physical copy is the fastest especially for large tables, but it has restricitons:
    - It can only copy whole table, not partial data
    - It requires copy data on mysql server
    - It requires source table and target table are all innodb engine
- mysqldump can add where filters on exported data, but it can't use join or complexed sql filters
- select ... into outfile is the most flexible, but it can only export data on one table
