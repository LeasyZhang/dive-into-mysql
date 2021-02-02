# How to get random items from mysql

## In memory temporary table

```sql
select word from words order by rand() limit 3;
```

## Random sort

### Select 1 random item

```sql
select max(id), mind(id) into @M, @N from t;
set @X = floor((@M - @N + 1) * rand() + @N);
select * from t where id >= @X limit 1;
```

### Optimization

```sql
select count(*) into @C from t;
set @Y = floor(@C * rand());
set @sql = concat("select * from t limit", @Y, ",1");
prepare stmt from @sql;
execute stmt;
DEALLOCATE prepare stmt;
```
