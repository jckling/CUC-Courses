--（1）在购买了歌手刘欢专辑的客户中查询一次购买数量最多的客户的用户名
SELECT UserName
FROM Sales,Albums,Orders
WHERE Sales.OrderID = Orders.OrderID and Sales.AlbumID = Albums.AlbumID and Albums.AlbumSinger = '刘欢' and Quantity = (
	SELECT Max(Sales.Quantity)
	FROM Sales, Albums
	WHERE Sales.AlbumID = Albums.AlbumID and Albums.AlbumSinger='刘欢'
)

--（2）查找被所有用户收藏的歌曲
--（两种实现方式：相关嵌套查询、不相关嵌套查询）
SELECT *
FROM Songs
WHERE NOT EXISTS
(
	SELECT *
	FROM Users
	WHERE NOT EXISTS
	(
		SELECT *
		FROM Collections
		WHERE Collections.UserName = Users.UserName and Collections.SongID = Songs.SongID
	)
)


SELECT *
FROM Songs
WHERE Songs.SongID IN
(	
	SELECT SongID
	FROM Collections
	GROUP BY Collections.SongID HAVING COUNT(*) = 
	(
		SELECT COUNT(*)
		FROM Users
	)
)
	
--（3）查找一首歌曲都没有收藏的用户。
--（两种实现方式：相关嵌套查询、连接查询）
--如果查询出来发现没有此用户，为了确保命令的准确性，需要自己造一两条数据来验证
SELECT *
FROM Users
WHERE UserName NOT IN
(
	SELECT DISTINCT UserName
	FROM Collections
)


SELECT *
FROM Users
WHERE NOT EXISTS
(
	SELECT *
	FROM Collections
	WHERE Users.UserName = Collections.UserName
)

SELECT *
FROM Users left join Collections on Users.UserName = Collections.UserName
WHERE SongID is NULL
