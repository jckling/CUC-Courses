
/**********************
ʵ��05  ���ݿ��������
**********************/
/*
��ʵ�����ݡ�
1.����PRIMARY KEYԼ��������Լ����
��Users��ġ��û������У�UserName������Ϊ����
*/
USE NetMusicShop

ALTER TABLE Users DROP CONSTRAINT PK_Users
ALTER TABLE Users ADD CONSTRAINT PK_Users PRIMARY KEY(UserName)

/*
2.����FOREIGN KEY�����Լ����
��Songs���AlbumID������Ϊ���FK_Songs_Album�����������Album���е�����AlbumID��
��ΥԼʱ���á��������¡��͡��ÿ�ɾ�����Ĳ��ԡ�
*/
ALTER TABLE Songs 
ADD CONSTRAINT FK_Songs_Album 
FOREIGN KEY(AlbumID) REFERENCES Album(AlbumID)
ON UPDATE CASCADE
ON DELETE SET NULL

ALTER TABLE Songs DROP CONSTRAINT FK_Songs_Album

/*
2.����UNIQUEԼ����Ψһ��Լ����
ΪSongs��ġ����������У�SongTitle������Ψһ��Լ��IX_SongTitle��
*/
ALTER TABLE Songs ADD CONSTRAINT IX_SongTitle UNIQUE(SongTitle)
ALTER TABLE Songs DROP CONSTRAINT IX_SongTitle


/*
3.����CHECKԼ�������Լ����
ΪAlbum��ġ�ר�����ԡ��У�AlbumLanguage������һ�����Լ��CK_Language��
ʹ�á�ר�����ԡ���ȡֵ��ΧΪ��������ͨ�������Ӣ������������������֮һ��
*/
ALTER TABLE Album 
ADD CONSTRAINT CK_Language 
CHECK(AlbumLanguage IN('������ͨ��','����','Ӣ��','����','����','���','����'))

ALTER TABLE Album DROP CONSTRAINT CK_Language

--
--4.ΪUsers����һ���������������������Ϊadmin���û���Ҳ�������û�����Ϊadmin
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
--����ʵ�ַ�ʽ��1���ж����ݿ�������û��admin��2���ж�@UserName is null��not null��ʾ���Ǹ�update����
		
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
			IF(@OldUserName IS NULL)--��������һ���������
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
VALUES('admin1','123','Ů','����Ա1','21��30��','�����������йش�','100098','18611983575','wxy@cuc.edu.cn')
	
UPDATE Users SET UserName = 'admin' WHERE UserName = 'admin1'
UPDATE Users SET UserRealName = '����Ա2' WHERE UserName = 'admin1'



