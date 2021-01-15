USE NetMusicShop;

CREATE TABLE Collections(
	SongID          tinyint,
	UserName        varchar(20),
	CollectionDate	smalldatetime,
	CONSTRAINT [PK_Collections_SU] PRIMARY KEY	--��������
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

-- �����ղظ�����2�׼����ϵ��û������ղصĸ�����
SELECT UserName, COUNT(SongID) SongNumber
FROM Collections
GROUP BY UserName HAVING COUNT(SongID)>=2;
-- �ڶ��ַ���
SELECT A.UserName, A.total
FROM (SELECT UserName, COUNT(*) total FROM Collections GROUP BY UserName) A
WHERE A.total>=2;

-- �����������ĸ��������ڵ���10�׵�ר������ʾר�������������ĸ�����
SELECT AlbumName, B.total SongNumber
FROM Albums,
(	SELECT AlbumID, COUNT(SongID) total
	FROM Songs
	GROUP BY AlbumID HAVING COUNT(SongID) >= 10
) B
WHERE Albums.AlbumID = B.AlbumID
-- �ڶ��ַ���
SELECT Albums.AlbumName, MAX(Songs.SongNumber) SongNumber
FROM Albums, Songs
WHERE Albums.AlbumID = Songs.AlbumID
GROUP BY Songs.AlbumID,Albums.AlbumName HAVING MAX(Songs.SongNumber)>=10

-- �������10������GetDate����ר������������г�ר��ID��ר�����ơ������۶�������۴Ӹߵ�������
SELECT Sales.AlbumID, Albums.AlbumName, SUM(Sales.TotalPrice)
FROM Sales join Albums ON Sales.AlbumID = Albums.AlbumID
WHERE Sales.OrderID IN
(	SELECT Orders.OrderID
	FROM Orders
	WHERE Orders.OrderDate >= YEAR(GetDate())-10
)
GROUP BY Sales.AlbumID, Albums.AlbumName
ORDER BY SUM(Sales.TotalPrice) DESC;

-- ��ѯû�б��ղع��ĸ���
SELECT SongID, Songtitle
FROM Songs
WHERE SongID NOT IN
(	SELECT SongID
	FROM Collections
	WHERE Songs.SongID = Collections.SongID
);