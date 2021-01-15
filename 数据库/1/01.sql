CREATE TABLE Users(
	UserName			varchar(20) PRIMARY KEY,
	UserPassword		varchar(6),
	UserSex				char(2),
	UserRealName		varchar(20),
	UserAgeRange		char(8),
	UserAddress			varchar(256),
	UserPostCode		char(6),
	UserPhone			varchar(32),
	UserEmail			varchar(50),
	UserRegisterTime	smalldatetime,
	UserAdvancePayment  numeric(8,2)	--�̶����Ⱥ�С��λ��
);

CREATE TABLE Albums(
	AlbumID            tinyint identity PRIMARY KEY, --��IDΪ������ID:identity
	AlbumName          varchar(64) NOT NULL,
	AlbumIssueCompany  varchar(64),
	AlbumIssueDate     smalldatetime,
	AlbumType          tinyint,
	AlbumIntroduce     varchar(4096),
	AlbumImageUrl      varchar(200),      
	AlbumSinger        varchar(32),
	AlbumLanguage      varchar(10),
	AlbumMarketPrice   numeric(6,2),
	AlbumMemberPrice   numeric(6,2),
	AlbumIsRecommend   bit	--ȡֵΪ 1��0 �� NULL 
);

CREATE TABLE Songs(
	SongID			 tinyint identity PRIMARY KEY,
	SongNumber       tinyint,
	AlbumID  	     tinyint,
	SongTitle	     varchar(256) NOT NULL,
	SongDuration	 char(8),
	SongContent      varchar(4096),
	SongUploadDate	 smalldatetime ,
	SongUrl	         varchar(200),
	SongFormat       varchar(10),
	SongLanguage     varchar(10),
	SongType         tinyint,
	SongSinger	     varchar(32),		
	SongIsRecommend	 bit
);

ALTER TABLE Users ADD UserUpdateTime smalldatetime;

ALTER TABLE Users ALTER COLUMN UserSex bit NOT NULL;	-- 1��ʾ���С���0��ʾ��Ů��

ALTER TABLE Users DROP COLUMN UserUpdateTime;

DROP TABLE Users;

CREATE INDEX Users_Name_Index ON Users(UserName);	--û��ָ��CLUSTERED���򴴽��Ǿۼ�����

INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail) 
VALUES ('ws','123','Ů','��ɺ','21~30��','�����������йش�','100098','18611983575','ws@cuc.edu.cn');

UPDATE Users SET UserPassword='111' WHERE UserName='ws';

DELETE FROM Users WHERE UserName='ws';