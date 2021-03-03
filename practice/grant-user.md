# User permission manage

## Create a user

```sql
create user 'ua'@'%' identified by 'pa';
```

After user been created, the user's permission is null for all roles.

## Global permission

```sql
grant all privileges on *.* to 'ua'@'%' with grant option;
```

## Database permission

```sql
grant all privileges on db1.* to 'ua'@'%' with grant option;
```

## Table permission

```sql
create table db1.t(id int, a int);
grant all privileges on db1.* to 'ua'@'%' with grant option;
grant select(id), insert(id, a) on mydb.mytbl to 'ua'@'%' with grant option;
```

## When to use flush privileges

- Directly update system permission table, we need to use `flush privileges` to keep permission consistent in memory and table.
