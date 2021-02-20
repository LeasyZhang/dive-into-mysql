# Why primary key in mysql can not increament in sequence

## given table

```sql
create table `t`(
    `id` int(11) not null auto_increment,
    `c` int(11) default null,
    `d` int(11) default null,
    primary key (`id`),
    unique key `c` (`c`)
) engine = innodb;
```

## unique key violation

```sql
-- session A
insert into t values(null, 1, 1);
insert into t values(null, 1, 1);

-- session B
insert into t values(null, 2, 1);
-- the result after insert null, 2, 1 will be 3,2,1, auto increment value won't rollback after apply.
```

## transaction rollback

```sql
-- session A
insert into t values(null, 1, 1);
begin;
insert into t values(null, 2, 1);
rollback;
insert into t values(null, 2, 1);
-- the result after insert null, 2, 1 will be 3,2,1, auto increment value won't rollback after transaction rollback.
```

## batch insert

```sql
insert into t values (null, 1, 1);
insert into t values (null, 2, 2);
insert into t values (null, 3, 3);
insert into t values (null, 4, 4);
create table t2 like t;
insert into t2(c,d) select c, d from t;
insert into t2 values (null, 5, 5);
--the result will be 8,5,5, every time we apply increment id with same statement, the id amount will be twice than before.
```
