/*****************
ʵ��02  ���ݲ�ѯ
*****************/

--��1�������ղظ�����2�����ϵ��û������ղصĸ�������
SELECT UserName �û���,COUNT(*) �ղظ�����
FROM Collections
GROUP BY UserName HAVING COUNT(*)>= 2

select c.UserName,count(*) from collections c where c.username in (
select distinct(a.username) from collections a inner join collections b
on a.username = b.username where a.songid != b.songid
)
group by c.UserName

--��2�������������ĸ��������ڵ���10�׵�ר������ʾר�������������ĸ�������
SELECT AlbumID ,COUNT(*) ������
FROM Songs
GROUP BY AlbumID HAVING COUNT(*)>=10

--��3���������5������GetDate����ר������������г�ר��ID��ר�����ơ������۶�������۴Ӹߵ�������
SELECT Sale.AlbumID,SUM(TotalPrice),AlbumName
 FROM Sale,Orders, Album 
 WHERE Sale.OrderID=Orders.OrderID
 and Sale.AlbumID = Album.AlbumID
 AND YEAR(OrderDate) BETWEEN YEAR(GETDATE())-10  AND YEAR(GETDATE()) 
 GROUP BY Sale.AlbumID,AlbumName
 ORDER BY SUM(TotalPrice)DESC
 
 
 --��4����ѯû�б��ղصĸ���
SELECT * 
FROM Songs left OUTER JOIN Collections ON Songs.SongID=Collections.SongID
WHERE Collections.SongID IS NULL
