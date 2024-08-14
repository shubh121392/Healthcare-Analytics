SELECT * FROM healthcare_dataset;
-- 1. Counting Total Record in Database
select count(*) from healthcare_dataset;

-- 2. Finding maximum age of patient admitted
Select max(age) as maximum_age from healthcare_dataset;

-- 3. Finding Average age of hospitalized patients.
select avg(age) as Average_age from healthcare_dataset;

-- 4. Calculating Patients Hospitalized Age-wise from Maximum to Minimum
select age, count(name) as Patients_count from healthcare_dataset
group by age 
order by age desc;

-- 5. Calculating Maximum Count of patients on the basis of total patients hospitalized with respect to age.
select age, count(age) as Total from healthcare_dataset
group by age
order by Total desc;

-- 6. Ranking Age on the number of patients Hospitalized
select age, count(age) as age_count,
dense_rank() over(order by count(age) desc, age desc) as Ranking_Admitted
from healthcare_dataset
group by age;

-- OR--
select age, count(age) as age_count,
dense_rank() over w as Ranking_Admitted
from healthcare_dataset
group by age
window w as (order by count(age) desc, age desc);

-- 7. Finding Count of Medical Condition of patients and listing it by maximum number of patients.
select Medical_Condition, count(Medical_condition) as Patients_condition from healthcare_dataset
group by Medical_Condition
order by Patients_condition desc;

-- 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.
select 'Medical Condition', medication, count(medication) as Total_Medication_of_patients,
rank() over (partition by 'Medical Condition' order by count(medication) desc) as Medication_Rank
from healthcare_dataset
group by medication
order by Total_Medication_of_patients;
    
-- 9. Most preferred Insurance Provider by Patients Hospitalized
select Insurance_Provider,  count(Insurance_Provider) as Preferred_Insurance
from healthcare_dataset
group by Insurance_Provider
order by Preferred_Insurance desc
limit 1;
    

-- 10. Finding out the most preferred Hospital
select hospital, count(Hospital) as Most_preferred from healthcare_dataset
group by hospital
order by Most_preferred desc
limit 1;


-- 11. Identifying Average Billing Amount by Medical Condition.
select Medical_Condition, round(avg(billing_amount),2) as Average_Billing_Amount from healthcare_dataset
group by Medical_Condition
Order by Average_Billing_Amount desc;


-- 12. Finding Billing Amount of patients admitted and the number of days spent in respective hospital.
select name, hospital,
Date_of_Admission, Discharge_date, round((billing_amount),2) as Billing_amount, 
DATEDIFF(Discharge_date, Date_of_Admission) as Number_of_Days
from healthcare_dataset
order by Number_of_Days desc
limit 10000;

-- 13. Finding Total number of days spent by a patient in a hospital for a given medical condition
select Name, Medical_Condition, 
sum(datediff(Discharge_date, Date_of_Admission)) as Total_spent_days,
hospital
from healthcare_dataset
group by name, Medical_Condition, Hospital
order by Total_spent_days desc;

-- 14. Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with the count of days taken to get results to Normal
select Name, Hospital, Test_Results,
datediff(Discharge_date, Date_of_Admission) as Day_count
from healthcare_dataset
where Test_Results = 'Normal'
order by Day_count desc;


-- 15. Calculate the number of blood types of patients which lie between age 20 to 45
select Age, Blood_Type, count(Blood_Type) as Total_Bloodtype from healthcare_dataset
where age between '20' and '45'
group by Age, Blood_Type
order by Total_Bloodtype;


-- 16. Find how many patients are Universal Blood Donors and Universal Blood Receivers
select 
count(Name) as No_of_Patients,
Blood_Type
from healthcare_dataset
where blood_type = 'O-' or blood_type = 'AB+' 
group by  Blood_Type
order by No_of_Patients desc;

-- OR

select 
sum(case when blood_type = 'O-' then 1 else 0 end) as universal_donors,
sum(case when blood_type = 'AB+' then 1 else 0 end) as universal_receivers
from healthcare_dataset;


-- 17. Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025
select Hospital, count(Name) as Patients_Admitted
from healthcare_dataset
where year(Date_of_Admission) IN (2024,2025)
group by Hospital
order by patients_admitted desc;

-- 18. Find the average, minimum, and maximum billing amount for each insurance provider
select  Insurance_Provider,
round(avg(billing_amount),0) as 'Average',
round(min(billing_amount),0) as 'Minimum',
round(max(billing_amount),0) as 'Maximum'
from healthcare_dataset group by Insurance_Provider;

-- Or

SELECT 
    insurance_provider,
    billing_amount,
    AVG(billing_amount) OVER (PARTITION BY insurance_provider) AS avg_billing_amount,
    MIN(billing_amount) OVER (PARTITION BY insurance_provider) AS min_billing_amount,
    MAX(billing_amount) OVER (PARTITION BY insurance_provider) AS max_billing_amount
FROM 
    healthcare_dataset;

-- 19. Create a new column that categorizes patients as high, medium, or low risk based on their medical condition
select distinct test_results from healthcare_dataset;
select 
Name, Medical_Condition,
case 
when test_results = 'Inconclusive' then 'Medium_risk'
when test_results = 'Normal' then  'Low_risk'
when test_results = 'Abnormal' then 'High_risk'
end as Risk_Category
from healthcare_dataset;








