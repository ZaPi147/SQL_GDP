/*
TWORZENIE BAZY DANYCH PRZEZ WSTAWIANIE POBRANYCH DANYCH DO TABEL
CREATING A DATABASE BY INSERTING DOWNLOADED DATA INTO TABLES
*/

--Utworzenie wstępnej tabeli dla danych pobranych z worldpopulationreview.com.
--Creating a preliminary table for data downloaded from worldpopulationreview.com.

CREATE TABLE upload
	(
	pop1980 bigint
	,pop2000 bigint
	,pop2010 bigint
	,pop2022 bigint
	,pop2023 bigint
	,pop2030 bigint
	,pop2050 bigint
	,country text
	,area numeric
	,landareakm numeric
	,unmember boolean
	,netchange numeric
	,growthrate numeric
	,worldpercentage numeric
	,density numeric
	,densitymi numeric
	,ranking integer
	);

--Zaimportowanie do tabeli odpowiedniego pliku .csv z danymi.
--Importing the appropriate .csv data file to the table.

COPY upload FROM 'C:\Users\Admin\Desktop\GITHUB\data\countries-table.csv' DELIMITER ',' CSV HEADER;

--Utworzenie tabieli zawierającej tylko dane potrzebne do dalszych analiz.
--Creating a table containing only the data needed for further analysis.

CREATE TABLE countries_worldpopulationreview AS
	SELECT
		country
  		,pop1980
  		,pop2000
  		,pop2010
  		,pop2022
  		,pop2030
  		,pop2050
  		,ROUND(growthrate*100,2) AS growth_rate
		,density AS density_per_km2
		,area AS area_in_km2
  		,ROUND(worldpercentage*100,2) AS world_percent
		,unmember
	FROM upload;


--Utworzenie tabeli dla danych o populacji pobranych z World Bank i zaimportowanie do nich przygotowanych plików .csv.
--Creating a table for data about population downloaded from World Bank and importing prepared .csv files into them.

CREATE TABLE WB_population
	(
	Country VARCHAR(70) NOT NULL
	,Year SMALLINT CHECK(year <= date_part('year', CURRENT_DATE))
	,Population BIGINT
	)

COPY WB_population FROM 'C:\Users\Admin\Desktop\GITHUB\data\WB_population.csv' DELIMITER ',' CSV HEADER;

--Utworzenie tabeli dla danych o PKB w USD pobranych z World Bank i zaimportowanie do nich przygotowanych plików .csv.
--Creating a table for data about GDP in USD downloaded from World Bank and importing prepared .csv files into them.

CREATE TABLE WB_GDPusd
	(
	Country VARCHAR(70) NOT NULL
	,Year SMALLINT CHECK(year <= date_part('year', CURRENT_DATE))
	,GDP_usd BIGINT
	)

COPY WB_GDPusd FROM 'C:\Users\Admin\Desktop\GITHUB\data\WB_GDPinUSD.csv' DELIMITER ',' CSV HEADER;

--Utworzenie tabeli dla danych o PKB per capita w USD pobranych z World Bank i zaimportowanie do nich przygotowanych plików .csv.
--Creating a table for data about GDP per capita in USD downloaded from World Bank and importing prepared .csv files into them.

CREATE TABLE WB_GDPpercapitausd
	(
	Country VARCHAR(70) NOT NULL
	,Year SMALLINT CHECK(year <= date_part('year', CURRENT_DATE))
	,GDPpercapita_usd REAL
	)

COPY WB_GDPpercapitausd FROM 'C:\Users\Admin\Desktop\GITHUB\data\WB_GDPpercapitausd.csv' DELIMITER ',' CSV HEADER;

--Utworzenie tabeli dla danych o wzroście PKB per capita w % pobranych z World Bank i zaimportowanie do nich przygotowanych plików .csv.
--Creating a table for data about GDP per capita growth in % downloaded from World Bank and importing prepared .csv files into them.

CREATE TABLE WB_GDPpercapitagrowth_percent 
	(
	Country VARCHAR(70) NOT NULL
	,Year SMALLINT CHECK(year <= date_part('year', CURRENT_DATE))
	,GDPpercapitagrowth_percent REAL
	)

COPY WB_GDPpercapitagrowth_percent  FROM 'C:\Users\Admin\Desktop\GITHUB\data\WB_GDPpercapitagrowth_percent .csv' DELIMITER ',' CSV HEADER;

--Utworzenie tabeli dla danych o wzroście PKB w % pobranych z World Bank i zaimportowanie do nich przygotowanych plików .csv.
--Creating a table for data about GDP growth in % downloaded from World Bank and importing prepared .csv files into them.


CREATE TABLE WB_GDPgrowth_percent
	(
	Country VARCHAR(70) NOT NULL
	,Year SMALLINT CHECK(year <= date_part('year', CURRENT_DATE))
	,GDPgrowth_percent REAL
	)

COPY WB_GDPgrowth_percent  FROM 'C:\Users\Admin\Desktop\GITHUB\data\WB_GDPgrowth_percent .csv' DELIMITER ',' CSV HEADER;

