-- Ϊһ�ι���ĳר���ܼ۸���200Ԫ���������ϵ��û��Ļ�Ա����ֵ100Ԫ
--���ֶΣ�User���UserAdvancePayment����ֻ��ֵһ�Σ�
UPDATE Users SET Users.UserAdvancePayment = 100
WHERE Users.UserName IN
(
	SELECT DISTINCT Users.UserName
	FROM Users, Orders
	WHERE Users.UserName = Orders.UserName and Orders.GoodsFee >= 200
)

-- �½���ר������ͳ�Ʊ�Sales_Statis����ṹ�ܴ��ר�����������������۶�
-- ������ר�������������۶��ͳ�ƽ������Sales_Statis����
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

-- ����ר����Ϊ����ʮ�������ĸ�����ͼSongsByAlbumName
-- ����ͼ�������������е��������Լ�ר�����ƣ���������˳�����С��������
CREATE VIEW SongsByAlbumName AS
SELECT TOP(10000) Albums.AlbumName, Songs.*
FROM Albums, Songs
WHERE Albums.AlbumID = Songs.AlbumID and Albums.AlbumName = '��ʮ����'
ORDER BY Songs.SongID

-- ��ѯ��ͼ
SELECT *
FROM SongsByAlbumName
-- ����ͼ��ѡ������SongId���޸ĸ�������Ϊ������2017��
UPDATE SongsByAlbumName 
SET SongTitle = '����2017'
WHERE SongID = 6

-- ����ͼ��ѡ������SongId���޸ĸ�������Ϊ������2018����ר�������޸�Ϊ��ħ������
UPDATE SongsByAlbumName 
SET SongTitle = '����2018', AlbumName = 'ħ����'
WHERE SongID = 6 -- ��ͼ���� 'SongsByAlbumName' ���ɸ��£���Ϊ�޸Ļ�Ӱ��������

-- ɾ����ͼ
DROP VIEW SongsByAlbumName