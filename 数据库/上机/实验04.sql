/***********************
ʵ��04  ��ͼ�Ĵ��������
***********************/
/*
��ʵ�����ݡ�

1���̼ҿ�չ����200��100���Ĵ������Ϊһ�ι���ĳר���ܼ۸���200Ԫ���������ϵ��û��Ļ�Ա����ֵ100Ԫ��
UPDATE Users*/
SET UserAdvancePayment = UserAdvancePayment + 100
WHERE  UserName IN (SELECT UserName 
                    FROM Sale,Orders 
                    WHERE Sale.OrderID=Orders.OrderID
                      AND TotalPrice >= 200)

--2���½���ר������ͳ�Ʊ�Sales_Statis����ṹ�ܴ��ר�����������������۶������ר�������������۶��ͳ�ƽ������Sales_Statis���С�
CREATE TABLE Sales_Statis
(AlbumName   varchar(64),
 SumQuantity int,       
 SumPrice    numeric(10,2))

INSERT INTO Sales_Statis(AlbumName,SumQuantity,SumPrice)
 SELECT AlbumName ,SUM(Quantity),SUM(TotalPrice) 
 FROM  Album,Sale
 WHERE Album.AlbumID=Sale.AlbumID
 GROUP BY AlbumName  

--3. ��ͼ�Ĵ���
--����ר����Ϊ����ʮ�������ĸ�����ͼSongsByAlbumName������ͼ�������������е������У���������˳�����С�������С�

USE NetMusicShop

CREATE VIEW SongsByAlbumName 
AS 
  SELECT TOP(1000) Songs.*
  FROM Songs,Album
  WHERE Songs.AlbumID=Album.AlbumID AND AlbumName='��ʮ����'
  ORDER BY SongNumber
  
--select count(*) from songs

--3���鿴��ͼ�Ķ���
--EXEC sp_helptext SongsByAlbumName

--4. ��ͼ�Ĳ�ѯ
SELECT * FROM SongsByAlbumName

--5. ��SongsByAlbumName��ͼ�Ĳ�ѯ�����ɡ���ʮ��������ΪF��ONE��
ALTER VIEW SongsByAlbumName 
AS 
  SELECT TOP 10 Songs.*
  FROM Songs,Album
  WHERE Songs.AlbumID=Album.AlbumID AND AlbumName='F��ONE'
  ORDER BY SongNumber
  
--6��������ͼSongIdΪ52�ĸ����޸ĸ�������Ϊ������2015��
UPDATE SongsByAlbumName SET SongTitle = '����2015' WHERE SongID = 52

--7��������ͼSongIdΪ52�ĸ����޸ĸ�������Ϊ������2015����ר�������޸�Ϊ��ħ������
UPDATE SongsByAlbumName SET SongTitle = '����2015', AlbumName = 'ħ����' WHERE SongID = 52

--8. ��ͼ��ɾ��
DROP VIEW SongsByAlbumName
