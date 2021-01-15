USE NetMusicShop;

CREATE TABLE Collections(
	SongID          tinyint,
	UserName        varchar(20),
	CollectionDate	smalldatetime,
	CONSTRAINT [PK_Collections_SU] PRIMARY KEY	--联合主键
	(
		SongID,
		UserName
	)
);

CREATE TABLE Orders(
	OrderID				tinyint IDENTITY PRIMARY KEY,
	OrderDate			smalldatetime NULL,
	UserName			nvarchar(20) null,	--unicode
	GoodsFee			numeric(8,2) null,
	DeliverFee			numeric(8,2) null,
	DeliverID			tinyint null,
	AreaID				tinyint null,
	PaymentID			tinyint null,
	ReceiverName		nvarchar(20) null,	--unicode
	ReceiverAddress		nvarchar(256) null,	--unicode
	ReceiverPostCode	nchar(6) null,	--unicode
	ReceiverPhone		nvarchar(32) null,	--unicode
	ReceiverEmail		nvarchar(50) null,	--unicode
	OrderIsPayment		bit null,
	OrderIsConsignment	bit null,
	OrderIsConfirm		bit null,
	OrderIsPigeonhole	bit null
);

CREATE TABLE Sales(
	OrderID		tinyint,
	AlbumID		tinyint,
	Quantity	tinyint null,
	TotalPrice	numeric(10, 2) null,
	CONSTRAINT [PK_Sales_OA] PRIMARY KEY
	(
		OrderID,
		AlbumID
	)
);

CREATE TABLE MusicCategory(
	CategoryID			tinyint identity PRIMARY KEY,
	CategoryName		nvarchar(20) not null,	--unicode
	CategoryImageUrl	nvarchar(200) null		--unicode
);

-- 查找收藏歌曲在2首及以上的用户及其收藏的歌曲数
SELECT UserName, COUNT(SongID) SongNumber
FROM Collections
GROUP BY UserName HAVING COUNT(SongID)>=2;
-- 第二种方法
SELECT A.UserName, A.total
FROM (SELECT UserName, COUNT(*) total FROM Collections GROUP BY UserName) A
WHERE A.total>=2;

-- 查找所包含的歌曲数大于等于10首的专辑，显示专辑名和所包含的歌曲数
SELECT AlbumName, B.total SongNumber
FROM Albums,
(	SELECT AlbumID, COUNT(SongID) total
	FROM Songs
	GROUP BY AlbumID HAVING COUNT(SongID) >= 10
) B
WHERE Albums.AlbumID = B.AlbumID
-- 第二种方法
SELECT Albums.AlbumName, MAX(Songs.SongNumber) SongNumber
FROM Albums, Songs
WHERE Albums.AlbumID = Songs.AlbumID
GROUP BY Songs.AlbumID,Albums.AlbumName HAVING MAX(Songs.SongNumber)>=10

-- 查找最近10年来（GetDate）的专辑销售情况，列出专辑ID、专辑名称、总销售额，按总销售从高到低排名
SELECT Sales.AlbumID, Albums.AlbumName, SUM(Sales.TotalPrice)
FROM Sales join Albums ON Sales.AlbumID = Albums.AlbumID
WHERE Sales.OrderID IN
(	SELECT Orders.OrderID
	FROM Orders
	WHERE Orders.OrderDate >= YEAR(GetDate())-10
)
GROUP BY Sales.AlbumID, Albums.AlbumName
ORDER BY SUM(Sales.TotalPrice) DESC;

-- 查询没有被收藏过的歌曲
SELECT SongID, Songtitle
FROM Songs
WHERE SongID NOT IN
(	SELECT SongID
	FROM Collections
	WHERE Songs.SongID = Collections.SongID
);