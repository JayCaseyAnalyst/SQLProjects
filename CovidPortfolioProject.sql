SELECT *
FROM RunningPopulationVaccinated

SELECT *
FROM 
	PortfolioProject1..CovidDeaths
ORDER BY 3,4

SELECT *
FROM 
	PortfolioProject1..CovidVaccinations
ORDER BY 3,4

--Initial View of Used fields in CovidDeaths Table
SELECT 
	Location
	, date
	, total_cases
	, new_cases
	, total_deaths
	, population
FROM 
	PortfolioProject1..CovidDeaths
WHERE 
	continent is not null
ORDER BY 1,2


--Looking At Total Cases vs. Total Deaths
--Shows likelihood of Dying if you contract Covid in your Country
SELECT 
	location
	, date
	, total_cases
	, total_deaths
	, ROUND((total_deaths/total_cases)*100.00, 3) As DeathPercentage
	, MAX(total_deaths) OVER (PARTITION BY Location) AS CurrentTotalDeaths
FROM 
	PortfolioProject1..CovidDeaths
--WHERE 
	--location like '%states'
WHERE 
	continent is not null
ORDER BY 1,2


--Looking at Total Cases vs Population
--Shows the Percent of population that contracted Covid
SELECT 
	location
	, date
	, population
	, total_cases
	, ROUND((total_cases/population)*100.00, 3) As CovidInfection
FROM 
	PortfolioProject1..CovidDeaths
WHERE 
	location like '%states%' 
	AND continent IS NOT NUll
ORDER BY 1,2


--Looking at Countries with highest Infection Rate Compared to Population
SELECT 
	Location
	, Population
	, MAX(total_cases) as HighestInfectionCount
	, MAX((total_cases/population)*100.00) As PercentCovidInfection
FROM
	PortfolioProject1..CovidDeaths
WHERE 
	continent is not null
GROUP BY 
	Location
	, Population
Order By PercentCovidInfection DESC


--Showing Countries with highest Death Count per Population
SELECT 
	Location
	, MAX(total_deaths) as TotalDeathCount
FROM 
	PortfolioProject1..CovidDeaths
WHERE 
	continent is not null
GROUP BY 
	Location
Order By TotalDeathCount DESC


--Looking at Total Full Vaccinations By Country
SELECT 
	location
	, MAX(Cast(people_fully_vaccinated as int)) as TotalFullyVaccinated
	, (MAX(Cast(people_fully_vaccinated as int))/MAX(population))*100 AS PercentFullyVaccinated
FROM 
	PortfolioProject1..CovidVaccinations
WHERE
	continent is not null
GROUP BY 
	location
ORDER BY 2 DESC

--Breaking it down by Continent

--Showing Continents with highest Death Count per Population
SELECT 
	continent
	, MAX(total_deaths) as TotalDeathCount
FROM 
	PortfolioProject1..CovidDeaths
WHERE 
	continent is not null
GROUP BY 
	continent
Order By TotalDeathCount DESC

--Total Full Vacinations by Continent
SELECT 
	continent
	, MAX(Cast(people_fully_vaccinated as int)) as TotalFullyVaccinated
	, (MAX(Cast(people_fully_vaccinated as int))/MAX(population))*100 AS PercentFullyVaccinated
FROM 
	PortfolioProject1..CovidVaccinations
WHERE 
	continent is not null
GROUP BY 
	continent
ORDER BY 2 DESC


--Global Numbers

--Covid Cases by Day
SELECT 
	date
	, SUM(new_cases) as TotalNewCases
	, SUM(new_deaths) AS TotalNewDeaths
	, (SUM(new_deaths)/SUM(new_cases))*100 As DeathPercentage
FROM
	PortfolioProject1..CovidDeaths
--WHERE 
	--location LIKE '%states%
WHERE 
	continent is not null 
GROUP BY 
	date
HAVING 
	SUM(new_cases) <> 0
ORDER BY 1,2


--Global Cases/Deaths/Vaccinations
SELECT 
	SUM(dea.new_cases) as TotalCases
	, SUM(dea.new_deaths) AS TotalDeaths
	, (SUM(dea.new_deaths)/SUM(dea.new_cases))*100 As DeathPercentage
	, SUM(vac.new_vaccinations) AS TotalVaccinations
FROM 
	PortfolioProject1..CovidDeaths dea
	JOIN PortfolioProject1..CovidVaccinations vac
		ON dea.location = vac.location AND dea.date = vac.date
--WHERE 
	--location LIKE '%states%
WHERE
	dea.continent is not null
--GROUP BY date
--HAVING SUM(dea.new_cases) <> 0
ORDER BY 1,2;


--Looking at total Population Vs Vaccinations 
--Using CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
	SELECT 
		dea.continent
		, dea.location
		, dea.date
		, dea.population
		, vac.new_vaccinations
		, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RunningPeopleVaccinated
	FROM
		PortfolioProject1..CovidDeaths dea
		JOIN PortfolioProject1..CovidVaccinations vac
			ON dea.location = vac.location 
			AND dea.date = vac.date
	WHERE
		dea.continent is not null 
	--ORDER BY 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 AS RollingPercentVaccinated
From PopvsVac;


--USING TEMP TABLE
--DROP TABLE if exists #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--Population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--	, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RunningPeopleVaccinated
--	FROM PortfolioProject1..CovidDeaths dea
--	JOIN PortfolioProject1..CovidVaccinations vac
--		ON dea.location = vac.location 
--		AND dea.date = vac.date
--	WHERE dea.continent is not null 


--Creating View to store data for later visualizations
Create View RunningPopulationVaccinated as
SELECT 
	dea.continent
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccinations
	, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RunningPeopleVaccinated
FROM 
	PortfolioProject1..CovidDeaths dea
	JOIN PortfolioProject1..CovidVaccinations vac
		ON dea.location = vac.location 
		AND dea.date = vac.date
WHERE 
	dea.continent is not null 


SELECT *
FROM RunningPopulationVaccinated


