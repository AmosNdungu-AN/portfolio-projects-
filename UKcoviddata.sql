-- general information about the data 
select *
from portifolioproject..UKcoviddata
order by 2,4

-- I would like to break the data into two;
-- data before vaccination and data after vaccination
--without tampering with the orginal data set.
-- in this case I used VIEWS 
-- first view
drop view if exists data_before_vaccination
create view data_before_vaccination as 
select *
from portifolioproject..UKcoviddata
where total_vaccinations IS NULL 

--second view
drop view if exists data_after_vaccination
create view data_after_vaccination as 
select *
from portifolioproject..UKcoviddata
where total_vaccinations IS NOT NULL 

-- which days had the highest number of new cases and what was the highest number
select date, max(new_cases) AS highest_positive_case
from data_before_vaccination
group by date
order by highest_positive_case desc
-- the highest number of new cases reported before vaccination was 68,066 on 8th January 2021

select date, max(new_cases) AS highest_positive_case
from data_after_vaccination
group by date
order by highest_positive_case desc
-- the highest number of new cases reported after vaccination was 221,222 on 4th January 2022

-- total number of death cases in these two data categories
select location, sum(convert(int,new_deaths)) as life_lost
from data_before_vaccination
group by location
-- the total number of lives lost before vaccine was introduced is 80,941
select location, sum(cast(new_deaths as int)) as life_lost
from data_after_vaccination
group by location
-- the total number of life lost after introduction of vaccine is 76,341







