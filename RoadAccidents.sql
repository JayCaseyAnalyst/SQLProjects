-- SELECT * FROM [Road Accident]..road_accident

-- Current Year Casualties (2022) For Dry Surface Conditions
SELECT
	SUM(number_of_casualties) AS CY_Casualties
FROM 
	[Road Accident]..road_accident
WHERE
	YEAR(accident_date) = '2022' 
	--AND road_surface_conditions = 'Dry'


-- 2022 Accidents
SELECT
	COUNT(DISTINCT accident_index) AS CY_Accidents
FROM 
	[Road Accident]..road_accident
WHERE
	YEAR(accident_date) = '2022' 
	--AND road_surface_conditions = 'Dry'

-- 2022 Fatal Casualties
SELECT
	SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM 
	[Road Accident]..road_accident
WHERE
	YEAR(accident_date) = '2022' 
	AND accident_severity = 'Fatal'
	--AND road_surface_conditions = 'Dry'

-- 2022 Serious Casualties
SELECT
	SUM(number_of_casualties) AS CY_Serious_Casualties
FROM 
	[Road Accident]..road_accident
WHERE
	YEAR(accident_date) = '2022' 
	AND accident_severity = 'Serious'
	--AND road_surface_conditions = 'Dry'

-- 2022 Slight Casualties
SELECT
	SUM(number_of_casualties) AS CY_Slight_Casualties
FROM 
	[Road Accident]..road_accident
WHERE
	YEAR(accident_date) = '2022' 
	AND accident_severity = 'Slight'
	--AND road_surface_conditions = 'Dry'

-- 2022 Casualties by Severity
SELECT
	accident_severity
	, SUM(number_of_casualties) AS CY_Casualties
FROM 
	[Road Accident]..road_accident
WHERE 
	YEAR(accident_date) = '2022'
GROUP BY
	accident_severity
ORDER BY 
	1

-- 2022 Accidents by Light Conditions
SELECT 
	light_conditions
	, COUNT(DISTINCT accident_index) AS CY_Accidents
FROM
	[Road Accident]..road_accident
WHERE 
	YEAR(accident_date) = '2022'
GROUP BY 
	light_conditions
ORDER BY 
	2 DESC

-- 2022 Accidents by Road Conditions
SELECT 
	road_surface_conditions
	, COUNT(DISTINCT accident_index) AS CY_Accidents
FROM
	[Road Accident]..road_accident
WHERE 
	YEAR(accident_date) = '2022'
GROUP BY 
	road_surface_conditions
ORDER BY 
	2 DESC
