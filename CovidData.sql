--Select * From Portofolio.dbo.['Covid Death Data$']
--Order By location, date

--select * from Portofolio.dbo.['Covid Vaccine Data$']
----order by location, date

--select the data that we are going to be using

--Select location, date, total_cases, new_cases, total_deaths, population 
--From Portofolio.dbo.['Covid Death Data$']
--Order By location, date

---- looking at the total cases vs total deaths

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)
--From Portofolio.dbo.['Covid Death Data$']
--Order By location, date

---- looking at the total cases vs total deaths in Indonesia

--Select location, date, population, new_cases, total_cases, total_deaths, ((total_deaths/total_cases)*100) as DeathPercentage
--From Portofolio.dbo.['Covid Death Data$']
--Where location like 'Indo%'
--Order By location, date

---- looking at the highest infection rate compare to population in a country
Select location, population, Max(total_cases) as highestInfection, Max((total_cases/population)*100) as highestInfectionRate
From Portofolio.dbo.['Covid Death Data$']
--Where location like 'Indo%'
Group By location, population
Order By highestInfectionRate DESC



---- showing the countries with the highest death count per population
Select location, population, Max(total_deaths) as totalDeaths
From Portofolio.dbo.['Covid Death Data$']
Where continent is not null
Group By location, population
Order By totalDeaths DESC

--- Let's break things down by continent
--- showing the continent with the highest death count
Select location, Max(total_deaths) as totalDeaths
From Portofolio.dbo.['Covid Death Data$']
Where continent is null
Group By location
Order By totalDeaths DESC

--- Global numbers
Select date, SUM(cast(new_cases as float)) as totalCases, SUM(cast(new_deaths as float)) as totalDeaths, CASE WHEN SUM(cast(new_cases as float)) = 0 then 0 else SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 end as DeathPercentage -- , total_deaths, (total_deaths/total_cases)*100 as deathPercentage
from Portofolio.dbo.['Covid Death Data$']
where continent is not null
group by date
order by 1, 2

--- joining death data with vaccine data
select * from Portofolio.dbo.['Covid Death Data$'] death
join Portofolio.dbo.['Covid Vaccine Data$'] vacc
	on death.location = vacc.location and 
	death.date = vacc.date

--- Looking at the total population and vaccinations
select death.location, death.date, population, total_vaccinations, (MAX(cast(total_vaccinations as float)))/(MAX(cast(population as float)))*100 as vaccinePercentage from Portofolio.dbo.['Covid Death Data$'] death
join Portofolio.dbo.['Covid Vaccine Data$'] vacc
	on death.location = vacc.location and 
	death.date = vacc.date
where death.continent is not null
group by death.location, death.date, population, total_vaccinations