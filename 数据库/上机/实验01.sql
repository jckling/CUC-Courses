/***************************
实验01 数据表的创建与管理
***************************/
/*
【实验内容】
1.数据表的创建
创建“用户表”Users
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

--创建“专辑表”Album
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
2. 数据表的管理
1）修改数据表
①向Users表增加“修改时间”列UserUpdateTime，其数据类型为短日期型。
*/
ALTER TABLE Users ADD UserUpdateTime smalldatetime

--②将Users表的UserSex列的数据类型改为整数，1表示“男”，0表示“女”。 
ALTER TABLE Users ALTER COLUMN UserSex INT

--③删除Users表的UserUpdateTime列
ALTER TABLE Users DROP COLUMN UserUpdateTime

--2）删除数据表
DROP TABLE Users

/*
3. 数据操纵
插入新的用户记录
*/
INSERT INTO Users(UserName,UserPassword,UserSex,UserRealName,UserAgeRange,UserAddress,UserPostCode,UserPhone,UserEmail)
VALUES('ws','123','女','王珊','21～30岁','北京海淀区中关村','100098','18611983575','ws@cuc.edu.cn')

--将用户名为wxy的用户的密码改为111。
UPDATE Users SET UserPassword ='111' WHERE UserName='ws'

--删除名为wxy的用户记录。
DELETE FROM Users WHERE UserName='ws'
