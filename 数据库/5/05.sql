-- 创建PRIMARY KEY约束（主键约束），将Users表的“用户名”列（UserName）设置为主键
-- 先删除原有主键，再重新新建主键
exec sp_helpconstraint'Users';
ALTER TABLE Users
DROP CONSTRAINT PK__Users__C9F284579C5C10BE;	-- 因为原来UserName就是主键，因此得用这种方法删除
ALTER TABLE Users
ADD CONSTRAINT UserName PRIMARY KEY CLUSTERED(UserName);	-- 新建立主键可以起名为UserName，针对UserName那一列
															-- 之后再删除使用UserName即可，删除用的是constraint_name

-- 创建FOREIGN KEY（外键约束），将Songs表的AlbumID列设置为外键FK_Songs_Album
-- 该外键参照Album表中的主键AlbumID，且违约时采用“级联更新”和“级联删除”的策略
ALTER TABLE Songs
ADD CONSTRAINT FK_Songs_Album FOREIGN KEY (AlbumID)
REFERENCES Albums(AlbumID)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 创建UNIQUE约束（唯一性约束），为Songs表的“歌曲名”列（SongTitle）创建唯一性约束IX_SongTitle
-- 先删除原有约束，再建立约束
exec sp_helpconstraint'Songs';
ALTER TABLE Songs DROP CONSTRAINT IX_SongTitle;
ALTER TABLE Songs ADD CONSTRAINT IX_SongTitle UNIQUE (SongTitle);

-- 创建CHECK约束（检查约束），为Album表的AlbumLanguage创建一个检查约束CK_Language
-- 取值范围为“汉语普通话、粤语、英语、日语、韩语、多国、其他”
ALTER TABLE Albums
ADD CONSTRAINT CK_Language
CHECK (AlbumLanguage IN ('汉语普通话','粤语','英语','日语','韩语','多国','其他'));
ALTER TABLE Albums DROP CONSTRAINT CK_Language;

-- 为Users表创建一个触发器，不允许插入名为admin的用户，也不允许将用户名改为admin
-- 分别用AFTER（FOR）和INSTEAD OF两种触发器来实现
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