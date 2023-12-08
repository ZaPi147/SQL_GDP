/*
ŁĄCZENIE DANYCH Z DWÓCH RÓŻNYH ŹRÓDEŁ - WORLDPOPULATIONREVIEW.COM ORAZ WORLD BANK
JOINING DATA FROM FIFFERENT SOURCES - WORLDPOPULATIONREVIEW.COM AND WORLD BANK
*/

CREATE TABLE general_DATA AS

--Łączenie tabel przez wspólną nazwę kraju.
--Joining tables using a common country name.

WITH correct_join AS
(SELECT
	wpr.country AS core_country
	,wpr.pop2022
 	,pop.country
	,pop.population
FROM countries_worldpopulationreview AS wpr
JOIN wb_population AS pop
ON wpr.country = pop.country
WHERE pop.year = 2022)

--Niepołączone kraje z tabeli countries_worldpopulationreview.
--Not joined countries from countries_worldpopulationreview table.

,notjoined_wpr AS
(SELECT
	wpr.country
	,wpr.pop2022
FROM countries_worldpopulationreview AS wpr
LEFT JOIN correct_join
ON core_country = wpr.country
WHERE core_country IS NULL)

--Niepołączone kraje z tabeli wb_population.
--Not joined countries from wb_population table.

,notjoined_pop AS
(SELECT
	pop.country
	,pop.year
	,pop.population
FROM wb_population AS pop
LEFT JOIN correct_join
ON core_country = pop.country
WHERE pop.year = 2022
AND core_country IS NULL)

--Łączenie niepołączonych krajów z obydwu tabel przez pierwsze dwie litery nazwy i pierwsze dwie cyfry liczby populacji.
--Joining not joined countries from both tables by first two letters of the name and first two digits of population value.

,add_join_v1 AS
(SELECT
	nj_wpr.country AS njwpr_country_v1
	,nj_wpr.pop2022
	,nj_pop.country AS njpop_country_v1
	,nj_pop.population
FROM notjoined_wpr AS nj_wpr
JOIN notjoined_pop AS nj_pop
ON LEFT(nj_wpr.country,2) = LEFT(nj_pop.country,2)
WHERE LEFT(pop2022::text, 2) = LEFT(population::text, 2))

--Sprawdzenie które z krajów z tabeli wb_population wciąż nie są połączone.
--Checking which countries from wb_population table are still not joined.

,rest_from_wpr AS
(SELECT
	nj_wpr.country AS wpr_country
	,nj_wpr.pop2022 AS wpr_pop2022
FROM add_join_v1
FULL JOIN notjoined_wpr AS nj_wpr
ON  nj_wpr.country = njwpr_country_v1
WHERE njwpr_country_v1 IS NULL)

--Sprawdzenie które z krajów z tabeli countries_worldpopulationreview wciąż nie są połączone.
--Checking which countries from countries_worldpopulationreview table are still not joined.

,rest_from_pop AS
(SELECT
	nj_pop.country AS pop_country
	,nj_pop.population AS pop_population
from add_join_v1
FULL JOIN notjoined_pop AS nj_pop
ON nj_pop.country = njpop_country_v1
WHERE njpop_country_v1 IS NULL)

--Łączenie niepołączonych krajów z obydwu tabel przez sześć pierwszych liter nazwy państwa lub taką samą liczbę populacji lub specjalne zapytanie da Korei Południowej i Wysp Dziewiczych.
--Joining not joined countries from both tables by first six letters of the name or the same nuber of population or special query for South Korea and Virgin Islands.

,add_join_v2 AS
(SELECT
	rest1.wpr_country
	,rest1.wpr_pop2022
	,rest2.pop_country
	,rest2.pop_population
FROM rest_from_wpr AS rest1
JOIN rest_from_pop AS rest2
ON (LEFT(wpr_country,6) = LEFT(pop_country,6)
OR wpr_pop2022 = pop_population
OR
(rest1.wpr_country LIKE '%Korea%'
AND rest2.pop_country LIKE '%Korea%')
OR
(rest1.wpr_country LIKE '%Virgin Islands%'
AND rest2.pop_country LIKE '%Virgin Islands%')))

--Łączenie tabel z prawidłowo połączonymi nazwami państw w jedną.
--Joining all tables with correctly combined country names into one.

,joined_data AS
(SELECT * FROM correct_join
	UNION
SELECT * FROM add_join_v1
	UNION
SELECT * FROM add_join_v2)

--Łączenie wszystkich tabel z danymi, których źródłem jest World Bank.
--Joining all tables from data downloaded from the World Bank.

,WB_data_union_v1 AS
(SELECT 
	wb_population.country AS country_name
	,wb_population.year
	,wb_population.population AS population_wb
	,gdpusd.GDP_usd
	,gdppercapusd.GDPpercapita_usd
	,gdppercapgrper.GDPpercapitagrowth_percent
	,gdpgrper.GDPgrowth_percent
FROM wb_population
	JOIN wb_gdpusd AS gdpusd
		ON wb_population.country = gdpusd.country
	JOIN wb_gdppercapitausd AS gdppercapusd
		ON wb_population.country = gdppercapusd.country
	JOIN wb_gdppercapitagrowth_percent AS gdppercapgrper
		ON wb_population.country = gdppercapgrper.country
	JOIN wb_gdpgrowth_percent AS gdpgrper
		ON wb_population.country = gdpgrper.country
WHERE wb_population.year = gdpusd.year
AND wb_population.year = gdppercapusd.year
AND wb_population.year = gdppercapgrper.year
AND wb_population.year = gdpgrper.year)

--Łączenie wszystkich danych z World Bank z tabelą ostatecznych połączeń.
--Joining all data from the World Bank with the final connection table.

,WB_data_union_v2 AS
(SELECT *
FROM WB_data_union_v1 as WBdu1
LEFT JOIN joined_data AS jd
	ON WBdu1.country_name = jd.country
	ORDER BY wbdu1.year,wbdu1.country_name)

--Wybranie wszystkich kolumn potrzebnych do dalszych analiz na zbiorach danych i utworzenie finalnej tabeli general_DATA.
--Selecting all columns needed for further analyzes on data sets and creating the final general_DATA table.

SELECT
	WBdu2.country_name AS "COUNTRY (data from WB)"
	,WBdu2.year AS "YEAR"
	,WBdu2.population_wb AS "POPULATION (data from WB)"
	,WBdu2.gdp_usd AS "GDP in USD"
	,WBdu2.gdppercapita_usd AS "GDP per capita in USD"
	,WBdu2.gdppercapitagrowth_percent AS "GDP GROWTH per capita in %"
	,WBdu2.gdpgrowth_percent AS "GDP GROWTH in %"
	,cwpr.pop1980 AS "POPULATION in 1980"
	,cwpr.pop2000 AS "POPULATION in 2000"
	,cwpr.pop2010 AS "POPULATION in 2010"
	,cwpr.pop2022 AS "POPULATION in 2022"
	,cwpr.pop2030 AS "POPULATION in 2030"
	,cwpr.pop2050 AS "POPULATION in 2050"
	,cwpr.growth_rate AS "POPULATION GROWTH in %"
	,cwpr.density_per_km2 AS "DENSITY per KM2"
	,cwpr.area_in_km2 AS "AREA in KM2"
	,cwpr.world_percent AS "% OF WORLD POPULATION"
	,cwpr.unmember AS "UN MEMBER"
	,cwpr.country AS "COUNTRY (data from WPR)"
FROM WB_data_union_v2 AS WBdu2
FULL JOIN countries_worldpopulationreview AS cwpr
	ON WBdu2.core_country = cwpr.country
	ORDER BY WBdu2.year,WBdu2.core_country

SELECT * FROM general_DATA;