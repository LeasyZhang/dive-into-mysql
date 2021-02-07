# How to analyse tables

## Basic table

given table:

```sql
create table `t` (
    `id` int(11) not null,
    `c` int(11) default null,
    `d` int(11) default null,
    primary key (`id`),
    key `c` (`c`)
) engine=innodb;

insert into t values(0,0,0), (5,5,5), (10,10,10), (15,15,15), (20,20,20), (25,25,25);
```

## lock range

```sql
begin;
select * from t where id > 9 and id < 12 order by id desc for update;

-- lock range (0,5] (5,10],(10,15) on primary index
```

```sql
begin;
select id from t where c in (5,20,10) lock in share mode;

-- (5,10], (10,15), (15,20], (20,25)
```

```sql
show engine innodb status;

-- LATESTEDETECTED DEADLOCK
```
