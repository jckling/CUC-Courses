-- ����PRIMARY KEYԼ��������Լ��������Users��ġ��û������У�UserName������Ϊ����
-- ��ɾ��ԭ���������������½�����
exec sp_helpconstraint'Users';
ALTER TABLE Users
DROP CONSTRAINT PK__Users__C9F284579C5C10BE;
ALTER TABLE Users
ADD CONSTRAINT PK__Users__C9F284579C5C10BE PRIMARY KEY CLUSTERED(UserName);

-- ����FOREIGN KEY�����Լ��������Songs���AlbumID������Ϊ���FK_Songs_Album
-- ���������Album���е�����AlbumID����ΥԼʱ���á��������¡��͡�����ɾ�����Ĳ���
ALTER TABLE Songs
ADD CONSTRAINT FK_Songs_Album FOREIGN KEY (AlbumID)
REFERENCES Albums(AlbumID)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- ����UNIQUEԼ����Ψһ��Լ������ΪSongs��ġ����������У�SongTitle������Ψһ��Լ��IX_SongTitle
-- ��ɾ��ԭ��Լ�����ٽ���Լ��
exec sp_helpconstraint'Songs';
ALTER TABLE Songs DROP CONSTRAINT IX_SongTitle;
ALTER TABLE Songs ADD CONSTRAINT IX_SongTitle UNIQUE (SongTitle);

-- ����CHECKԼ�������Լ������ΪAlbum���AlbumLanguage����һ�����Լ��CK_Language
-- ȡֵ��ΧΪ��������ͨ�������Ӣ������������������
exec sp_helpconstraint'Albums';
ALTER TABLE Albums
ADD CONSTRAINT CK_Language
CHECK (AlbumLanguage IN ('������ͨ��','����','Ӣ��','����','����','���','����'));

-- ΪUsers����һ���������������������Ϊadmin���û���Ҳ�������û�����Ϊadmin
-- �ֱ���AFTER��FOR����INSTEAD OF���ִ�������ʵ��
exec sp_helptrigger'Users';
CREATE TRIGGER admin1 ON Users
AFTER INSERT, UPDATE
AS
	DECLARE @name varchar(20),@updateName varchar(20)
	SELECT @name=UserName FROM inserted
	SELECT @updateName=UserName From inserted WHERE UserName NOT IN 
			(SELECT inserted.UserName FROM inserted,deleted WHERE inserted.UserName=deleted.UserName)
	IF @name = 'admin' or @updateName = 'admin'
	BEGIN
		ROLLBACK TRANSACTION
	END;

INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail) 
VALUES ('admin','123','Ů','��ɺ','21~30��','�����������йش�','100098','18611983575','ws@cuc.edu.cn');
UPDATE Users SET UserName='admin' WHERE UserName='wt';
DROP TRIGGER admin1

CREATE TRIGGER admin2 ON Users
INSTEAD OF INSERT, UPDATE
AS
	DECLARE @name varchar(20),@updateName varchar(20),@oldName varchar(20)
	SELECT @name=UserName FROM inserted
	SELECT @updateName=UserName From inserted WHERE UserName NOT IN 
			(SELECT inserted.UserName FROM inserted,deleted WHERE inserted.UserName=deleted.UserName)
	SELECT @oldName=UserName From deleted WHERE UserName NOT IN 
			(SELECT deleted.UserName FROM inserted,deleted WHERE inserted.UserName=deleted.UserName)
	IF ((SELECT COUNT(*) FROM inserted)=(SELECT COUNT(*) FROM deleted)) and @updateName != 'admin'
	BEGIN
		--print('update')
		UPDATE Users SET UserName=@updateName WHERE UserName=@oldName
	END
	ELSE IF @name != 'admin'
	BEGIN
		--print('insert')
		INSERT INTO Users SELECT * FROM inserted WHERE UserName=@name
	END
INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail)
VALUES ('test','123','Ů','��ɺ','21~30��','�����������йش�','100098','18611983575','ws@cuc.edu.cn');
UPDATE Users SET UserName='admi' WHERE UserName='test';
DELETE FROM Users WHERE UserName='test';
DELETE FROM Users WHERE UserName='admi';
DROP TRIGGER admin2