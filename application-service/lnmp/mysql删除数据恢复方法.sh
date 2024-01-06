
mysqlbinlog --base64-output=decode-rows -vv --start-position=84882 --database=mc_orderdb mysql-bin.000011 | grep -B3 DELETE | more



mysqlbinlog --base64-output=decode-rows -vv --start-position=84882 --database=mc_orderdb mysql-bin.000011 | grep -B3 DELETE | more


mysqlbinlog --no-defaults --base64-output=decode-rows -v  mysql-bin.000002 --result-file=mysql00002.sql



mysqlbinlog  --no-defaults --start-position=5007424 --stop-position=5921416 --database=balloon_gt mysql-bin.000002 > gt_users.sql


mysqlbinlog  --no-defaults --base64-output=decode-rows -vv --start-position=5007424 --stop-position=5921416 --database=balloon_gt mysql-bin.000002 > a.txt


show binlog events in 'mysql-bin.000002';

提取对应的删除SQL
sed -n '/^###/'p a.txt > b.txt

替换###
sed 's/### //g' b.txt > c.txt

删除每行后面的注释
sed 's#/.*#,#g' c.txt > d.txt

delete from 替换为 insert into
sed 's#DELETE FROM#INSERT INTO#g' d.txt > e.txt

where 替换为 select
sed 's#WHERE#SELECT#g' e.txt > f.txt

@31替换成','语句结尾加上;
sed -r 's#(@31=.*)(,)#\1;#g' f.txt > h.txt

生成可执行的sql
sed -r 's#(@.*=)(.*)#\2#g' h.txt > i.sql

