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

## Inner monitoring table

This approach may reduce mysql performace at 10 percent.

- Turn on Redo log monitoring

```sql
update setup_instruments set enabled = 'YES', timed='YES' where name like '%wait/io/file/innodb/innodb_log_file%';
```

Check IO request timeout

```sql
select event_name, MAX_TIMER_WAIT from performance_schema.file_summary_by_event_name where event_name in ('wait/io/file/innodb/innodb_log_file', 'wait/io/file/sql/binlog') and MAX_TIMER_WAIT > 200 * 1000000000;
```

Remember to truncate this table after check and collect database performance next time.
