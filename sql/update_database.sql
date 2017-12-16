/* --  对原数据库关系模式的改造  -- */
-- 增加course name课程名称
ALTER TABLE `jwxt`.`course` 
ADD COLUMN `cname` VARCHAR(45) NOT NULL AFTER `Cno`;
UPDATE `jwxt`.`course` SET `cname`='web' WHERE `ID`='1';
UPDATE `jwxt`.`course` SET `cname`='android' WHERE `ID`='2';
UPDATE `jwxt`.`course` SET `cname`='network' WHERE `ID`='3';

-- 分配用户权限 
create user web2017 identified by 'web2017';
grant all on table course to web2017;
grant all on table sc to web2017;
grant all on table user to web2017;

-- 增加sc的唯一性约束 
alter table sc 
add unique key(sno,cno) ;

-- 修改sc关系的外键约束 级联操作 
-- 先删除
ALTER TABLE `jwxt`.`sc` 
DROP FOREIGN KEY `sc_ibfk_1`,
DROP FOREIGN KEY `sc_ibfk_2`;
-- 再增加
ALTER TABLE `jwxt`.`sc` 
ADD CONSTRAINT `sc_fk_1`
  FOREIGN KEY (`Sno`) REFERENCES `jwxt`.`user` (`Sno`) on delete cascade on update cascade,
ADD CONSTRAINT `sc_fk_2`
  FOREIGN KEY (`Cno`) REFERENCES `jwxt`.`course` (`Cno`) on delete cascade on update cascade;
  
-- 对中文的支持 
ALTER TABLE `jwxt`.`course` 
CHARACTER SET = utf8 ;
ALTER TABLE `jwxt`.`sc` 
CHARACTER SET = utf8 ;
ALTER TABLE `jwxt`.`user` 
CHARACTER SET = utf8 ;

-- 表级编码问题  
show full columns from course;
alter table course convert to character set utf8 collate utf8_general_ci;

show full columns from user;
alter table user convert to character set utf8 collate utf8_general_ci;

-- 更改user表图片存取的路径类型 
ALTER TABLE `jwxt`.`user` 
CHANGE COLUMN `hashcode` `image` VARCHAR(120) NULL DEFAULT NULL ;

-- 增加course的唯一性约束 
alter table course
add unique key(weekday,Stime,Etime) ;