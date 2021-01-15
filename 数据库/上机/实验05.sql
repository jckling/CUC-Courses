
/**********************
实验05  数据库的完整性
**********************/
/*
【实验内容】
1.创建PRIMARY KEY约束（主键约束）
将Users表的“用户名”列（UserName）设置为主键
*/
USE NetMusicShop

ALTER TABLE Users DROP CONSTRAINT PK_Users
ALTER TABLE Users ADD CONSTRAINT PK_Users PRIMARY KEY(UserName)

/*
2.创建FOREIGN KEY（外键约束）
将Songs表的AlbumID列设置为外键FK_Songs_Album，该外键参照Album表中的主键AlbumID，
且违约时采用“级联更新”和“置空删除”的策略。
*/
ALTER TABLE Songs 
ADD CONSTRAINT FK_Songs_Album 
FOREIGN KEY(AlbumID) REFERENCES Album(AlbumID)
ON UPDATE CASCADE
ON DELETE SET NULL

ALTER TABLE Songs DROP CONSTRAINT FK_Songs_Album

/*
2.创建UNIQUE约束（唯一性约束）
为Songs表的“歌曲名”列（SongTitle）创建唯一性约束IX_SongTitle。
*/
ALTER TABLE Songs ADD CONSTRAINT IX_SongTitle UNIQUE(SongTitle)
ALTER TABLE Songs DROP CONSTRAINT IX_SongTitle


/*
3.创建CHECK约束（检查约束）
为Album表的“专辑语言”列（AlbumLanguage）创建一个检查约束CK_Language，
使得“专辑语言”的取值范围为“汉语普通话、粤语、英语、日语、韩语、多国、其他”之一。
*/
ALTER TABLE Album 
ADD CONSTRAINT CK_Language 
CHECK(AlbumLanguage IN('汉语普通话','粤语','英语','日语','韩语','多国','其他'))

ALTER TABLE Album DROP CONSTRAINT CK_Language

--
--4.为Users表创建一个触发器，不允许插入名为admin的用户，也不允许将用户名改为admin
--AFTER
CREATE TRIGGER Insert_Or_Update_After_UserAdmin
ON USERS
AFTER INSERT,UPDATE
AS
	DECLARE @UserName VARCHAR(20);
	DECLARE @NewUserName VARCHAR(20);
	DECLARE @CountAdmin INT;
	
	SELECT @UserName = UserName FROM DELETED;
	SELECT @NewUserName = UserName FROM INSERTED;
	PRINT(@UserName)
	
	SELECT @CountAdmin = COUNT(*) FROM Users WHERE UserName = 'admin'
	
	IF (@NewUserName = 'admin') AND (@UserName is null)
		BEGIN
			DELETE FROM Users WHERE UserName = @NewUserName
		END
	
	ELSE IF @CountAdmin > 0
		BEGIN
			UPDATE Users SET UserName = @UserName WHERE UserName = @NewUserName;
		END	
--两种实现方式：1、判定数据库里面有没有admin；2、判定@UserName is null，not null表示这是个update操作
		
--DROP TRIGGER Insert_Or_Update_After_UserAdmin
		

--INSTEAD OF
CREATE TRIGGER Insert_Or_Update_Instead_UserAdmin
ON USERS
INSTEAD OF INSERT,UPDATE
AS
	DECLARE @UserName VARCHAR(20), @UserRealName VARCHAR(20);
	DECLARE @UserPassword VARCHAR(6), @UserSex CHAR(2), @UserAgeRange CHAR(8), @UserAddress VARCHAR(256);
	DECLARE @UserPostCode CHAR(6), @UserPhone VARCHAR(32), @UserEmail VARCHAR(50);
	DECLARE @UserRegisterTime SMALLDATETIME, @UserAdvancePayment NUMERIC(8, 2);
	
	DECLARE @OldUserName VARCHAR(20);
	
	SELECT @UserName = UserName, @UserRealName = UserRealName,
	@UserPassword = UserPassword, @UserSex = UserSex, @UserAgeRange = UserAgeRange,
	@UserAddress = UserAddress, @UserPostCode = UserPostCode, @UserPhone = UserPhone, @UserEmail = UserEmail,
	@UserRegisterTime = UserRegisterTime, @UserAdvancePayment = UserAdvancePayment FROM INSERTED;
	
	SELECT @OldUserName = UserName FROM DELETED;
	
	IF (@UserName != 'admin')
		BEGIN
			IF(@OldUserName IS NULL)--代表这是一个插入操作
				BEGIN
					PRINT('INSERT')
					INSERT INTO Users (UserName,UserPassword,UserSex,UserRealName,UserAgeRange,
					UserAddress,UserPostCode,UserPhone,UserEmail, UserRegisterTime, UserAdvancePayment)
					Values(@UserName, @UserPassword, @UserSex, @UserRealName, @UserAgeRange,
					@UserAddress, @UserPostCode, @UserPhone, @UserEmail, @UserRegisterTime, @UserAdvancePayment)
				END
			ELSE
				BEGIN
					PRINT('UPDATE')
					UPDATE Users SET UserName = @UserName, UserPassword = @UserPassword, UserSex = @UserSex, 
					UserRealName = @UserRealName, UserAgeRange = @UserAgeRange, UserAddress = @UserAddress,
					UserPostCode = @UserPostCode, UserPhone = @UserPhone, UserEmail = @UserEmail, UserRegisterTime = @UserRegisterTime,
					UserAdvancePayment = @UserAdvancePayment
					WHERE UserName = @OldUserName
				END
		END
	ELSE
		PRINT('REFUSE')
		
--DROP TRIGGER Insert_Or_Update_Instead_UserAdmin

--Test Code
INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail)
VALUES('admin1','123','女','管理员1','21～30岁','北京海淀区中关村','100098','18611983575','wxy@cuc.edu.cn')
	
UPDATE Users SET UserName = 'admin' WHERE UserName = 'admin1'
UPDATE Users SET UserRealName = '管理员2' WHERE UserName = 'admin1'



