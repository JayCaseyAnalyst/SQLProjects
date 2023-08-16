SELECT * 
FROM 
	Pokemon..PokemonData
Order By 2

-- Looking at the strongest pokemon Type on Average
Select 
	[First Type]
	, ROUND(Avg([Stat Total]),0) as AvgStats
From 
	Pokemon..PokemonData
GROUP BY 
	[First Type]
ORDER BY 2 Desc

-- Looking at the Stat difference between Mega and Non-mega Pokemon -- Add Mega/NonMega titles
Select 
	Mega
	, ROUND(Avg([Stat Total]),0) as AvgStats
	, Max(Speed) as MaxSpeed
From 
	Pokemon..PokemonData
Group BY 
	Mega
Order By 2 DESC

-- Classifying Each pokemon based on strength - Filtering out any Mega/Alternate Forms
SELECT 
	[Pokemon Name]
	, [Stat Total]
	,  Case	
		WHEN [Stat Total] <= 200 Then 'Weak'
		When [Stat Total] between 200 and 500 Then 'Average'
		WHEN [Stat Total] > 200 Then 'Strong'
		END AS PokemonStrength
FROM 
	Pokemon..PokemonData
WHERE 
	[Pokemon Name] not like '%(%)%'
Order By [Pokemon Number]


--Creating Temp Table Containing Every mega
DROP TABLE If Exists #tempMegas
CREATE TABLE #tempMegas 
([Pokemon Name] varchar(50)
, [Pokemon Number] int
, [Stat Total] int
, HP int
, Attack int
, Defense int
, [Sp#Atk] int
, [Sp#Def] int
, Speed int
, Mega bit
, [First Type] varchar(50)
, [Second Type] varchar(50)
, Species varchar(50)
, [First Ability] varchar(50)
, [Second Ability] varchar(50)
, [Hidden Ability] varchar(50)
, Generation varchar(50)
, [Egg Group 1] varchar(50)
, [Egg Group 2] varchar(50)
, [Is Sub Legendary] bit
, [Is Legendary] bit
, [Is Mythical] bit
)

INSERT INTO #tempMegas
SELECT * 
FROM 
	Pokemon..PokemonData
WHERE 
	Mega = '1'
-- END TEMP Table

SELECT 
	base.[Pokemon Name]
	, base.[Stat Total] As BaseStats
	, meg.[Stat Total] AS MegaStats
	, (meg.[Stat Total] - base.[Stat Total]) AS MegaIncrease
FROM 
	Pokemon..PokemonData base
	JOIN #tempMegas meg
		ON base.[Pokemon Number] = meg.[Pokemon Number]
WHERE 
	base.mega = '0'
ORDER BY 2 DESC


-- Breaking Down Stat Total by First/Second Type
Select 
	[First Type]
	, [Second Type]
	, ROUND(AVG([Stat Total]), 0) as AvgStats
	, MIN([Stat Total]) as MinStats
	, MAX([Stat Total]) as MaxStats
From 
	Pokemon..PokemonData
GROUP BY 
	[First Type]
	, [Second Type]
ORDER BY 1;



-- Analyzing Strength based on Dual typing Status
-- Using CTE
WITH Typing ([Pokemon Name], [Stat Total], [Types])
AS
(
	SELECT 
		[Pokemon Name]
		, [Stat Total]
		, Case	
			WHEN [Second Type] = 'None' THEN 'Single Type'
			WHEN [Second Type] <> 'None' THEN 'Dual Type'
			END AS [Types]
	FROM 
		Pokemon..PokemonData
	WHERE 
		Mega = '0'
)
SELECT 
	[Types]
	, ROUND(AVG([Stat Total]), 0) AS AvgStats
FROM 
	Typing
GROUP BY 
	[Types]
ORDER BY 2 DESC
--End CTE