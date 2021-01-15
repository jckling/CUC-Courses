-- ����PRIMARY KEYԼ��������Լ��������Users��ġ��û������У�UserName������Ϊ����
-- ��ɾ��ԭ���������������½�����
exec sp_helpconstraint'Users';
ALTER TABLE Users
DROP CONSTRAINT PK__Users__C9F284579C5C10BE;	-- ��Ϊԭ��UserName������������˵������ַ���ɾ��
ALTER TABLE Users
ADD CONSTRAINT UserName PRIMARY KEY CLUSTERED(UserName);	-- �½���������������ΪUserName�����UserName��һ��
															-- ֮����ɾ��ʹ��UserName���ɣ�ɾ���õ���constraint_name

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
ALTER TABLE Albums
ADD CONSTRAINT CK_Language
CHECK (AlbumLanguage IN ('������ͨ��','����','Ӣ��','����','����','���','����'));
ALTER TABLE Albums DROP CONSTRAINT CK_Language;

-- ΪUsers����һ���������������������Ϊadmin���û���Ҳ�������û�����Ϊadmin
-- �ֱ���AFTER��FOR����INSTEAD OF���ִ�������ʵ��
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
		UPDATE Users SET UserName=@updateName WHERE UserName=@oldName
	END
	ELSE IF @name != 'admin'
	BEGIN
		INSERT INTO Users SELECT * FROM inserted WHERE UserName=@name
	END
DROP TRIGGER admin2