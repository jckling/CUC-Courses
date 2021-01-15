/*****************
实验03  复杂数据查询
*****************/

USE NetMusicShop

--（1）在购买了歌手刘欢专辑的客户中查询购买数量最多的客户。
--参考代码1：用单值子查询。
SELECT UserName
FROM Orders
WHERE OrderID IN(
     SELECT OrderID 
     FROM Album,Sale
     WHERE Album.AlbumID=Sale.AlbumID AND AlbumSinger='刘欢'
      AND Quantity >= (SELECT MAX(Quantity)
                    FROM Sale
                    WHERE AlbumID IN
                        (SELECT AlbumID
                         FROM Album
                         WHERE AlbumSinger='刘欢')))

--参考代码2：用多值子查询。 
SELECT UserName
FROM Orders
WHERE OrderID IN(
     SELECT OrderID 
     FROM  Album,Sale
     WHERE Album.AlbumID=Sale.AlbumID AND AlbumSinger='刘欢'
      AND Quantity>=ALL(SELECT Quantity
                        FROM Sale,Album
                        WHERE Album.AlbumID=Sale.AlbumID
                          AND AlbumSinger='刘欢'))
						  
--（2）查找被所有用户收藏的歌曲。
--参考代码1：用相关嵌套查询。
SELECT *
FROM  Songs  
WHERE NOT EXISTS 
   (SELECT  *
    FROM  Users  
    WHERE NOT EXISTS
        (SELECT  *
         FROM  Collections 
         WHERE UserName=Users.UserName AND SongID=Songs.SongID))

--参考代码2：用不相关嵌套查询。
SELECT *
FROM Songs
WHERE SongID IN (SELECT SongID 
                 FROM Collections
                 GROUP BY SongID
                 HAVING COUNT(*) = (SELECT COUNT(*) FROM Users))
				 
--（3）查找一首歌曲都没有收藏的用户。

INSERT INTO Users VALUES('李峰','888','男','李峰','无可奉告','北京市 西城区','100033','13577788811','liFeng@cuc.edu.cn','2008-01-01',0.00)
--参考代码1：用外连接查询。
SELECT * 
FROM Users LEFT OUTER JOIN Collections ON Users.UserName=Collections.UserName
WHERE SongID IS NULL 

--参考代码2：用相关嵌套查询。
SELECT  *
FROM  Users  
WHERE NOT EXISTS 
   (SELECT  *
    FROM  Songs  
    WHERE EXISTS
        (SELECT  *
         FROM  Collections
         WHERE UserName=Users.UserName AND SongID=Songs.SongID))
