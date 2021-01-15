USE JWGL;
-- 输入名字、系别，查询学生信息
-- 包括学号（Sno）、姓名（Sname）、年龄（Sage）、选修课程名（Cname）、成绩（Grade）
IF OBJECT_ID ( 'upSearchStudentGradeByDeptAndName', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upSearchStudentGradeByDeptAndName;
	print('已删除！')
	END
ELSE
	print('不存在，可创建！');
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
SET @dept='计算机'
SET @name='王林'
EXEC upSearchStudentGradeByDeptAndName @dept,@name

-- 输入课程名，查询某门课程考试的平均成绩
IF OBJECT_ID ( 'upGetCourseAvgGrade', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetCourseAvgGrade
	print('已删除！')
	END
ELSE
	print('不存在，可创建！');
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
SET @Cname='数据库原理'
EXEC upGetCourseAvgGrade @Cname,@avg OUTPUT
print RTRIM(@Cname) + '的平均分为：' + CAST(@avg AS char(3))+'分'


-- 输入学号、课程名，获取该学生该课程的成绩和学分
IF OBJECT_ID ( 'upGetStudentCredit', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetStudentCredit
	print('已删除！')
	END
ELSE
	print('不存在，可创建！');
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
SET @cname='英语'
EXEC upGetStudentCredit @sid, @cname ,@score OUTPUT, @credit OUTPUT
PRINT @sid + '同学的“' + RTRIM(@cname) + '”成绩为' + CAST(@score AS char(3)) + '分'
PRINT '所获学分为' + CAST(@credit AS char(2))

-- 输入课程名，统计输出该课程的各分数段人数
IF OBJECT_ID ( 'upGetGradeLevels', 'P' ) IS NOT NULL
	BEGIN
    DROP PROCEDURE upGetGradeLevels
	print('已删除！')
	END
ELSE
	print('不存在，可创建！');
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
SET @cname='英语'
EXEC upGetGradeLevels @cname, @up90 OUTPUT, @up80 OUTPUT, @up70 OUTPUT, @up60 OUTPUT, @down60 OUTPUT;
print '[90,100] ' + RTRIM(CAST(@up90 AS char(3))) + '人'
print '[80,90)  ' + RTRIM(CAST(@up80 AS char(3))) + '人'
print '[70,80)  ' + RTRIM(CAST(@up70 AS char(3))) + '人'
print '[60,70)  ' + RTRIM(CAST(@up60 AS char(3))) + '人'
print '[0,60)   ' + RTRIM(CAST(@down60 AS char(3))) + '人'
