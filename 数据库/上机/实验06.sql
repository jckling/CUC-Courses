/**********************
实验6 存储过程
***********************/
--1.创建一个名为upSearchStudentGradeByDeptAndName的存储过程：该存储过程有两个输入参数（@dept, @name），查询某系、某姓名的学生的信息：包括学号（Sno）、姓名（Sname）、年龄（Sage）、选修课程名（Cname）、成绩（Grade）。执行该存储过程，用参数'计算机','王林'加以测试。


if exists (select name from sysobjects where name='upSearchStudentGradeByDeptAndName'and type='p')
  begin
  print '已删除！'
  drop procedure Stu_proc1
  end
else
print '不存在，可创建！'
go

create procedure upSearchStudentGradeByDeptAndName
@dept varchar(10)='%',@name varchar(8)='王%'
as
select Sdept,Student.Sno,Sname,Sage,Cname,Grade
from Student,SC,Course
where Student.Sno=SC.Sno
     and Course.Cno=SC.Cno
     and Sdept like @dept
     and Sname like @name

exec upSearchStudentGradeByDeptAndName '计算机','王林'


--2.创建一个名为upGetCourseAvgGrade的存储过程，可查询某门课程考试的平均成绩。平均成绩可以输出，以便进一步调用。执行该存储过程，查询“数据库原理”的平均成绩。

if exists (select name from sysobjects where name='upGetCourseAvgGrade'and type='p')
  begin
  print '已删除！'
  drop procedure Stu_proc2
  end
else
print '不存在，可创建！'
go
create procedure upGetCourseAvgGrade
@Cname varchar(20),
@avg int output
as
select @avg=avg(Grade)
from SC,Course
where Course.cno=SC.cno
      and Cname=@Cname 
group by SC.Cno, Course.Cname

declare @ping int
exec upGetCourseAvgGrade '数据库原理',@ping output
print '该课程的平均分数为：'+cast(@ping as nvarchar(20))//cast类型转换

--3.创建一个名为upGetStudentCredit的存储过程。当执行upGetStudentCredit时，输入学号@sid、课程名称@cname参数值，将查询SC和Course表，并通过输出参数@score和@credit获取该学生该课程的成绩和学分。如果分数大于等于60，则返回对应课程的学分，否则返回学分值0。


if exists (select name from sysobjects where name='upGetStudentCredit'and type='p')
  begin
  print '已删除！'
  drop procedure Stu_proc3
  end
else
print '不存在，可创建！'
go

CREATE PROCEDURE upGetStudentCredit
(  @sid int,
   @cname char(20),
   @score int OUTPUT,
   @credit int OUTPUT                      
)      
AS
  SELECT @score=SC.Grade,@credit=
   CASE
     WHEN  SC.Grade<60   THEN 0
     ELSE  Course.Ccredit                         
   END
  FROM SC,Course  
  WHERE  SC.Cno=Course.Cno AND SC.Sno=@sid AND Course.Cname=@cname

DECLARE @score int,@credit int
DECLARE @sid char(7),@cname char(30)
SET @sid='2000012'
SET @cname='英语'
EXEC upGetStudentCredit @sid,@cname,@score OUTPUT ,@credit OUTPUT
PRINT @sid+'同学的“'+RTRIM(@cname)+'”成绩为'+CAST(@score AS char(3))+'分'
PRINT '所获学分为'+CAST(@credit AS char(2))

--4.创建一个名为upGetGradeLevels的存储过程：既有输入又有输出，给出课程名称，统计输出该课程的各分数段人数。执行该存储过程，用参数'英语'加以测试。


if exists (select name from sysobjects where name='upGetGradeLevels'and type='p')
  begin
  print '已删除！'
  drop procedure Stu_proc4
  end
else
print '不存在，可创建！'
go

create procedure upGetGradeLevels
 @Cname varchar(20)
as
select Course.Cname as 课程名,sum(case when Grade>=90  then 1 else 0 end) '>90',
sum(case when Grade>=80  and Grade<90 then 1 else 0 end) '80-90',
sum(case when Grade>=70  and Grade<80 then 1 else 0 end) '70-80',
sum(case when Grade>=60  and Grade<70 then 1 else 0 end) '60-70',
sum(case when Grade<60 then 1 else 0 end) '<60'
from SC,Course
where SC.Cno=Course.Cno and Cname=@Cname
group by Course.Cname

go
exec upGetGradeLevels  '英语'
