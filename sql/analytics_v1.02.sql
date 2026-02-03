-- The latest date on fact_crime_offenses
select max(incident_date)
from fact_crime_offenses;
-- 2026-01-16

select *
from fact_crime_offenses
limit 5;
-- Monthly incidents count
select date_format(incident_date, '%y-%m') as ym
	 , count(*) as Total_incidents
from fact_crime_offenses
where incident_date is not null
group by ym
order by ym desc
limit 5;

-- Month over month (MoM) incidents change and percent change
with m as (
				select date_format(incident_date, '%y-%m') as ym
					 , count(*) as Total_incidents
				from fact_crime_offenses
				where incident_date is not null
				group by ym
				order by ym desc 
)

select ym
	 , Total_incidents
     , lag(Total_incidents) over (order by ym) as Previous_Month_Incidents
     , round(((Total_incidents - lag(Total_incidents) over (order by ym)) / nullif(lag(Total_incidents) over (order by ym), 0)) * 100, 2) as MoM_pct_change
from m
order by ym desc
limit 5;

--  Recent 30 days vs previous 30 days total incidents changes (from the latest date of incident_date)
select sum(incident_date >= (select max(incident_date) from fact_crime_offenses) - interval 30 day) as last_30_days
	 , sum(incident_date between (select max(incident_date) from fact_crime_offenses) - interval 60 day 
		   and (select max(incident_date) from fact_crime_offenses) - interval 31 day) as previous_30_days
from fact_crime_offenses
where incident_date is not null;

-- Day of week Crime Patterns
select dayname(incident_date) as day_name
	 , count(incident_id) as total_incidents
from fact_crime_offenses
group by day_name
order by total_incidents desc;

-- Hour of day Crime Patterns
select hour(first_occurrence_dt) as hour_of_day
	 , count(incident_address) as total_incidents
from fact_crime_offenses
where first_occurrence_dt is not null
group by hour_of_day
order by total_incidents desc;

-- Total incidents per district (high-level resource planning)
select district_id
	 , count(*) as total_incidents
from fact_crime_offenses
group by district_id
order by total_incidents desc;

-- Total incidents per district for the last 30 days (rapid situational awareness)
select district_id
	 , count(*) as total_incidents_last_30days
from fact_crime_offenses
-- last 30 days from 1/16/2026(the latest date when the data was updated)
where incident_date >= (select max(incident_date) from fact_crime_offenses) - interval 30 day
group by district_id
order by total_incidents_last_30days desc;

-- Top 20 crime neighborhoods (hotspot candidates)
select neighborhood_id
	 , count(*) as total_incidents
from fact_crime_offenses
group by neighborhood_id
order by total_incidents desc
limit 20;

-- Top 10 offense categories
select offense_category_id
	 , count(*) as total_incidents
from fact_crime_offenses
group by offense_category_id
order by total_incidents desc
limit 10;

-- Top 10 offense type
select offense_type_id
	 , count(*) as total_incidents
from fact_crime_offenses
group by offense_type_id
order by 2 desc
limit 10;

-- Offense category share % by month
WITH m AS (
	SELECT DATE_FORMAT(incident_date, '%Y-%m') AS ym
		 , offense_category_id
         , COUNT(*) AS incidents
  FROM fact_crime_offenses
  WHERE incident_date IS NOT NULL
  GROUP BY ym, offense_category_id
)
, t AS (
	SELECT ym
		 , SUM(incidents) AS total_incidents
	FROM m
	GROUP BY ym
)
SELECT m.ym
	 , m.offense_category_id
     , m.incidents
     , ROUND(100 * m.incidents / NULLIF(t.total_incidents, 0), 2) AS share_pct
FROM m
JOIN t USING (ym)
ORDER BY m.ym, share_pct DESC;

-- District x Offense Category (where certain categories concentrate)
SELECT district_id
	 , offense_category_id
     , COUNT(*) AS incidents
FROM fact_crime_offenses
GROUP BY district_id, offense_category_id
HAVING COUNT(*) >= 100
ORDER BY incidents DESC;

-- Nighttime share by district (20:00–04:00)
WITH d AS (
	SELECT district_id
		 , COUNT(*) AS total_incidents
         , SUM(CASE
					WHEN HOUR(first_occurrence_dt) >= 20 OR HOUR(first_occurrence_dt) <= 4 THEN 1
                    ELSE 0
				END) AS night_incidents
	FROM fact_crime_offenses
	WHERE first_occurrence_dt IS NOT NULL
	GROUP BY district_id
)
SELECT district_id
	 , total_incidents
     , night_incidents
     , ROUND(100 * night_incidents / NULLIF(total_incidents, 0), 2) AS night_share_pct
FROM d
ORDER BY night_share_pct DESC;

-- Hotspot grid (Accuracy to two decimal places)
SELECT ROUND(geo_lat, 2) AS lat_grid
	 , ROUND(geo_lon, 2) AS lon_grid
     , COUNT(*) AS incidents
FROM fact_crime_offenses
WHERE geo_lat IS NOT NULL AND geo_lon IS NOT NULL
GROUP BY lat_grid, lon_grid
HAVING COUNT(*) >= 50
ORDER BY incidents DESC
LIMIT 50;

-- Emerging hotspots: last 30 days vs previous 30 days (grid delta)
WITH grid_60 AS (
	SELECT ROUND(geo_lat, 2) AS lat_grid
		 , ROUND(geo_lon, 2) AS lon_grid
         , SUM(incident_date >= (select max(incident_date) from fact_crime_offenses) - INTERVAL 30 DAY) AS last_30
         , SUM(incident_date BETWEEN (select max(incident_date) from fact_crime_offenses) - INTERVAL 60 DAY AND (select max(incident_date) from fact_crime_offenses) - INTERVAL 31 DAY) AS prev_30
  FROM fact_crime_offenses
  WHERE incident_date IS NOT NULL
    AND geo_lat IS NOT NULL AND geo_lon IS NOT NULL
  GROUP BY lat_grid, lon_grid
)
SELECT lat_grid
	 , lon_grid
     , last_30
     , prev_30
     , (last_30 - prev_30) AS difference
     , ROUND(100 * (last_30 - prev_30) / NULLIF(prev_30, 0), 2) AS growth_pct
FROM grid_60
WHERE last_30 >= 10
ORDER BY difference DESC
LIMIT 30;