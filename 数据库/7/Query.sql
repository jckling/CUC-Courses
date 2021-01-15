DROP TABLE News;

SELECT COUNT(*)
FROM News

CREATE TABLE News(
	UserID nvarchar(20),
	NewsID nvarchar(20),
	ReadTime date,
	Title nvarchar(100),
	Content ntext,
	PostTime nvarchar(20),
);

--计算该网站每天的pv、uv，按uv从大到小排序
--pv页面访问量，uv不同的用户
SELECT ReadTime, COUNT(*) pv, COUNT(DISTINCT UserID) uv
FROM News
GROUP BY ReadTime
ORDER BY COUNT(DISTINCT UserID) DESC;

--查询3月份十大热点新闻，列出ID及标题
--热点新闻：访问用户最多（非访问量）的新闻
SELECT TOP(10) Title, NewsID, COUNT(DISTINCT UserID) uv
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY Title, NewsID
ORDER BY COUNT(DISTINCT UserID) DESC;


--查询3月份的排名前三的忠实用户
--忠实用户：每天都访问网站的用户
SELECT TOP(4) UserID, COUNT(DISTINCT ReadTime)
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY UserID
ORDER BY COUNT(DISTINCT ReadTime) DESC;


--查询3月份排名前十的活跃用户，按从大到小排序
--活跃用户：用户的日平均访问次数较多的用户
SELECT TOP(10) UserID, COUNT(DISTINCT NewsID)
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY UserID
ORDER BY COUNT(DISTINCT NewsID) DESC;