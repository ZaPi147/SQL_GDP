/*
1. Ponieważ do łączenia danych z dwóch źródeł użyto informacji o liczbie ludności w danym państwie, sprawdźmy jaka jest miedzy nimi różnica i jaki jest to procent?
Because we used data about population in a given country from two different sources, let's check what the difference is between them and what percentage it is?
2. Który kraj i jak bardzo gęsto zaludniony ma w 2022 roku drugą największą powierzchnię mierzoną w km2?
Which country and how densely populated in 2022 year has the second largest area measured in km2?
3. Które państwa o PKB per capita większym od średniej zanotują pomiędzy latami 2022 oraz 2030 spadek liczby ludności?
Which countries with GDP per capita higher than average will meet a population decline between 2022 and 2030?
4. Ile krajów z najmniejszym PKB potrzeba ,aby przewyższyć wartość PKB kraju z najwyższym wartością w 2022 roku?
How many countries with the lowest GDP are needed to exceed the GDP of country with the highest result in 2022 year?
5. O ile USD wzrósł PKB  w każdym kraju w 2022 roku?
By how much USD did GDP increase in each country in 2022?
6. Jak wielkie byłoby PKB kraju dla którego przyjmiemy największe PKB per capita oraz największą ludność w 2022 roku, która jest taka sama w obydwu źródłach danych?
How big would be the GDP of a country for which we assume the largest GDP per capita and the largest population in 2022, which is the same for both data sources?
7. Które kraje mają największe PKB per capita wyrażone w USD dla lat dla których pobrano dane (1980, 2000, 2010, 2022)?
Which countries have the highest GDP per capita in USD for each year with the data (1980, 2000, 2010, 2022)?
8. Które kraje spośród miejsc 75 do 115 pod względem powierzchni ma PKB powyżej średniej dla świata za 2022 rok?
Which countries in places from 75 to 115 in the field of area have GDP above the world average in 2022 year?
9. Czy na świecie więcej krajów jest w recesji czy ma wzrost gospodarczy w 2022 roku?
Are more countries in the world in recession or in economic growth in 2022 year?
10. Jaki kraj ma największe i najmniejsze PKB per capita i jaka jest jego wartość dla Polski w 2022 roku?
What is the country with the highest and the lowest GDP per capita in the world and what is this value in 2022 for Poland?
11. W którym roku każdy kraj miał najwyższy wzrost PKB per capita mierzony w % i ile on wynosił?
In which year each country had the highest GDP growth per capita in % and how much was it?
12. Jaki jest PKB 20 najbardziej ludnych krajów i jaki stanowi to procent względem światowego PKB za 2022 rok?
What is the GDP of the 20 the most populated cuntries and their percentage to the GDP of the world in 2022?
13. Na podstawie porównania PKB w latach 2010 i 2022 określmy czy kraj ma szansę na wzrost gospodarczy, czy też jest zagrożony recesją.
Based on a comparison of the GDP in 2010 and 2022 define if country has possibility of economic growth or has risk of recession.
14. Czy jest jakiś kraj w pierwszej dziesiątce krajów z procentowym wzrostem PKB i w pierwszej dziesiątce pod względem wzrostu liczby ludności w 2022 roku?
Is there any country in the top 10 countries with percentage GDP growth and in the top 10 with population growth in 2022 year?
15. Ile jest krajów w ONZ i jakie są średnie wartości wzrostu PKB oraz populacji dla całej organizacji w 2022 roku?
How many countries is in UN and what are average values of growth in GDP and population for whole organisation in 2022 year?
16. Czy w 2022 roku większe PKB ma 10 najbardziej ludnych krajów czy reszta pństw?
Do the 10 most populous countries have a higher GDP or the rest of the countries in 2022?
17. Ile krajów o najmniejszym PKB potrzeba aby przewyższyć PKB Stanów Zjednoczonych za 2022 rok?
How many countries with the lowest GDP do we need to exceed GDP of United States in 2022 year?
18. Jakim procentem światowego PKB w 2022 roku jest światowe PKB z roku 2000?
What percentage of world GDP in 2022 is world GDP in 2000 year?
19. Jakie kraje mają większe PKB i PKB per capita od Polski w 2022 roku?
What countries have higher GDP and GDP per capita than Poland in 2022 year?
20. Które miejsce na świecie ma Polska pod względem PKB per capita w 2022 roku?
Where in the world does Poland rank in GDP per capita in 2022 year?
*/



--1. Ponieważ do łączenia danych z dwóch źródeł użyto informacji o liczbie ludności w danym państwie, sprawdźmy jaka jest miedzy nimi różnica i jaki jest to procent?
--   Because we used data about population in a given country from two different sources, let's check what the difference is between them and what percentage it is?

SELECT
	"COUNTRY (data from WB)"
	,"POPULATION (data from WB)"
	,"POPULATION in 2022"
	,abs("POPULATION (data from WB)"-"POPULATION in 2022") AS DIFFERENCE
	,ROUND(abs("POPULATION (data from WB)"-"POPULATION in 2022")*100/GREATEST("POPULATION (data from WB)","POPULATION in 2022")::numeric,2) AS DIFF_PERCENT
FROM general_data
WHERE "YEAR" = 2022 AND abs("POPULATION (data from WB)"-"POPULATION in 2022") > 0
ORDER BY DIFFERENCE DESC


--2. Który kraj i jak bardzo gęsto zaludniony ma w 2022 roku drugą największą powierzchnię mierzoną w km2?
     Which country and how densely populated in 2022 year has the second largest area measured in km2? --

SELECT
	"COUNTRY (data from WPR)"
	,"YEAR"
	,"AREA in KM2"
	,"DENSITY per KM2"
FROM general_data
WHERE
	"YEAR" = 2022
	AND "COUNTRY (data from WB)" IN
	(SELECT "COUNTRY (data from WB)"
	FROM general_data
	WHERE "AREA in KM2" = (SELECT MAX("AREA in KM2") 
				FROM general_data WHERE "AREA in KM2" < (SELECT MAX("AREA in KM2")
									FROM general_data)));


--3. Które państwa o PKB per capita większym od średniej zanotują pomiędzy latami 2022 oraz 2030 spadek liczby ludności?
     Which countries with GDP per capita higher than average will meet a population decline between 2022 and 2030? --

SELECT
	"COUNTRY (data from WPR)"
	,"POPULATION GROWTH in %"
	,"GDP GROWTH per capita in %"
	,"GDP per capita in USD"
	,("POPULATION in 2030" - "POPULATION in 2022") AS "POPULATION DIFFERENCE"
FROM general_data
WHERE "YEAR" = 2022
	AND "POPULATION in 2030" < "POPULATION in 2022"
	AND ("GDP per capita in USD"
		> (SELECT AVG("GDP per capita in USD")
		FROM general_data))
ORDER BY "POPULATION DIFFERENCE";


--4. Ile krajów z najmniejszym PKB potrzeba ,aby przewyższyć wartość PKB kraju z najwyższym wartością w 2022 roku?
     How many countries with the lowest GDP are needed to exceed the GDP of country with the highest result in 2022 year? --

WITH GDP_calculations AS
(SELECT
	"COUNTRY (data from WB)"
	,"GDP in USD"
	,SUM("GDP in USD") OVER (ORDER BY "GDP in USD") AS GDPsum 
FROM general_data
WHERE "YEAR" = 2022)

SELECT
	COUNT(*) + 1 AS "COUNTRIES NEEDED"
FROM GDP_calculations
WHERE GDPsum < (SELECT MAX("GDP in USD")
FROM general_data);


--5. O ile USD wzrósł PKB  w każdym kraju w 2022 roku?
     By how much USD did GDP increase in each country in 2022? --

SELECT
	"COUNTRY (data from WB)"
	,"GDP in USD"
	,"GDP GROWTH in %"
	,ROUND(("GDP in USD"*"GDP GROWTH in %"/100)::numeric,2) AS "GDP growth in USD in 2022" 
FROM general_data
WHERE "YEAR" = 2022


--6. Jak wielkie byłoby PKB kraju dla którego przyjmiemy największe PKB per capita oraz największą ludność w 2022 roku, która jest taka sama w obydwu źródłach danych?
     How big would be the GDP of a country for which we assume the largest GDP per capita and the largest population in 2022, which is the same for both data sources? --

SELECT
	((SELECT
		MAX("POPULATION (data from WB)")
		FROM general_data
		WHERE "POPULATION (data from WB)" = "POPULATION in 2022")
	*
	(SELECT
		MAX("GDP per capita in USD")
		FROM general_data
		WHERE "POPULATION (data from WB)" = "POPULATION in 2022")) 
	AS GDP_max
FROM general_data
LIMIT 1


--7. Które kraje mają największe PKB per capita wyrażone w USD dla lat dla których pobrano dane (1980, 2000, 2010, 2022)?
     Which countries have the highest GDP per capita in USD for each year with the data (1980, 2000, 2010, 2022)? --

SELECT
	"COUNTRY (data from WB)"
	,"YEAR"
	,"GDP per capita in USD"
FROM
	(SELECT
		"COUNTRY (data from WB)"
		,"YEAR"
		,"GDP per capita in USD"
	 	,ROW_NUMBER () OVER (PARTITION BY "YEAR" ORDER BY "GDP per capita in USD" DESC NULLS LAST)
	 	AS ranking
	 FROM general_data)
WHERE ranking = 1


--8. Które kraje spośród miejsc 75 do 115 pod względem powierzchni ma PKB powyżej średniej dla świata za 2022 rok?
     Which countries in places from 75 to 115 in the field of area have GDP above the world average in 2022 year? --

SELECT
	*
FROM 
	(SELECT
	 	"COUNTRY (data from WB)"
	 	,"AREA in KM2"
	 	,"GDP in USD"
	 	,"YEAR"
	FROM general_data
	WHERE "YEAR" = 2022
	ORDER BY "AREA in KM2" DESC NULLS LAST
	LIMIT 40 OFFSET 74)
WHERE ("GDP in USD" > (SELECT AVG("GDP in USD")
			FROM general_data))


--9. Czy na świecie więcej krajów jest w recesji czy ma wzrost gospodarczy w 2022 roku?
     Are more countries in the world in recession or in economic growth in 2022 year? --

SELECT
	"COUNTRIES IN ECONOMIC GROWTH"
	,"COUNTRIES IN RECESSION"
	,CASE 
	WHEN "COUNTRIES IN ECONOMIC GROWTH" > "COUNTRIES IN RECESSION" 
	THEN 'More countries in economic growth'
	ELSE 'More countries in recession'
	END	AS "RESULT"
FROM
	(SELECT
		COUNT(CASE WHEN "GDP GROWTH in %" > 0 THEN "COUNTRY (data from WB)" END)
			AS "COUNTRIES IN ECONOMIC GROWTH"	 
	 
		,COUNT(CASE WHEN "GDP GROWTH in %" < 0 THEN "COUNTRY (data from WB)" END)
			AS "COUNTRIES IN RECESSION"
	FROM general_data
	WHERE "YEAR" = 2022);


--10. Jaki kraj ma największe i najmniejsze PKB per capita i jaka jest jego wartość dla Polski w 2022 roku?
      What is the country with the highest and the lowest GDP per capita in the world and what is this value in 2022 for Poland? --
	 
SELECT * 
FROM 
	((SELECT 
	 	'Highest GDP per capita' AS description
		,"COUNTRY (data from WB)"
		,"GDP per capita in USD"
	FROM general_data
	WHERE "YEAR" = 2022
	ORDER BY "GDP per capita in USD" DESC NULLS LAST
	LIMIT 1)
		
UNION
	
	(SELECT 
	 	'Lowest GDP per capita' AS description
		,"COUNTRY (data from WB)"
		,"GDP per capita in USD"  
	FROM general_data
	WHERE "YEAR" = 2022
	ORDER BY "GDP per capita in USD"
	LIMIT 1) 
	
UNION
	
	(SELECT 
	 	'GDP per capita in Poland' AS description
		,"COUNTRY (data from WB)"
		,"GDP per capita in USD"  
	FROM general_data
	WHERE "COUNTRY (data from WB)" = 'Poland' AND "YEAR" = 2022)

ORDER BY "GDP per capita in USD" DESC); 


--11. W którym roku każdy kraj miał najwyższy wzrost PKB per capita mierzony w % i ile on wynosił?
      In which year each country had the highest GDP growth per capita in % and how much was it? -- 

SELECT
	"COUNTRY (data from WB)"
	,"GDP GROWTH per capita in %"
	,"YEAR"
FROM 
	(SELECT 
		"COUNTRY (data from WB)"
		,"GDP GROWTH per capita in %"
		,"YEAR" 
		,ROW_NUMBER() OVER (PARTITION BY "COUNTRY (data from WB)" ORDER BY "GDP GROWTH per capita in %" DESC NULLS LAST) AS ranking
	FROM general_data) 
WHERE ranking = 1
ORDER BY 2 DESC NULLS LAST;


--12. Jaki jest PKB 20 najbardziej ludnych krajów i jaki stanowi to procent względem światowego PKB za 2022 rok?
      What is the GDP of the 20 the most populated cuntries and their percentage to the GDP of the world in 2022? --

SELECT
	SUM(all_countries.GDPall) AS "world GDP"
	,SUM(top_20.GDP20) AS "TOP20 GDP"
	,ROUND((SUM(top_20.GDP20)/SUM(all_countries.GDPall))*100::numeric,2) AS "PERCENTAGE"
FROM (SELECT
		"COUNTRY (data from WB)" AS countryall
		,"GDP in USD" AS GDPall
	FROM general_data
	WHERE "YEAR" = 2022) AS all_countries
FULL JOIN 
	(SELECT
		"COUNTRY (data from WB)" AS country20
		,"GDP in USD" AS GDP20
	 FROM general_data
	 WHERE "YEAR" = 2022
	 ORDER BY "POPULATION (data from WB)" DESC
	 LIMIT 20) AS top_20
	 
ON top_20.country20 = all_countries.countryall;


--13. Na podstawie porównania PKB w latach 2010 i 2022 określmy czy kraj ma szansę na wzrost gospodarczy, czy też jest zagrożony recesją.
      Based on a comparison of the GDP in 2010 and 2022 define if country has possibility of economic growth or has risk of recession. --


SELECT
	country2022 AS COUNTRY
	,GDP2010
	,GDP2022
	,CASE 
	WHEN GDP2010 > GDP2022 THEN 'Risk of recession'
	WHEN GDP2010 < GDP2022 THEN 'Possible economic growth'
	WHEN GDP2010 = GDP2022 THEN 'Stagnation'
	ELSE 'no data'
	END	AS "RESULT"
FROM
	((SELECT
	 	"COUNTRY (data from WB)" AS country2010
	 	,"GDP in USD" AS GDP2010
	 FROM general_data
	 WHERE "YEAR" = 2010)
FULL JOIN
	(SELECT
	 	"COUNTRY (data from WB)" AS country2022
	 	,"GDP in USD" AS GDP2022
	 FROM general_data
	 WHERE "YEAR" = 2022)

ON country2010 = country2022);


--14. Czy jest jakiś kraj w pierwszej dziesiątce krajów z procentowym wzrostem PKB i w pierwszej dziesiątce pod względem wzrostu liczby ludności w 2022 roku?
      Is there any country in the top 10 countries with percentage GDP growth and in the top 10 with population growth in 2022 year ? --

WITH top_population AS
	(SELECT
	 	"COUNTRY (data from WB)" AS COUNTRY
	 	,"POPULATION GROWTH in %"
	FROM general_data
	WHERE "YEAR" = 2022
	ORDER BY "POPULATION GROWTH in %" DESC NULLS LAST
	LIMIT 10)

,top_GDP AS
	(SELECT
	 	"COUNTRY (data from WB)" AS COUNTRY
		,"GDP GROWTH in %"
	FROM general_data
	WHERE "YEAR" = 2022
	ORDER BY "GDP GROWTH in %" DESC NULLS LAST
	LIMIT 10)

SELECT
	top_GDP.COUNTRY
	,top_GDP."GDP GROWTH in %"
	,top_population."POPULATION GROWTH in %"
FROM top_population
INNER JOIN top_GDP
ON top_GDP.country = top_population.country;

--15. Ile jest krajów w ONZ i jakie są średnie wartości wzrostu PKB oraz populacji dla całej organizacji w 2022 roku?
      How many countries is in UN and what are average values of growth in GDP and population for whole organisation in 2022 year? --


SELECT
	(SELECT
		COUNT("COUNTRY (data from WB)") AS "UN MEMBERS 2022"
	FROM general_data
	WHERE "UN MEMBER" = true and "YEAR" = 2022)
	,(SELECT
	  	ROUND(AVG("GDP GROWTH in %")::numeric,2) AS "PERCENTAGE GROWTH OF GDP IN UN"
	 FROM general_data
	 WHERE "UN MEMBER" = true and "YEAR" = 2022)
	 ,(SELECT
	  	ROUND(AVG("GDP GROWTH per capita in %")::numeric,2) AS "PERCENTAGE GROWTH OF GDP PER CAPITA IN UN"
	 FROM general_data
	 WHERE "UN MEMBER" = true and "YEAR" = 2022)
	 ,(SELECT
	  	ROUND(AVG("POPULATION GROWTH in %")::numeric,2) AS "PERCENTAGE GROWTH OF POPULATOION IN UN"
	 FROM general_data
	 WHERE "UN MEMBER" = true and "YEAR" = 2022);
	

--16. Czy w 2022 roku większe PKB ma 10 najbardziej ludnych krajów czy reszta pństw?
      Do the 10 most populous countries have a higher GDP or the rest of the countries in 2022? --

SELECT 
	"TOP 10 GDP"
	,"REST GDP"
	,CASE
	WHEN "TOP 10 GDP" > "REST GDP" * 1.5 THEN '10 the most populated countries have higher GDP than the rest'
	WHEN "TOP 10 GDP" < "REST GDP" * 1.5 THEN '10 the most populated countries have lower GDP than the rest'
	ELSE 'Equal'
	END AS "Result"
FROM
(SELECT
	SUM("GDP in USD") AS "TOP 10 GDP"
FROM
	(SELECT
		"COUNTRY (data from WPR)"
		,"POPULATION in 2022"
		,"% OF WORLD POPULATION"
		,"GDP in USD"
	FROM general_data
	WHERE "YEAR" = 2022 
	ORDER BY "POPULATION in 2022" DESC NULLS LAST
	LIMIT 10))

,(SELECT
	SUM("GDP in USD") AS "REST GDP"
FROM
	(SELECT
		"COUNTRY (data from WPR)"
		,"POPULATION in 2022"
		,"% OF WORLD POPULATION"
		,"GDP in USD"
	FROM general_data
	WHERE "YEAR" = 2022 
	ORDER BY "POPULATION in 2022" ASC NULLS LAST
	LIMIT 207 OFFSET 10));


--17. Ile krajów o najmniejszym PKB potrzeba aby przewyższyć PKB Stanów Zjednoczonych za 2022 rok?
      How many countries with the lowest GDP do we need to exceed GDP of United States in 2022 year? --

WITH assumptions AS
(SELECT
	"COUNTRY (data from WB)" AS country
	,"GDP in USD" AS GDP
	,SUM("GDP in USD") OVER (ORDER BY "GDP in USD") AS summary
FROM general_data
WHERE "YEAR" = 2022)		
		
SELECT
(SELECT
	COUNT(country) AS "NUMBER OF COUNTRIES"
FROM	
((SELECT * 
	FROM assumptions
	WHERE summary < (SELECT
				"GDP in USD"
			FROM general_data 
			WHERE "COUNTRY (data from WB)" = 'United States' AND "YEAR" = 2022))
	UNION

(SELECT * 
	FROM assumptions
	WHERE summary > (SELECT
				"GDP in USD"
			FROM general_data 
			WHERE "COUNTRY (data from WB)" = 'United States' AND "YEAR" = 2022)
	ORDER BY GDP
	LIMIT 1)))

,(SELECT
	SUM(GDP) AS "SUM OF THEIR GDP"
FROM	
((SELECT * 
	FROM assumptions
	WHERE summary < (SELECT
				"GDP in USD"
			FROM general_data 
			WHERE "COUNTRY (data from WB)" = 'United States' AND "YEAR" = 2022))
	UNION

(SELECT * 
	FROM assumptions
	WHERE summary > (SELECT 
				"GDP in USD"
			FROM general_data 
			WHERE "COUNTRY (data from WB)" = 'United States' AND "YEAR" = 2022)
	ORDER BY GDP
	LIMIT 1)))

,(SELECT "GDP in USD" AS "GDP OF US"
					FROM general_data 
					WHERE "COUNTRY (data from WB)" = 'United States' AND "YEAR" = 2022);


--18. Jakim procentem światowego PKB w 2022 roku jest światowe PKB z roku 2000?
      What percentage of world GDP in 2022 is world GDP in 2000 year? --

SELECT
	ROUND(
		(SELECT 
			SUM("GDP in USD")
		FROM general_data WHERE "YEAR" = 2000)
		/
		(SELECT 
			SUM("GDP in USD")
		FROM general_data WHERE "YEAR" = 2022)
	,2)
AS "GDP 2000 AS PERCENTAGE OF GDP 2022";


--19. Jakie kraje mają większe PKB i PKB per capita od Polski w 2022 roku?
      What countries have higher GDP and GDP per capita than Poland in 2022 year? --

SELECT
	"COUNTRY (data from WB)" AS COUNTRY
	,"GDP in USD"
	,"GDP per capita in USD"
FROM general_data
WHERE "GDP in USD" > (SELECT
				"GDP in USD"
			FROM general_data
			WHERE "COUNTRY (data from WB)" = 'Poland' AND "YEAR" = 2022)
AND "GDP per capita in USD" > (SELECT
					"GDP per capita in USD"
				FROM general_data
				WHERE "COUNTRY (data from WB)" = 'Poland' AND "YEAR" = 2022)

AND "YEAR" = 2022
ORDER BY 2 DESC;


--20. Które miejsce na świecie ma Polska pod względem PKB per capita w 2022 roku?
      Where in the world does Poland rank in GDP per capita in 2022 year? --

WITH perCapitaRANK AS
(SELECT
	"COUNTRY (data from WB)" AS COUNTRY
	,"GDP in USD"
	,"GDP per capita in USD"
	,ROW_NUMBER() OVER (ORDER BY "GDP per capita in USD" DESC NULLS LAST) AS RANKING
FROM general_data WHERE "YEAR" = 2022)

SELECT
	COUNTRY
	,RANKING
FROM perCapitaRANK WHERE COUNTRY = 'Poland';

