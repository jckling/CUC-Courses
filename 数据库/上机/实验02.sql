/*****************
实验02  数据查询
*****************/

--（1）查找收藏歌曲在2首以上的用户及其收藏的歌曲数。
SELECT UserName 用户名,COUNT(*) 收藏歌曲数
FROM Collections
GROUP BY UserName HAVING COUNT(*)>= 2

select c.UserName,count(*) from collections c where c.username in (
select distinct(a.username) from collections a inner join collections b
on a.username = b.username where a.songid != b.songid
)
group by c.UserName

--（2）查找所包含的歌曲数大于等于10首的专辑，显示专辑名和所包含的歌曲数。
SELECT AlbumID ,COUNT(*) 歌曲数
FROM Songs
GROUP BY AlbumID HAVING COUNT(*)>=10

--（3）查找最近5年来（GetDate）的专辑销售情况，列出专辑ID、专辑名称、总销售额，按总销售从高到低排名
SELECT Sale.AlbumID,SUM(TotalPrice),AlbumName
 FROM Sale,Orders, Album 
 WHERE Sale.OrderID=Orders.OrderID
 and Sale.AlbumID = Album.AlbumID
 AND YEAR(OrderDate) BETWEEN YEAR(GETDATE())-10  AND YEAR(GETDATE()) 
 GROUP BY Sale.AlbumID,AlbumName
 ORDER BY SUM(TotalPrice)DESC
 
 
 --（4）查询没有被收藏的歌曲
SELECT * 
FROM Songs left OUTER JOIN Collections ON Songs.SongID=Collections.SongID
WHERE Collections.SongID IS NULL
