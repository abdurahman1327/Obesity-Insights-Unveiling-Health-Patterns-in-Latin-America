
/*
 Index
0 - Table Creation

1 - Quality Check
	1.0 NULLS
	1.1 Minimum
	1.2 Maximum
	1.3 Average
	1.4 Outliers
	1.5 Duplicates

2 - Interesting Queries
	2.0 Number of people in each weight category
	2.1 Average daily water consumption for every weight category
	2.2 Average calories consumption monitoring for each obesity level
	2.3 Frequency of alcohol consumption for every weight category 
	2.4 Average height and weight for obesity in family history and not in family history
	2.5 Ages of people that are underweight weight
	2.6 Number of people consuming high-caloric food by gender
	2.7 The most common transportation method for different ages
	2.8 The most common weight category for each age
	2.9 Relationship between physical activity frequency and obesity levels

 Glossary
1. family_history - Is there a history of obesity in the family? (yes or no)
2. favc - Frequency consumption of high caloric food
3. fcvc - Frequency of consumption of vegetables
4. ncp - Number of main meals
5. caec -  Consumption of food between meals
6. smoke - Are they a smoker? (yes or no)
7. ch2o - Consumption of water daily
8. scc - Calories consumption monitoring
9. faf - Physical activity frequency
10. tue - Time using technology devices
11. calc - Consumption of alcohol
12. mtrans - Transportation used
13. nobeyesdad - weight category

 */


-- 0: Creating table for risk of obesity
CREATE TABLE student.obesity_data (
	gender varchar(10),
	age integer,
	height decimal,
	weight decimal,
	family_history varchar(5),
	favc varchar(5),
	fcvc integer,
	ncp integer,
	caec varchar(15),
	smoke varchar(5),
	ch2o integer,
	scc varchar(5),
	faf integer,
	tue integer,
	calc varchar(15),
	mtrans varchar(25),
	nobeyesdad varchar(25)
)

-- Import Obesity or CVD risk data

-- 1: Quality check
-- 1.0 Checking for NULLS (Result- no NULLS)
SELECT 
	*
FROM 
	student.obesity_data
WHERE gender IS NULL OR age IS NULL OR height IS NULL OR weight IS NULL;

-- 1.1 Checking MIN of age, height and weight columns (Result- 14, 1.45, 39)
SELECT
	min(age) AS min_age,
	min(height) AS min_height,
	min(weight) AS min_weight
FROM
	student.obesity_data;

-- 1.2 Checking MAX of age, height and weight columns (Result- 61, 1.98, 173)
SELECT
	max(age) AS max_age,
	max(height) AS max_height,
	max(weight) AS max_weight
FROM
	student.obesity_data;
	
-- 1.3 Checking AVG of age, height and weight columns (Result(2dp)- 23.97, 1.70, 86.59)
SELECT
	avg(age) AS avg_age,
	avg(height) AS avg_height,
	avg(weight) AS avg_weight
FROM
	student.obesity_data;
	
-- 1.4 Checking for outliers (Result- No outliers)
SELECT
    gender,
    age,
    height,
    weight
FROM 
	student.obesity_data
WHERE 
	age < 14 OR age > 61 OR height < 1.40 OR height > 1.98 OR weight < 39 OR weight > 173;

-- 1.5 Checking for duplicated rows (14 different duplicates with the highest duplicate count being 15(from the type of data collcted it is most likely legitemate repetition))
SELECT
    gender,
    age,
    height,
    weight,
    family_history,
    favc,
    fcvc,
    ncp,
    caec,
    smoke,
    ch2o,
    scc,
    faf,
    tue,
    calc,
    mtrans,
    nobeyesdad,
    count(*) AS duplicate_count
FROM 
	student.obesity_data
GROUP BY
    gender,
    age,
    height,
    weight,
    family_history,
    favc,
    fcvc,
    ncp,
    caec,
    smoke,
    ch2o,
    scc,
    faf,
    tue,
    calc,
    mtrans,
    nobeyesdad
HAVING count(*) > 1;


-- 2: Interesting qeuries
-- 2.0 Counting the number of people in each weight category by gender
SELECT
    gender,
    nobeyesdad,
    COUNT(*) AS count
FROM 
	student.obesity_data
GROUP BY 
	gender, 
	nobeyesdad
ORDER BY 
	gender, 
	count DESC;
	
-- 2.1 Average daily water consumption for every weight category
SELECT
    nobeyesdad,
    AVG(ch2o) AS avg_water_consumption
FROM 
	student.obesity_data
GROUP BY 
	nobeyesdad
ORDER BY 
	avg_water_consumption desc;

-- 2.2 Average calories consumption monitoring for each obesity level
SELECT
    nobeyesdad,
    avg(CASE WHEN scc = 'yes' THEN 1 ELSE 0 END) AS avg_calories_monitoring
FROM 
	student.obesity_data
GROUP BY 
	nobeyesdad
ORDER BY 
avg_calories_monitoring desc;

-- 2.3 Frequency of alcohol consumption for every weight category 
SELECT
    nobeyesdad,
    favc,
    count(*) AS count
FROM 
	student.obesity_data
GROUP BY 
	nobeyesdad, 
	favc
ORDER BY 
	nobeyesdad, 
	count DESC;

-- 2.4 Average height and weight for obesity in family history and not in family history
SELECT
    family_history,
    AVG(height) AS avg_height,
    AVG(weight) AS avg_weight
FROM 
	student.obesity_data
GROUP BY 
	family_history;
	
-- 2.5 Ages of people that are underweight weight
SELECT
    age,
    count(*) AS count
FROM 
	student.obesity_data
WHERE 
	nobeyesdad = 'Insufficient_Weight'
GROUP BY 
	age
ORDER BY 
	age;
	
-- 2.6 Number of people consuming high-caloric food by gender
SELECT
    gender,
    favc,
    count(*) AS count
FROM 
	student.obesity_data
GROUP BY 
	gender, 
	favc
ORDER BY 
	gender, 
	count DESC;
	
-- 2.7 The most common transportation method for different ages
SELECT
    age,
    mode() WITHIN GROUP (ORDER BY mtrans) AS most_common_transportation
FROM 
	student.obesity_data
GROUP BY 
	age
ORDER BY 
	age;

-- 2.8 The most common weight category for each age
SELECT 
	age,
	mode() WITHIN GROUP (ORDER BY nobeyesdad) AS most_common_weight_category
FROM 
	student.obesity_data
GROUP BY 
	age
ORDER BY 
	age;
	
-- 2.9 Relationship between physical activity frequency and obesity levels
SELECT
    faf,
    nobeyesdad,
    count(*) AS count
FROM 
	student.obesity_data
GROUP BY 
	faf, 
	nobeyesdad
ORDER BY 
	count desc;
