-- 为一次购买某专辑总价格在200元（含）以上的用户的会员卡充值100元
--（字段：User表的UserAdvancePayment）（只充值一次）
UPDATE Users SET Users.UserAdvancePayment = 100
WHERE Users.UserName IN
(
	SELECT DISTINCT Users.UserName
	FROM Users, Orders
	WHERE Users.UserName = Orders.UserName and Orders.GoodsFee >= 200
)

-- 新建“专辑销售统计表”Sales_Statis，其结构能存放专辑名、销售量和销售额
-- 将各个专辑销售量和销售额的统计结果存入Sales_Statis表中
CREATE TABLE Sales_Statis
(
	AlbumName varchar(64),
	Price numeric(10, 2),
	Quantity tinyint
)
INSERT INTO Sales_Statis (AlbumName, Price, Quantity)
(
	SELECT Albums.AlbumName, IsNull(SUM(Sales.TotalPrice),0), IsNull(SUM(Sales.Quantity),0)
	FROM Albums
	LEFT JOIN Sales ON Albums.AlbumID = Sales.AlbumID
	GROUP BY Albums.AlbumName
)

-- 创建专辑名为“三十而立”的歌曲视图SongsByAlbumName
-- 该视图包括“歌曲表”中的所有列以及专辑名称，并按歌曲顺序号由小到大排列
CREATE VIEW SongsByAlbumName AS
SELECT TOP(10000) Albums.AlbumName, Songs.*
FROM Albums, Songs
WHERE Albums.AlbumID = Songs.AlbumID and Albums.AlbumName = '三十而立'
ORDER BY Songs.SongID

-- 查询视图
SELECT *
FROM SongsByAlbumName
-- 将视图中选择任意SongId，修改歌曲名称为“北京2017”
UPDATE SongsByAlbumName 
SET SongTitle = '北京2017'
WHERE SongID = 6

-- 将视图中选择任意SongId，修改歌曲名称为“北京2018”，专辑名称修改为“魔杰座”
UPDATE SongsByAlbumName 
SET SongTitle = '北京2018', AlbumName = '魔杰座'
WHERE SongID = 6 -- 视图或函数 'SongsByAlbumName' 不可更新，因为修改会影响多个基表

-- 删除视图
DROP VIEW SongsByAlbumName