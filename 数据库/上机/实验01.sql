/***************************
ʵ��01 ���ݱ�Ĵ��������
***************************/
/*
��ʵ�����ݡ�
1.���ݱ�Ĵ���
�������û���Users
*/
CREATE TABLE Users(
UserName         varchar(20) identity(1,1) PRIMARY KEY,
UserPassword     varchar(6),
UserSex	         char(2),
UserRealName     varchar(20),
UserAgeRange	 char(8),
UserAddress	     varchar(256),
UserPostCode     char(6),
UserPhone	     varchar(32),
UserEmail	     varchar(50),
UserRegisterTime smalldatetime,
UserAdvancePayment numeric(8,2))

--������ר����Album
CREATE TABLE Album(
AlbumID            tinyint identity(1,1) PRIMARY KEY,
AlbumName          varchar(64) not null,
AlbumIssueCompany  varchar(64),
AlbumIssueDate     smalldatetime,
AlbumType          tinyint,
AlbumIntroduce     varchar(4096),
AlbumImageUrl      varchar(200),                       
AlbumSinger        varchar(32) ,
AlbumLanguage      varchar(10),
AlbumMarketPrice   numeric(6,2),
AlbumMemberPrice   numeric(6,2),
AlbumIsRecommend   bit)

/*
2. ���ݱ�Ĺ���
1���޸����ݱ�
����Users�����ӡ��޸�ʱ�䡱��UserUpdateTime������������Ϊ�������͡�
*/
ALTER TABLE Users ADD UserUpdateTime smalldatetime

--�ڽ�Users���UserSex�е��������͸�Ϊ������1��ʾ���С���0��ʾ��Ů���� 
ALTER TABLE Users ALTER COLUMN UserSex INT

--��ɾ��Users���UserUpdateTime��
ALTER TABLE Users DROP COLUMN UserUpdateTime

--2��ɾ�����ݱ�
DROP TABLE Users

/*
3. ���ݲ���
�����µ��û���¼
*/
INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail)
VALUES('ws','123','Ů','��ɺ','21��30��','�����������йش�','100098','18611983575','ws@cuc.edu.cn')

--���û���Ϊwxy���û��������Ϊ111��
UPDATE Users SET UserPassword ='111' WHERE UserName='ws'

--ɾ����Ϊwxy���û���¼��
DELETE FROM Users WHERE UserName='ws'
