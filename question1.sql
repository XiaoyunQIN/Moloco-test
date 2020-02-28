-- Question 1
SELECT count(distinct user_id) as unique_users,site_id
FROM `datamining-project-260903.molocoDS.ds` 
WHERE country_id = "BDV"
GROUP BY site_id 
ORDER BY unique_users desc
limit 1
-- Question 2
SELECT user_id,site_id,count(*) as num_visits
FROM `datamining-project-260903.molocoDS.ds` 
WHERE ts between "2019-02-03" and "2019-02-05"
GROUP BY site_id, user_id
HAVING num_visits > 10

-- Question 3
SELECT site_id,count(distinct user_id) as last_visit_num
FROM (
	SELECT user_id,site_id,ts,row_number() over (Partition by user_id order by ts desc)
	as visit_rk
	FROM `datamining-project-260903.molocoDS.ds` )
WHERE visit_rk = 1
GROUP BY site_id
ORDER BY last_visit_num desc
LIMIT 3

-- Question 4
SELECT count(*)
FROM
	(SELECT t1.user_id as user_id, first_site,last_site 
	FROM (
		SELECT ds.user_id, ds.site_id as first_site
		FROM  `datamining-project-260903.molocoDS.ds` ds
		INNER JOIN (
			SELECT distinct user_id, min(ts) as ts,
			FROM `datamining-project-260903.molocoDS.ds`
			GROUP BY user_id) s1
		ON ds.user_id = s1.user_id and ds.ts=s1.ts) t1
	FULL JOIN (
		SELECT ds.user_id, ds.site_id as last_site
		FROM  `datamining-project-260903.molocoDS.ds` ds
		INNER JOIN (
			SELECT distinct user_id, max(ts) as ts,
			FROM `datamining-project-260903.molocoDS.ds`
			GROUP BY user_id) s2
		ON ds.user_id = s2.user_id and ds.ts=s2.ts) t2
	ON t1.user_id = t2.user_id
	WHERE first_site = last_site)


