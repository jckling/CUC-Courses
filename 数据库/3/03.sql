--��1���ڹ����˸�������ר���Ŀͻ��в�ѯһ�ι����������Ŀͻ����û���
SELECT UserName
FROM Sales,Albums,Orders
WHERE Sales.OrderID = Orders.OrderID and Sales.AlbumID = Albums.AlbumID and Albums.AlbumSinger = '����' and Quantity = (
	SELECT Max(Sales.Quantity)
	FROM Sales, Albums
	WHERE Sales.AlbumID = Albums.AlbumID and Albums.AlbumSinger='����'
)

--��2�����ұ������û��ղصĸ���
--������ʵ�ַ�ʽ�����Ƕ�ײ�ѯ�������Ƕ�ײ�ѯ��
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
	
--��3������һ�׸�����û���ղص��û���
--������ʵ�ַ�ʽ�����Ƕ�ײ�ѯ�����Ӳ�ѯ��
--�����ѯ��������û�д��û���Ϊ��ȷ�������׼ȷ�ԣ���Ҫ�Լ���һ������������֤
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
