# Given table

```sql
create table t1(id int primary key, a int, b int, index(a));
create table t2 like t1;

drop procedure idata;
delimiter ;;

create procedure idata()
begin

    declare i int;
    set i = 1;
    while(i <= 1000)do
        insert into t1 values(i, 1001-i, i);
        set i = i + 1;
    end while;

    set i = 1;
    while(i <= 1000000)do
        insert into t1 values(i, i, i);
        set i = i + 1;
    end while;

end;;
delimiter;
call idata();
```

## Use MRR

```sql
set optimizer_switch = "mrr_cost_based=off"
```
