create database projects;
use projects;
show tables;

create table if not exists hr(
id varchar(50) not null,
first_name varchar(30),
last_name varchar(30),
birthdate Varchar(50),
gender varchar(10),
race varchar(100),
department varchar(100),
jobtitle varchar(30),
location varchar(30),
hire_date varchar(50),
termdate varchar(50),
location_city varchar(100),
location_state varchar(100));

describe hr;

load data infile
'D:/Power BI Projects/HR Project with SQL and Power BI/Human Resources.csv'
into table hr
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from hr;

alter table hr
change column id emp_id varchar(50);

alter table hr
change column jobtitle job_title varchar(100);

select birthdate from hr;

update hr
set birthdate = 
case 
when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
else null
end;

alter table hr
modify column birthdate date;

select hire_date from hr;

update hr
set hire_date = 
case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;

alter table hr
modify column hire_date date;

select * from hr;

select termdate from hr;

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d'))
where termdate is not null and termdate != '';

update hr
set termdate = date()
where termdate is null;

select termdate from hr;

describe hr;

alter table hr
modify column termdate date;

alter table hr
add column age int;

update hr
set age = timestampdiff(Year, birthdate, curdate());

select birthdate, age from hr;

select count(*) from hr
where age > 0;

select * from hr;

-- Q1. what is gender breakdown of employees in the company.
select gender,count(*) from hr
where age >= 18 and termdate = "0000-00-00"
group by gender;

-- Q2. what is the race/ethnicity breakdown of employees in the company
 select race, count(*) from hr
 where age >= 18 and termdate = "0000-00-00"
 group by race
 order by race desc;

select age , count(*) from hr
 where age >= 18 and termdate = "0000-00-00"
 group by age;
 
 -- Q3. waht is the age distribution in the company?
 
 select 
 case
 when age >= 18 and age <= 25 
 then "18 - 25"
 when age >=26 and age <= 30
 then "26 - 30"
 when age >= 31 and age <= 40
 then "31 - 40"
 when age >= 41 and age <= 50 
 then "41 - 50"
 else "Above 50"
 end as age_group , gender, count(*)
 from hr where age >=18
 and termdate = "0000-00-00"
group by age_group,gender
order by age_group,gender;

select * from hr;

-- Q4. How many employees working in headquaters and remote?

select location,count(*) from hr
where age >=18
and termdate = "0000-00-00"
group by location;

select department,location,count(*) from hr
where age >=18
and termdate = "0000-00-00"
group by department , location
order by department;

-- Q5. what is the average lenght of employment who have been terminated?

select round(avg(datediff(termdate,hire_date))/365,2) as avg_Emp_Duration
from hr
where age >=18 and termdate != '2023-07-18' and termdate <= curdate();

-- Q6. How does gender distribution vary across the departments and job titles

select * from hr;

select department , job_title , gender , count(*) from hr
where age >= 18
group by department , job_title , gender
order by department , job_title , gender;

-- Q7. Which department has highesst turmination rate?

select
department, 
total_count,
(terminated_count / total_count) as termination_rate
from(
select department ,count(*) as total_count,
sum(case
when termdate != '2023-07-18' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age >= 18
group by department
order by department) as subquery;

-- Q8. What is the distribution of employees across locations by city and state

select * from hr;

select location_state, location_city , count(*)
from hr
where age >= 18 and termdate = '2023-07-18'
group by location_state, location_city
order by location_state, location_city;

-- Q.9 How has the company's employee count chnaged over time based on hire and term date?

select `year`,
hires,
terminateds,
hires-terminateds as net_changed,
round((((hires-terminateds)/hires)*100),2) as `%net_changed`
from(
select year(hire_date) as `year` , count(*) as hires,
sum(case
when termdate != '2023-07-18' and termdate <= curdate() 
then 1 else 0 end) as terminateds
from hr
where age >= 18
group by `year`
order by `year`) as subquery;

-- Q10 What is the tenure distribution for each daparment?

select department , round(avg(datediff(termdate , hire_date)/365),0) as avg_tenure
from hr
where age >= 18 and termdate != '2023-07-18' and termdate <= curdate()
group by department;