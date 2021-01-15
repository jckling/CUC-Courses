/**********************
ʵ��6 �洢����
***********************/
--1.����һ����ΪupSearchStudentGradeByDeptAndName�Ĵ洢���̣��ô洢�������������������@dept, @name������ѯĳϵ��ĳ������ѧ������Ϣ������ѧ�ţ�Sno����������Sname�������䣨Sage����ѡ�޿γ�����Cname�����ɼ���Grade����ִ�иô洢���̣��ò���'�����','����'���Բ��ԡ�


if exists (select name from sysobjects where name='upSearchStudentGradeByDeptAndName'and type='p')
  begin
  print '��ɾ����'
  drop procedure Stu_proc1
  end
else
print '�����ڣ��ɴ�����'
go

create procedure upSearchStudentGradeByDeptAndName
@dept varchar(10)='%',@name varchar(8)='��%'
as
select Sdept,Student.Sno,Sname,Sage,Cname,Grade
from Student,SC,Course
where Student.Sno=SC.Sno
     and Course.Cno=SC.Cno
     and Sdept like @dept
     and Sname like @name

exec upSearchStudentGradeByDeptAndName '�����','����'


--2.����һ����ΪupGetCourseAvgGrade�Ĵ洢���̣��ɲ�ѯĳ�ſγ̿��Ե�ƽ���ɼ���ƽ���ɼ�����������Ա��һ�����á�ִ�иô洢���̣���ѯ�����ݿ�ԭ����ƽ���ɼ���

if exists (select name from sysobjects where name='upGetCourseAvgGrade'and type='p')
  begin
  print '��ɾ����'
  drop procedure Stu_proc2
  end
else
print '�����ڣ��ɴ�����'
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
exec upGetCourseAvgGrade '���ݿ�ԭ��',@ping output
print '�ÿγ̵�ƽ������Ϊ��'+cast(@ping as nvarchar(20))//cast����ת��

--3.����һ����ΪupGetStudentCredit�Ĵ洢���̡���ִ��upGetStudentCreditʱ������ѧ��@sid���γ�����@cname����ֵ������ѯSC��Course����ͨ���������@score��@credit��ȡ��ѧ���ÿγ̵ĳɼ���ѧ�֡�����������ڵ���60���򷵻ض�Ӧ�γ̵�ѧ�֣����򷵻�ѧ��ֵ0��


if exists (select name from sysobjects where name='upGetStudentCredit'and type='p')
  begin
  print '��ɾ����'
  drop procedure Stu_proc3
  end
else
print '�����ڣ��ɴ�����'
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
SET @cname='Ӣ��'
EXEC upGetStudentCredit @sid,@cname,@score OUTPUT ,@credit OUTPUT
PRINT @sid+'ͬѧ�ġ�'+RTRIM(@cname)+'���ɼ�Ϊ'+CAST(@score AS char(3))+'��'
PRINT '����ѧ��Ϊ'+CAST(@credit AS char(2))

--4.����һ����ΪupGetGradeLevels�Ĵ洢���̣�����������������������γ����ƣ�ͳ������ÿγ̵ĸ�������������ִ�иô洢���̣��ò���'Ӣ��'���Բ��ԡ�


if exists (select name from sysobjects where name='upGetGradeLevels'and type='p')
  begin
  print '��ɾ����'
  drop procedure Stu_proc4
  end
else
print '�����ڣ��ɴ�����'
go

create procedure upGetGradeLevels
 @Cname varchar(20)
as
select Course.Cname as �γ���,sum(case when Grade>=90  then 1 else 0 end) '>90',
sum(case when Grade>=80  and Grade<90 then 1 else 0 end) '80-90',
sum(case when Grade>=70  and Grade<80 then 1 else 0 end) '70-80',
sum(case when Grade>=60  and Grade<70 then 1 else 0 end) '60-70',
sum(case when Grade<60 then 1 else 0 end) '<60'
from SC,Course
where SC.Cno=Course.Cno and Cname=@Cname
group by Course.Cname

go
exec upGetGradeLevels  'Ӣ��'
