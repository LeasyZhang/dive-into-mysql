# Dead lock scenorio

## Session A

```sql
begin;
insert into t values(null, 5, 5);


-- after session B and session C
rollback;
```

## Session B

```sql
-- after session A's begin and insert statement

insert into t values(null, 5, 5);
```

## Session C

```sql
-- after session A's begin and insert statement

insert into t values(null, 5, ,5);
--Dead lock found
```

- At t1, session a started and execute insert statement, this will apply a record lock on index c's c = 5 record
- At t2, session B and session C will execute same insert statement and found unique key violation, it add a read lock
- At t3, session A rollback, both session B and session C try to do insert statement and thus apply write lock on the record, both sessions also wait for another session's record lock, thus caused dead lock.