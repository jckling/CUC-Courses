--创建表
--create table S(
--Sno CHAR(9) PRIMARY KEY,
--Sname CHAR(20) UNIQUE,
--Ssex CHAR(2),
--Sdept CHAR(20)
--);
--create table C(
--Cno CHAR(4) PRIMARY KEY,
--Cname CHAR(40) NOT NULL
--);
--create table SC(
--Sno CHAR(9),
--Cno CHAR(4),
--Grade SMALLINT,
--PRIMARY KEY (Sno, Cno),
--FOREIGN KEY (Sno) REFERENCES S(Sno),
--FOREIGN KEY (Cno) REFERENCES C(Cno)
--);

--添加数据
--insert
--into S(Sno, Sname, Ssex, Sdept)
--values('2000012', '王林','男', '计算机');

--insert
--into S
--values('2000113', '张大民', '男', '物理');

--insert
--into S
--values('2000256', '顾芳', '女', '管理');

--insert
--into S
--values('2000278', '姜凡', '男', '管理');

--insert
--into S
--values('2000014', '葛波', '女', '计算机');

--insert
--into C(Cno, Cname)
--values('1024', '数据库原理');

--insert
--into C
--values('1136', '离散数学');

--insert
--into C
--values('1137', '管理学');

--insert
--into C
--values('1156', '英语');

--insert
--into SC(Sno, Cno, Grade)
--values('2000012', '1156', 80)

--insert
--into SC
--values('2000113', '1156', 89)

--insert
--into SC
--values('2000256', '1156', 93)

--insert
--into SC
--values('2000014', '1156', 88)

--insert
--into SC
--values('2000256', '1137', 77)

--insert
--into SC
--values('2000278', '1156', 89)

--insert
--into SC
--values('2000012', '1024', 80)

--insert
--into SC
--values('2000014', '1136', 90)

--insert
--into SC
--values('2000012', '1136', 78)

--insert
--into SC
--values('2000012', '1137', 70)

--insert
--into SC
--values('2000014', '1024', 88)

--数据查询
--select Sno,Sname from S;

--select * from S
--order by Sdept desc;

--select count(*) from S;
--select count(Sno) from S;

--select count(distinct Sno) from SC;
--select count(Sno) from SC;

--统计选了1156或1136的学生总数，避免学生两门都选（重复）
--select count(distinct Sno) from SC
--where Cno='1156' or Cno='1136'

--select max(Grade) from sc
--where Cno='1156';

--select avg(Grade) from sc;

--select Cno,count(Sno) '人数' from sc
--group by Cno;

--select Sno from SC
--group by Sno
--having count(*)>3;

--select Sno, sum(Grade) '总成绩'
--from SC
--where Grade>=60
--group by Sno
--having count(Cno)>=3
--order by sum(Grade) DESC
-- 或指明第二列 order by 2 DESC

--连接查询
--select S.Sno,Sname,Ssex,Sdept,C.Cno,Grade,Cname from S,SC,C
--where S.Sno = SC.Sno and SC.Cno = C.Cno and Cname='离散数学';

--select Sname, sum(Ccredit) '总学分'
--from S, SC, C
--where S.Sno = SC.Sno and SC.Cno = C.Cno
--group by S.Sno, S.Sname
--having sum(Ccredit)>5

--select a.Sno
--from SC a, SC b
--where a.Sno=b.Sno
--and a.Cno='1024'
--and b.Cno='1136'

--select Sno from SC
--group by Sno
--having count(Cno)>2

--select Sname,SC.Sno,C.Cno,Grade,C.Cname,C.Ccredit
--from S left join SC on S.Sno=SC.Sno
--left join C on C.Cno = SC.Cno

-- count(*)会计算NULL，将NULL记为1
--select C.Cno, count(Sno) Num
--from C left join SC on C.Cno=SC.Cno
--group by C.Cno

CREATE TABLE News(
	UserID varchar(7),
	NewsID varchar(9),
	ReadTime varchar(10),
	Content text
);