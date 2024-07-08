USE Monday;

SELECT * FROM bird_strike;

SELECT * FROM bird_strike
WHERE Altitude_bin = '> 1000 ft';

-- Add the new column to store the extracted year

ALTER TABLE bird_strike
ADD YearColumn INT;

-- Update the new column with the extracted year from the datetime column

UPDATE bird_strike
SET YearColumn = YEAR(Flight_Date);

--Airport wise bird strikes

SELECT Airport_name, count(*) as total
FROM bird_strike
GROUP BY Airport_Name
ORDER BY total desc;

--Altitude wise bird strikes

SELECT Altitude_bin, count(*) as total
FROM bird_strike
GROUP BY Altitude_bin
ORDER BY total desc;

--Aircraft_Model wise bird strikes

SELECT Aircraft_Model, count(*) as total
FROM bird_strike
GROUP BY Aircraft_Model
ORDER BY total desc;

--Airline_Operator wise bird strikes

SELECT Airline_Operator, count(*) as total
FROM bird_strike
GROUP BY Airline_Operator
ORDER BY total desc;

--Origin_State wise bird strikes

SELECT Origin_State , count(*) as total
FROM bird_strike
GROUP BY Origin_State
ORDER BY total desc;

--Phase_of_flight wise bird strikes

SELECT Phase_of_flight , count(*) as total
FROM bird_strike
GROUP BY Phase_of_flight
ORDER BY total desc;

--Wildlife_Size wise bird strikes

SELECT Wildlife_Size , count(*) as total
FROM bird_strike
GROUP BY Wildlife_Size
ORDER BY total desc;

--Sky_condition wise bird strikes

SELECT Sky_condition , count(*) as total
FROM bird_strike
GROUP BY Sky_condition
ORDER BY total desc;

--Species wise bird strikes

SELECT Species , count(*) as total
FROM bird_strike
GROUP BY Species
ORDER BY total desc;

--Feet_above_ground wise bird strikes

SELECT Feet_above_ground , count(*) as total
FROM bird_strike
GROUP BY Feet_above_ground
ORDER BY total desc;


--Flight_Date wise bird strikes

SELECT Flight_Date , count(*) as total
FROM bird_strike
GROUP BY Flight_Date
ORDER BY total desc;

--flight impact wise bird strike

SELECT flight_impact , count(*) as count_of_strike
FROM bird_strike
GROUP BY flight_impact
ORDER BY count(*) desc;

--engine wise bird strike 

SELECT Number_of_engines , count(*) as count_of_strike
FROM bird_strike
GROUP BY Number_of_engines
ORDER BY count(*) desc;

--Total cost

SELECT Aircraft_Model ,CONCAT('$ ', sum(cost)) as total_cost
FROM bird_strike
GROUP BY Aircraft_Model
ORDER BY sum(cost) desc;


SELECT Airline_Operator ,CONCAT('$ ', sum(cost)) as total_cost
FROM bird_strike
GROUP BY Airline_Operator
ORDER BY sum(cost) desc;

SELECT YearColumn ,CONCAT('$ ', sum(cost)) as total_cost
FROM bird_strike
GROUP BY YearColumn 
ORDER BY sum(cost) desc;

--Impact 

select Aircraft_Model , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by Aircraft_Model
order by sum(wildlife_struck)desc;


select Airport_Name , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by Airport_Name
order by sum(wildlife_struck)desc;


select Phase_of_flight , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by Phase_of_flight
order by sum(wildlife_struck)desc;


select Wildlife_Size , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by Wildlife_Size
order by sum(wildlife_struck)desc;


select YearColumn , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by YearColumn
order by sum(wildlife_struck)desc;


SELECT top 15 Airport_Name , sum(people_injured) as total_people_injured
FROM bird_strike
GROUP BY Airport_Name
ORDER BY sum(people_injured) desc ;


SELECT top 15 Aircraft_Model  , sum(people_injured) as total_people_injured
FROM bird_strike
GROUP BY Aircraft_Model
ORDER BY sum(people_injured) desc ;


select airline_operator , count(pilot_warned_of_wildlife) as pilot_warned_of_wildlife , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by airline_operator
order by count(pilot_warned_of_wildlife) desc;


select Origin_State , sum(wildlife_struck) as total_wildlife_struck
from bird_strike
group by Origin_State
order by count(wildlife_struck) desc;


select * from bird_strike;


SELECT wildlife_size, flight_impact, COUNT(*) AS ImpactCount
FROM bird_strike
GROUP BY wildlife_size, flight_impact
ORDER BY ImpactCount DESC;

SELECT feet_above_ground, phase_of_flight, COUNT(*) AS Total_incident
FROM bird_strike
GROUP BY feet_above_ground, phase_of_flight
ORDER BY feet_above_ground, phase_of_flight;

SELECT origin_state, species, count(*) AS Total_incident
FROM bird_strike
GROUP BY origin_state, species
ORDER BY Total_incident DESC;

SELECT MONTH(flight_date) AS Month, COUNT(*) AS Total_incident
FROM bird_strike
GROUP BY MONTH(flight_date)
ORDER BY Month;

-- Trend Analysis: Year-over-Year Percentage Change in Bird Strikes

WITH YearlyStrikes AS (
    SELECT YearColumn, SUM(wildlife_struck) AS TotalStrikes
    FROM bird_strike
    GROUP BY YearColumn
)
SELECT 
    YearColumn,
    TotalStrikes,
    LAG(TotalStrikes) OVER (ORDER BY YearColumn) AS PreviousYearStrikes,
    CASE 
        WHEN LAG(TotalStrikes) OVER (ORDER BY YearColumn) IS NULL THEN NULL
        ELSE ((TotalStrikes - LAG(TotalStrikes) OVER (ORDER BY YearColumn)) * 100.0 / LAG(TotalStrikes) OVER (ORDER BY YearColumn)) 
    END AS YoY_Percentage_change
FROM YearlyStrikes;




WITH YearlyStrikes AS (
    SELECT YearColumn , sum(wildlife_struck) AS TotalStrikes
    FROM bird_strike
    GROUP BY YearColumn
),
Regression AS (
    SELECT 
        YearColumn ,
        TotalStrikes,
        AVG(TotalStrikes) OVER () AS AvgStrikes,
        AVG(YearColumn) OVER () AS AvgYear,
        (YearColumn - AVG(YearColumn) OVER ()) * (TotalStrikes - AVG(TotalStrikes) OVER ()) AS Covariance,
        POWER(YearColumn - AVG(YearColumn) OVER (), 2) AS Variance
    FROM YearlyStrikes
)
SELECT top 1
    (AVG(Covariance) OVER () / AVG(Variance) OVER ()) * (MAX(YearColumn) OVER () + 1 - AVG(YearColumn) OVER ()) + AVG(TotalStrikes) OVER () AS PredictedStrikes
FROM Regression;









