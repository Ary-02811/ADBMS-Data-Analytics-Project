CREATE TABLE brands (
    Brand_ID VARCHAR PRIMARY KEY,
    Brand_Name VARCHAR,
    Country VARCHAR,
    Founded_Year INT
);

CREATE TABLE hypercars (
    Car_ID VARCHAR PRIMARY KEY,
    Brand_ID VARCHAR,
    Model_Name VARCHAR,
    Launch_Year INT,
    Country VARCHAR,
    FOREIGN KEY (Brand_ID) REFERENCES brands(Brand_ID)
);

CREATE TABLE tech_specs (
    Spec_ID VARCHAR PRIMARY KEY,
    Car_ID VARCHAR,
    Engine_Type VARCHAR,
    Horsepower INT,
    Torque_Nm INT,
    Top_Speed_kmph INT,
    FOREIGN KEY (Car_ID) REFERENCES hypercars(Car_ID)
);

CREATE TABLE performance (
    Perf_ID VARCHAR PRIMARY KEY,
    Car_ID VARCHAR,
    Acceleration_0_100_sec FLOAT,
    Weight_kg INT,
    Power_to_Weight FLOAT,
    FOREIGN KEY (Car_ID) REFERENCES hypercars(Car_ID)
);

CREATE TABLE market (
    Market_ID VARCHAR PRIMARY KEY,
    Car_ID VARCHAR,
    Year INT,
    Units_Produced INT,
    Price_Million FLOAT,
    FOREIGN KEY (Car_ID) REFERENCES hypercars(Car_ID)
);


COPY brands
FROM 'C:/Users/Aryan/Desktop/ADBMS/Project/clean_brands.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM brands;

SELECT COUNT(*) FROM brands;

copy hypercars FROM 'C:/Users/Aryan/Desktop/ADBMS/Project/clean_hypercars.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM hypercars;

copy tech_specs FROM 'C:/Users/Aryan/Desktop/ADBMS/Project/clean_tech_specs.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM tech_specs;

copy performance FROM 'C:/Users/Aryan/Desktop/ADBMS/Project/clean_performance.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM performance;

copy market FROM 'C:/Users/Aryan/Desktop/ADBMS/Project/clean_market.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM market;

ALTER TABLE market
ALTER COLUMN Units_Produced TYPE FLOAT;

-- Get top 10 cars based on highest top speed
SELECT h.Model_Name, t.Top_Speed_kmph
FROM hypercars h
JOIN tech_specs t 
    ON h.Car_ID = t.Car_ID   -- joining tables using Car_ID
ORDER BY t.Top_Speed_kmph DESC   -- sort from highest speed
LIMIT 10;   -- restrict to top 10

-- Get top 10 cars with highest horsepower
SELECT h.Model_Name, t.Horsepower
FROM hypercars h
JOIN tech_specs t 
    ON h.Car_ID = t.Car_ID
ORDER BY t.Horsepower DESC   -- highest power first
LIMIT 10;

-- Calculate average price of cars for each brand
SELECT b.Brand_Name, AVG(m.Price_Million) AS Avg_Price
FROM brands b
JOIN hypercars h 
    ON b.Brand_ID = h.Brand_ID   -- connect brand to cars
JOIN market m 
    ON h.Car_ID = m.Car_ID       -- connect cars to market data
GROUP BY b.Brand_Name           -- group results by brand
ORDER BY Avg_Price DESC;        -- highest average price first

-- Find cars with best power-to-weight ratio
SELECT h.Model_Name, p.Power_to_Weight
FROM hypercars h
JOIN performance p 
    ON h.Car_ID = p.Car_ID
ORDER BY p.Power_to_Weight DESC   -- higher ratio = better performance
LIMIT 10;

-- Calculate total units produced for each brand
SELECT b.Brand_Name, SUM(m.Units_Produced) AS Total_Production
FROM brands b
JOIN hypercars h 
    ON b.Brand_ID = h.Brand_ID
JOIN market m 
    ON h.Car_ID = m.Car_ID
GROUP BY b.Brand_Name
ORDER BY Total_Production DESC;   -- highest production first

-- Categorize cars based on engine type
SELECT 
    CASE 
        WHEN Engine_Type = 'Electric' THEN 'Electric'
        ELSE 'Non-Electric'
    END AS Type,
    COUNT(*) AS Count   -- count number of cars in each category
FROM tech_specs
GROUP BY Type;

-- Get cars with acceleration less than 2.5 seconds
SELECT h.Model_Name, p.Acceleration_0_100_sec
FROM hypercars h
JOIN performance p 
    ON h.Car_ID = p.Car_ID
WHERE p.Acceleration_0_100_sec < 2.5   -- filter fast cars
ORDER BY p.Acceleration_0_100_sec;     -- fastest first

-- Get top 10 most expensive cars
SELECT h.Model_Name, m.Price_Million
FROM hypercars h
JOIN market m 
    ON h.Car_ID = m.Car_ID
ORDER BY m.Price_Million DESC   -- highest price first
LIMIT 10;

-- Create a view combining all important details
CREATE VIEW car_full_details AS
SELECT 
    h.Model_Name,
    b.Brand_Name,
    t.Horsepower,
    t.Top_Speed_kmph,
    p.Acceleration_0_100_sec,
    m.Price_Million
FROM hypercars h
JOIN brands b 
    ON h.Brand_ID = b.Brand_ID
JOIN tech_specs t 
    ON h.Car_ID = t.Car_ID
JOIN performance p 
    ON h.Car_ID = p.Car_ID
JOIN market m 
    ON h.Car_ID = m.Car_ID;

-- View the combined dataset
SELECT * FROM car_full_details;


