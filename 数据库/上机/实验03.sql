/*****************
ʵ��03  �������ݲ�ѯ
*****************/

USE NetMusicShop

--��1���ڹ����˸�������ר���Ŀͻ��в�ѯ�����������Ŀͻ���
--�ο�����1���õ�ֵ�Ӳ�ѯ��
SELECT UserName
FROM Orders
WHERE OrderID IN(
     SELECT OrderID 
     FROM Album,Sale
     WHERE Album.AlbumID=Sale.AlbumID AND AlbumSinger='����'
      AND Quantity >= (SELECT MAX(Quantity)
                    FROM Sale
                    WHERE AlbumID IN
                        (SELECT AlbumID
                         FROM Album
                         WHERE AlbumSinger='����')))

--�ο�����2���ö�ֵ�Ӳ�ѯ�� 
SELECT UserName
FROM Orders
WHERE OrderID IN(
     SELECT OrderID 
     FROM  Album,Sale
     WHERE Album.AlbumID=Sale.AlbumID AND AlbumSinger='����'
      AND Quantity>=ALL(SELECT Quantity
                        FROM Sale,Album
                        WHERE Album.AlbumID=Sale.AlbumID
                          AND AlbumSinger='����'))
						  
--��2�����ұ������û��ղصĸ�����
--�ο�����1�������Ƕ�ײ�ѯ��
SELECT *
FROM  Songs  
WHERE NOT EXISTS 
   (SELECT  *
    FROM  Users  
    WHERE NOT EXISTS
        (SELECT  *
         FROM  Collections 
         WHERE UserName=Users.UserName AND SongID=Songs.SongID))

--�ο�����2���ò����Ƕ�ײ�ѯ��
SELECT *
FROM Songs
WHERE SongID IN (SELECT SongID 
                 FROM Collections
                 GROUP BY SongID
                 HAVING COUNT(*) = (SELECT COUNT(*) FROM Users))
				 
--��3������һ�׸�����û���ղص��û���

INSERT INTO Users VALUES('���','888','��','���','�޿ɷ��','������ ������','100033','13577788811','liFeng@cuc.edu.cn','2008-01-01',0.00)
--�ο�����1���������Ӳ�ѯ��
SELECT * 
FROM Users LEFT OUTER JOIN Collections ON Users.UserName=Collections.UserName
WHERE SongID IS NULL 

--�ο�����2�������Ƕ�ײ�ѯ��
SELECT  *
FROM  Users  
WHERE NOT EXISTS 
   (SELECT  *
    FROM  Songs  
    WHERE EXISTS
        (SELECT  *
         FROM  Collections
         WHERE UserName=Users.UserName AND SongID=Songs.SongID))
