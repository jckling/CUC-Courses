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

--�������վÿ���pv��uv����uv�Ӵ�С����
--pvҳ���������uv��ͬ���û�
SELECT ReadTime, COUNT(*) pv, COUNT(DISTINCT UserID) uv
FROM News
GROUP BY ReadTime
ORDER BY COUNT(DISTINCT UserID) DESC;

--��ѯ3�·�ʮ���ȵ����ţ��г�ID������
--�ȵ����ţ������û���ࣨ�Ƿ�������������
SELECT TOP(10) Title, NewsID, COUNT(DISTINCT UserID) uv
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY Title, NewsID
ORDER BY COUNT(DISTINCT UserID) DESC;


--��ѯ3�·ݵ�����ǰ������ʵ�û�
--��ʵ�û���ÿ�춼������վ���û�
SELECT TOP(4) UserID, COUNT(DISTINCT ReadTime)
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY UserID
ORDER BY COUNT(DISTINCT ReadTime) DESC;


--��ѯ3�·�����ǰʮ�Ļ�Ծ�û������Ӵ�С����
--��Ծ�û����û�����ƽ�����ʴ����϶���û�
SELECT TOP(10) UserID, COUNT(DISTINCT NewsID)
FROM News
WHERE DATEPART(MONTH, ReadTime)=3
GROUP BY UserID
ORDER BY COUNT(DISTINCT NewsID) DESC;