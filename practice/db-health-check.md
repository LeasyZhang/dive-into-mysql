# How to check database availablibility

## Select 1

Run

```sql
select 1
```

on specified database.

## Select health check table

Query a health_check table periodically to detect database availablilty.

Healty check table:

```sql
create table `health_check`(
    `id` int(11) not null,
    `t_modified` timestamp not null default current_timestamp,
    primary key (`id`)
) Engine=InnoDB

--insert init data
insert into mysql.health_check(id, t_modified) values(@@server_id, now()) on duplicate key update t_modified = now();
```

- read query

```sql
select * from mysql.health_check;
```

- write query

```sql
update mysql.health_check set t_modified = now();
```
