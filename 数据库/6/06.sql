USE JWGL;
-- �������֡�ϵ�𣬲�ѯѧ����Ϣ
-- ����ѧ�ţ�Sno����������Sname�������䣨Sage����ѡ�޿γ�����Cname�����ɼ���Grade��
IF OBJECT_ID ( 'upSearchStudentGradeByDeptAndName', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upSearchStudentGradeByDeptAndName;
	print('��ɾ����')
	END
ELSE
	print('�����ڣ��ɴ�����');
GO
CREATE PROCEDURE upSearchStudentGradeByDeptAndName
    @dept char(20),
	@name char(20)
AS
    SELECT Student.Sno, Sname, Student.Sage, Cname, Grade
    FROM Student,Course,SC
    WHERE Student.Sname =@name and Student.Sdept=@dept and Student.Sno=SC.Sno and SC.Cno=Course.Cno;
GO
DECLARE	@dept char(20),@name char(20)
SET @dept='�����'
SET @name='����'
EXEC upSearchStudentGradeByDeptAndName @dept,@name

-- ����γ�������ѯĳ�ſγ̿��Ե�ƽ���ɼ�
IF OBJECT_ID ( 'upGetCourseAvgGrade', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetCourseAvgGrade
	print('��ɾ����')
	END
ELSE
	print('�����ڣ��ɴ�����');
GO
CREATE PROCEDURE upGetCourseAvgGrade
	@Cname char(30),
	@avg int OUTPUT
AS
	SET @avg = (
			SELECT AVG(isnull(Grade,0))
			FROM Course,SC
			WHERE Course.Cname=@Cname and SC.Cno=Course.Cno
			); 
GO
DECLARE @Cname char(30),@avg int
SET @Cname='���ݿ�ԭ��'
EXEC upGetCourseAvgGrade @Cname,@avg OUTPUT
print RTRIM(@Cname) + '��ƽ����Ϊ��' + CAST(@avg AS char(3))+'��'


-- ����ѧ�š��γ�������ȡ��ѧ���ÿγ̵ĳɼ���ѧ��
IF OBJECT_ID ( 'upGetStudentCredit', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetStudentCredit
	print('��ɾ����')
	END
ELSE
	print('�����ڣ��ɴ�����');
GO
CREATE PROCEDURE upGetStudentCredit
	@sid char(7),
	@cname char(30),
	@score int OUTPUT,
	@credit int OUTPUT
AS
	SELECT @score=Grade, @credit=Ccredit 
	FROM SC, Course
	WHERE SC.Sno=@sid and Course.Cname=@cname and Course.Cno=SC.Cno
	IF @score < 60
		SET @credit = 0;
GO
DECLARE	@score int,@credit int
DECLARE @sid char(7),@cname char(30)
SET @sid='2000012'
SET @cname='Ӣ��'
EXEC upGetStudentCredit @sid, @cname ,@score OUTPUT, @credit OUTPUT
PRINT @sid + 'ͬѧ�ġ�' + RTRIM(@cname) + '���ɼ�Ϊ' + CAST(@score AS char(3)) + '��'
PRINT '����ѧ��Ϊ' + CAST(@credit AS char(2))

-- ����γ�����ͳ������ÿγ̵ĸ�����������
IF OBJECT_ID ( 'upGetGradeLevels', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetGradeLevels
	print('��ɾ����')
	END
ELSE
	print('�����ڣ��ɴ�����');
GO
CREATE PROCEDURE upGetGradeLevels
	@cname char(30),
	@up90 int OUTPUT,
	@up80 int OUTPUT,
	@up70 int OUTPUT,
	@up60 int OUTPUT,
	@down60 int OUTPUT
AS
	SELECT	@up90=SUM(CASE WHEN Grade >= 90 THEN 1 ELSE 0 END),
			@up80=SUM(CASE WHEN Grade >= 80 AND Grade < 90 THEN 1 ELSE 0 END),
			@up70=SUM(CASE WHEN Grade >= 70 AND Grade < 80 THEN 1 ELSE 0 END),
			@up60=SUM(CASE WHEN Grade >= 60 AND Grade < 70 THEN 1 ELSE 0 END),
			@down60=SUM(CASE WHEN Grade < 60 THEN 1 ELSE 0 END)
	FROM SC,Course
	WHERE Course.Cname=@cname and SC.Cno=Course.Cno;
GO
DECLARE @cname char(30), @up90 int,@up80 int,@up70 int,@up60 int,@down60 int
SET @cname='Ӣ��'
EXEC upGetGradeLevels @cname, @up90 OUTPUT, @up80 OUTPUT, @up70 OUTPUT, @up60 OUTPUT, @down60 OUTPUT;
print '[90,100] ' + RTRIM(CAST(@up90 AS char(3))) + '��'
print '[80,90)  ' + RTRIM(CAST(@up80 AS char(3))) + '��'
print '[70,80)  ' + RTRIM(CAST(@up70 AS char(3))) + '��'
print '[60,70)  ' + RTRIM(CAST(@up60 AS char(3))) + '��'
print '[0,60)   ' + RTRIM(CAST(@down60 AS char(3))) + '��'
