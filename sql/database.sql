create database jwxt;
use jwxt;
create table User(
    ID int primary key not null auto_increment,
    Sno int unique not null,
    PWD char(20) not null,
    hashcode int,
    admin int check(admin in (0,1)),
    name char(20) ,
    mail char(50)    
);
create table Course(
    ID int primary key not null auto_increment,
    Cno int unique not null,
    /*因为Day是内定字符，所以修改为weekDay*/
    weekday int check(weekday >=0 and weekday<=6),
    Stime int check(Stime >=0 and Stime <=11),
    Etime int check(Stime >=0 and Etime <=11 and Etime > Stime),
    total int check(total >=0 and total <=999),
    avail int check(avail >=0)
);
create table SC(
    ID int primary key auto_increment,
    Sno int,
    Cno int,
    foreign key (Sno) references User (Sno),
    foreign key (Cno) references Course (Cno)
);