-- Active: 1752231682608@@127.0.0.1@3306@india_agri

USE india_agri;

--1.Year-wise Trend of Rice Production Across States (Top 3)
WITH Rank_Rice_Production
AS(
    SELECT 
        `Year`,
        `State_Name`,
        `RICE_PRODUCTION_(1000_tons)`,
        RANK() OVER(PARTITION BY `Year` ORDER BY `RICE_PRODUCTION_(1000_tons)` DESC) AS RP_Rank
    FROM indiacropdata
    )
SELECT * FROM  Rank_Rice_Production
WHERE RP_Rank <=3

--2.Top 5 Districts by Wheat Yield Increase Over the Last 5 Years
With Rank_Yeild
AS(
    SELECT 
        `Year`,
        `Dist_Name`,
        `WHEAT_YIELD_(Kg_per_ha)`,
        RANK() OVER(PARTITION BY Year ORDER BY `WHEAT_YIELD_(Kg_per_ha)` DESC ) AS Yeild_Rank
    FROM indiacropdata )
SELECT * 
FROM Rank_Yeild
WHERE Yeild_Rank <=5

--3.States with the Highest Growth in Oilseed Production (5-Year Growth Rate)
WITH Oil_Growth_Rate
AS(
SELECT
    `Year`,
    `State_Name`,
    `OILSEEDS_PRODUCTION_(1000_tons)`,
    LAG(`OILSEEDS_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`) AS Previous_Year_Prodction,
    ROUND((
        ((`OILSEEDS_PRODUCTION_(1000_tons)` - LAG(`OILSEEDS_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`) )/
        LAG(`OILSEEDS_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`)) *100
    ),2) AS Growth_Rate_of_Production
FROM indiacropdata)
SELECT 
    `Year`,
    `State_Name`,
    SUM(`OILSEEDS_PRODUCTION_(1000_tons)`) AS OIL_SEEDS_PRODUCTION,
    SUM(Previous_Year_Prodction) AS PREVIOUS_YEAR_OIL_SEET_PRODUCTION,
    ROUND(AVG(Growth_Rate_of_Production),2) AS GROWTH_RATE
FROM Oil_Growth_Rate
WHERE `Year` IN ( 2013,2014,2015,2016,2017)
GROUP BY `Year`,`State_Name`

--4.District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)

SELECT 
    `Dist_Name`,
    `RICE_AREA_(1000_ha)`,
    `RICE_PRODUCTION_(1000_tons)`,
    `WHEAT_AREA_(1000_ha)`,
    `WHEAT_PRODUCTION_(1000_tons)`,
    `MAIZE_AREA_(1000_ha)`,
    `MAIZE_PRODUCTION_(1000_tons)`
FROM indiacropdata

SELECT
    (AVG(`RICE_AREA_(1000_ha)` * `RICE_PRODUCTION_(1000_tons)`) - (AVG(`RICE_AREA_(1000_ha)`) * AVG(`RICE_PRODUCTION_(1000_tons)`))) 
    / 
    (STDDEV_SAMP(`RICE_AREA_(1000_ha)`) * STDDEV_SAMP(`RICE_PRODUCTION_(1000_tons)`)) AS rice_correlation,

    (AVG(`WHEAT_AREA_(1000_ha)` * `WHEAT_PRODUCTION_(1000_tons)`) - (AVG(`WHEAT_AREA_(1000_ha)`) * AVG(`WHEAT_PRODUCTION_(1000_tons)`))) 
    / 
    (STDDEV_SAMP(`WHEAT_AREA_(1000_ha)`) * STDDEV_SAMP(`WHEAT_PRODUCTION_(1000_tons)`)) AS wheat_correlation,

    (AVG(`MAIZE_AREA_(1000_ha)` * `MAIZE_PRODUCTION_(1000_tons)`) - (AVG(`MAIZE_AREA_(1000_ha)`) * AVG(`MAIZE_PRODUCTION_(1000_tons)`))) 
    / 
    (STDDEV_SAMP(`MAIZE_AREA_(1000_ha)`) * STDDEV_SAMP(`MAIZE_PRODUCTION_(1000_tons)`)) AS maize_correlation
FROM
    indiacropdata;

--5.Yearly Production Growth of Cotton in Top 5 Cotton Producing States

WITH Cotton_Growth_Rate
AS(
SELECT
    `Year`,
    `State_Name`,
    `COTTON_PRODUCTION_(1000_tons)`,
    LAG(`COTTON_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`) AS Previous_Year_Prodction,
    ROUND((
        ((`COTTON_PRODUCTION_(1000_tons)` - LAG(`COTTON_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`) )/
        LAG(`COTTON_PRODUCTION_(1000_tons)`) OVER(PARTITION BY `State_Name` ORDER BY `State_Name`)) *100
    ),2) AS Growth_Rate_of_Production
FROM indiacropdata)
SELECT 
    `Year`,
    `State_Name`,
    SUM(`COTTON_PRODUCTION_(1000_tons)`) AS COTTON_PRODUCTION,
    SUM(Previous_Year_Prodction) AS PREVIOUS_YEAR_COTTON_SEET_PRODUCTION,
    ROUND(AVG(Growth_Rate_of_Production),2) AS GROWTH_RATE
FROM Cotton_Growth_Rate
WHERE `Year` IN ( 2013,2014,2015,2016,2017)
GROUP BY `Year`,`State_Name`

--6.Districts with the Highest Groundnut Production in 2020
SELECT
    `Year`,
    `Dist_Name`,
    `GROUNDNUT_PRODUCTION_(1000_tons)`
FROM indiacropdata
WHERE `Year` = 2020
ORDER BY `GROUNDNUT_PRODUCTION_(1000_tons)` DESC

--7.Annual Average Maize Yield Across All States
SELECT
    `Year`,
    `State_Name`,
    ROUND(AVG(`MAIZE_YIELD_(Kg_per_ha)`),2) AS Average_Maize_Yield
FROM indiacropdata
GROUP BY `Year`,`State_Name`
ORDER BY `Year`

--8.Total Area Cultivated for Oilseeds in Each State

SELECT 
    `State_Name`,
    ROUND(SUM(`OILSEEDS_AREA_(1000_ha)`),2) AS Total_Area_Cultivated
FROM indiacropdata
GROUP BY `State_Name`
ORDER BY ROUND(SUM(`OILSEEDS_AREA_(1000_ha)`),2) DESC

--9.Districts with the Highest Rice Yield
SELECT 
    `DIST_Name`,
    ROUND(AVG(`RICE_YIELD_(Kg_per_ha)`),2) AS Rice_Yeild
FROM indiacropdata
GROUP BY `DIST_Name`
ORDER BY AVG(`RICE_YIELD_(Kg_per_ha)`) DESC


--10.Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years
WITH Rank_Rice_Wheat_Production
AS(
    WITH Rice_Wheat_Production
    AS(
    SELECT 
        `Year`,
        `State_Name`,
        SUM(`RICE_PRODUCTION_(1000_tons)`) As Rice_Production,
        SUM(`WHEAT_PRODUCTION_(1000_tons)`) AS Wheat_Production    
    FROM indiacropdata
    WHERE `Year` >= 2008
    GROUP BY Year,`State_Name`)
    SELECT *,
    RANK() OVER(PARTITION BY `Year` ORDER BY Rice_Production,Wheat_Production DESC) AS Map
    FROM `Rice_Wheat_Production`)
SELECT * FROM Rank_Rice_Wheat_Production
WHERE Map <=5