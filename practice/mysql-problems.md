# MySQL related problems

## Join

- If we use join, does left table always the drive table
- If there are more than one condition comparasion, do we need to write them in `on` sql or just put one condition inside `on`, and other conditions in `where` clause.

```sql
create table a(f1 int, f2 int, index(f1)) engine = innodb;
create table b(f1 int, f2 int) engine = innodb;

insert into a values(1,1),(2,2),(3,3),(4,4),(5,5),(6,6);
insert into b values(3,3),(4,4),(5,5),(6,6),(7,7),(8,8);
```

Let's discuss difference between the following sqls

```sql
select * from a left join b on (a.f1=b.f1) and (a.f2=b.f2);
select * from a left join b on (a.f1=b.f1) where (a.f2=b.f2);
```

- Firstly they have different output

For above sql, the result is

+------+------+------+------+
| f1   | f2   | f1   | f2   |
+------+------+------+------+
|    1 |    1 | NULL | NULL |
|    2 |    2 | NULL | NULL |
|    3 |    3 |    3 |    3 |
|    4 |    4 |    4 |    4 |
|    5 |    5 |    5 |    5 |
|    6 |    6 |    6 |    6 |
+------+------+------+------+

For second sql, the result is

+------+------+------+------+
| f1   | f2   | f1   | f2   |
+------+------+------+------+
|    3 |    3 |    3 |    3 |
|    4 |    4 |    4 |    4 |
|    5 |    5 |    5 |    5 |
|    6 |    6 |    6 |    6 |
+------+------+------+------+

The explain result is

- First sql

+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                      |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+
|  1 | SIMPLE      | a     | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | NULL                                       |
|  1 | SIMPLE      | b     | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | Using where; Using join buffer (hash join) |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+--------------------------------------------+

- Second sql

+----+-------------+-------+------------+------+---------------+------+---------+-----------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref       | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+-----------+------+----------+-------------+
|  1 | SIMPLE      | b     | NULL       | ALL  | NULL          | NULL | NULL    | NULL      |    6 |   100.00 | Using where |
|  1 | SIMPLE      | a     | NULL       | ref  | f1            | f1   | 5       | mydb.b.f1 |    1 |    16.67 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+-----------+------+----------+-------------+

For first sql, the driver table is table a and for second sql the driver table is b.
