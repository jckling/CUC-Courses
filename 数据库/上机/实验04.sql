/***********************
实验04  视图的创建与管理
***********************/
/*
【实验内容】

1、商家开展“买200赠100”的促销活动，为一次购买某专辑总价格在200元（含）以上的用户的会员卡充值100元。
UPDATE Users*/
SET UserAdvancePayment = UserAdvancePayment + 100
WHERE  UserName IN (SELECT UserName 
                    FROM Sale,Orders 
                    WHERE Sale.OrderID=Orders.OrderID
                      AND TotalPrice >= 200)

--2、新建“专辑销售统计表”Sales_Statis，其结构能存放专辑名、销售量和销售额。将各个专辑销售量和销售额的统计结果存入Sales_Statis表中。
CREATE TABLE Sales_Statis
(AlbumName   varchar(64),
 SumQuantity int,       
 SumPrice    numeric(10,2))

INSERT INTO Sales_Statis(AlbumName,SumQuantity,SumPrice)
 SELECT AlbumName ,SUM(Quantity),SUM(TotalPrice) 
 FROM  Album,Sale
 WHERE Album.AlbumID=Sale.AlbumID
 GROUP BY AlbumName  

--3. 视图的创建
--创建专辑名为“三十而立”的歌曲视图SongsByAlbumName，该视图包括“歌曲表”中的所有列，并按歌曲顺序号由小到大排列。

USE NetMusicShop

CREATE VIEW SongsByAlbumName 
AS 
  SELECT TOP(1000) Songs.*
  FROM Songs,Album
  WHERE Songs.AlbumID=Album.AlbumID AND AlbumName='三十而立'
  ORDER BY SongNumber
  
--select count(*) from songs

--3、查看视图的定义
--EXEC sp_helptext SongsByAlbumName

--4. 视图的查询
SELECT * FROM SongsByAlbumName

--5. 将SongsByAlbumName视图的查询条件由“三十而立”改为F．ONE。
ALTER VIEW SongsByAlbumName 
AS 
  SELECT TOP 10 Songs.*
  FROM Songs,Album
  WHERE Songs.AlbumID=Album.AlbumID AND AlbumName='F．ONE'
  ORDER BY SongNumber
  
--6、将此视图SongId为52的歌曲修改歌曲名称为“北京2015”
UPDATE SongsByAlbumName SET SongTitle = '北京2015' WHERE SongID = 52

--7、将此视图SongId为52的歌曲修改歌曲名称为“北京2015”，专辑名称修改为“魔杰座”
UPDATE SongsByAlbumName SET SongTitle = '北京2015', AlbumName = '魔杰座' WHERE SongID = 52

--8. 视图的删除
DROP VIEW SongsByAlbumName
