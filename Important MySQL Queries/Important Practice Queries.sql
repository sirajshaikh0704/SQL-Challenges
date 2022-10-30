CREATE DATABASE IMPORTANT_QUERIES;
USE IMPORTANT_QUERIES;
SHOW TABLES;

CREATE TABLE IF NOT EXISTS EmployeeInfo (
EpID INT NOT NULL,
EmpFname VARCHAR(20),
EmpLname VARCHAR(20),
Department VARCHAR(20),
Project VARCHAR(15),
Address VARCHAR(30),
DOB DATETIME,
Gender  VARCHAR(10)
);
    
ALTER TABLE EmployeeInfo
	MODIFY COLUMN DOB DATE;


INSERT INTO EmployeeInfo VALUES
	(1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', 01/12/1976, 'M'),
	(2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', 02/05/1968, 'F'),
	(3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', 01/01/1980, 'M'),
	(4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', 02/05/1992, 'F'),
	(5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', 03/07/1994, 'M');

UPDATE EmployeeInfo
	SET DOB = "1976-12-01" WHERE EmpID=1;
    
UPDATE EmployeeInfo
	SET DOB = "1968-05-02" WHERE EmpID=2;

UPDATE EmployeeInfo
	SET DOB = "1980-01-01" WHERE EmpID=3;

UPDATE EmployeeInfo
	SET DOB = "1992-05-02" WHERE EmpID=4;

UPDATE EmployeeInfo
	SET DOB = "1994-07-03" WHERE EmpID=5;
    
SELECT * FROM EmployeePosition;

CREATE TABLE IF NOT EXISTS EmployeePosition  (
EmpID INT , 
EmpPosition VARCHAR(20), 
DateOfJoining DATE,
SALARY INT
);

INSERT INTO EmployeePosition VALUES
	(1, 'Manager', "2022-05-01", 500000),
	(2, 'Executive', "2022-05-02", 75000),
    	(3, 'Manager', "2022-05-01", 90000),
    	(2, 'Lead', "2022-05-02",  85000),
    	(1, 'Executive', "2022-05-01", 300000);
    
SELECT * FROM EmployeePosition;

-- Q1. Write a query to fetch the EmpFname from the EmployeeInfo table in upper case and use the ALIAS name as EmpName.
SELECT UPPER(empFname) AS EmpName
	FROM employeeinfo;

-- Q2. Write a query to fetch the number of employees working in the department ‘HR’.
SELECT COUNT(*) 
	FROM EmployeeInfo
		WHERE department ='HR';
        
-- Q3. Write a query to get the current date.
SELECT CURRENT_DATE();
SELECT CURDATE();
SELECT SYSDATE();

-- Q4. Write a query to retrieve the first four characters of  EmpLname from the EmployeeInfo table.
SELECT SUBSTRING(EmpLname, 1, 4) AS first_four_characters 
	FROM EmployeeInfo;
    
-- Q5. Write a query to fetch only the place name(string before brackets) from the Address column of EmployeeInfo table.

SELECT substr(Address, 1, locate('(',Address)) AS Address FROM EmployeeInfo;


-- Q6. Write a query to create a new table which consists of data and structure copied from the other table.

CREATE TABLE NewTable AS SELECT * FROM EmployeeInfo;
SELECT * FROM NewTable;

-- Q7. Write a query to find all the employees whose salary is between 50000 to 100000.

SELECT * FROM EmployeeInfo;
SELECT * FROM EmployeePosition;

SELECT EI.EmpFname AS Name, EI.department AS Department, EP.EmpPosition AS Position, EP.salary AS Salary
	FROM EmployeeInfo EI
		JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
			WHERE Salary between 50000 AND 100000;

-- Q8. Write a query to find the names of employees that begin with ‘S’

SELECT * FROM EmployeeInfo
	WHERE EmpFname like 'S%';
    
-- Q9. Write a query to fetch top N records.
SELECT * FROM EmployeePosition ORDER BY Salary DESC lIMIT N;

/* Q10. Write a query to retrieve the EmpFname and EmpLname in a single column as “FullName”.
        The first name and the last name must be separated with space. */
        
SELECT CONCAT(empFname, ' ', empLname) AS 'FullName'
	FROM EmployeeInfo;
    
-- Q11. Write a query find number of employees whose DOB is between "1976-12-01" TO "1980-01-01".

SELECT * FROM EmployeeInfo
	WHERE DOB BETWEEN "1976-12-01" AND "1980-01-01";
    
/* Q12. Write a query to fetch all the records from the EmployeeInfo table
		ordered by EmpLname in descending order and Department in the ascending order. */
        
SELECT * FROM EmployeeInfo
	ORDER BY EmpLname DESC, department;
    
-- Q13. Write a query to fetch details of employees whose EmpLname ends with an alphabet ‘A’ and contains five alphabets.

SELECT * FROM EmployeeInfo
	WHERE EmpLname LIKE '_____A%';
    
/* Q14. Write a query to fetch details of all employees excluding the employees
		with first names, “Sanjay” and “Sonia” from the EmployeeInfo table. */
        
SELECT * FROM EmployeeInfo
	WHERE empFname NOT IN ('Sanjay' , 'Sonia');
    
-- Q15. Write a query to fetch details of employees with the address as “DELHI(DEL)”.

SELECT * FROM EmployeeInfo
	WHERE address = 'DELHI(DEL)';
    
-- Q16. Write a query to fetch all employees who also hold the managerial position.

SELECT * FROM EmployeeInfo;
SELECT * FROM EmployeePosition;

SELECT CONCAT(EI.EmpFname,' ',EI.EmpLname) AS FullName, EP.EmpPosition AS Position
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
				WHERE P.EmpPosition = 'Manager';
                
-- OR 

SELECT CONCAT(EI.EmpFname,' ',EI.EmpLname) AS FullName, EP.EmpPosition AS Position
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
				AND EP.EmpPosition IN ('Manager');
                
-- Q17. Write a query to fetch the department-wise count of employees sorted by department’s count in ascending order.

SELECT department, COUNT(EmpID) as Emp_Count
	FROM EmployeeInfo
		GROUP BY department
			ORDER BY Emp_Count;
            
-- Q18. Write a query to calculate the even and odd records from a table.
        
SELECT * FROM EmployeeInfo
	WHERE MOD(empID , 2) = 0;
    
SELECT * FROM EmployeeInfo
	WHERE MOD(empID , 2) !=0;
    
-- Q19. Write a SQL query to retrieve employee details from EmployeeInfo table who have a date of joining in the EmployeePosition table.
	
SELECT DISTINCT(CONCAT(EI.empFname,' ',EI.empLname)) AS FullName, EP.DateOfJoining
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID;
            
-- Q20. Write a query to retrieve two minimum and maximum salaries from the EmployeePosition table.
SELECT CONCAT(EI.empFname,' ',EI.empLname) AS FullName, EP.Salary AS Salary
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
				ORDER BY SALARY DESC
					LIMIT 2;

SELECT CONCAT(EI.empFname,' ',EI.empLname) AS FullName, EP.Salary AS Salary
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
				ORDER BY SALARY 
					LIMIT 2;


-- Q21. Write a query to find the Nth highest salary from the table without using TOP/limit keyword.
SELECT EP1.SALARY FROM EmployeePosition EP1
	WHERE N-1 = 
		(SELECT COUNT(EP2.Salary) FROM
			EmployeePosition EP2
				WHERE EP2.Salary > EP1.Salary) ;
                
-- or


SELECT * FROM
	(SELECT CONCAT(EI.empFname,' ',EI.empLname) AS FullName, EP.Salary AS Salary,
		DENSE_RANK() OVER(ORDER BY SALARY DESC) AS Salary_Rank
			FROM EmployeeInfo EI
				INNER JOIN EmployeePosition EP
					ON EI.EmpID = EP.EmpID) AS A
						WHERE Salary_Rank = N;
                        
-- Q22. Write a query to retrieve duplicate records from a table.
SELECT * FROM EmployeePosition
	GROUP BY EmpID
		HAVING count(*) >1;
        
-- Q23. Write a query to retrieve the list of employees working in the same department.
SELECT department, COUNT(EmpFname) AS Emp_Count
	FROM EmployeeInfo
		GROUP BY department;
        
-- Q24. Write a query to retrieve the last 3 records from the EmployeeInfo table.
SELECT * FROM EmployeeInfo
	ORDER BY empID DESC
		LIMIT 3;

-- OR

SELECT * FROM EmployeeInfo
	LIMIT 2,3;
		
-- Q25. Write a query to find the third-highest salary from the EmpPosition table.

SELECT EP1.EmpID, EP1.Salary
	FROM EmployeePosition EP1
		WHERE 3-1 =
			(SELECT COUNT(EP2.Salary)
				FROM EmployeePosition EP2
					WHERE EP2.Salary > EP1.Salary);
	
-- Q26. Write a query to display the first and the last record from the EmployeeInfo table.
	SELECT * FROM EmployeeInfo
		WHERE EmpID = (SELECT MIN(EmpID) FROM EmployeeInfo);
    
    SELECT * FROM EmployeeInfo
		WHERE EmpID =( SELECT MAX(EmpID) FROM EmployeeInfo);
					  
-- Q27. Write a query to add email validation to your database
 SELECT * FROM EmployeeInfo WHERE Email NOT REGEXP'^[^@]+@[^@]+\.[^@]{2,}$';

-- Q28. Write a query to retrieve Departments who have less than 2 employees working in it.
SELECT DEPARTMENT, COUNT(EmpID) as EmpNo
	FROM EmployeeInfo
		GROUP BY DEPARTMENT
			HAVING COUNT(EmpID) < 2;

-- Q29. Write a query to retrieve EmpPostion along with total salaries paid for each of them.

SELECT EI.EmpFname, EP.EmpPosition as Position, SUM(Salary) AS Salary
	FROM EmployeeInfo EI
		INNER JOIN EmployeePosition EP
			ON EI.EmpID = EP.EmpID
				GROUP BY EmpPosition;

-- Q30. Write a query to fetch 50% records from the EmployeeInfo table.
SELECT * 
	FROM EmployeeInfo
		WHERE EmpID <=(
			SELECT COUNT(EmpID)/2 from EmployeeInfo);
			
			
			
			                                               -- Thank You  --  
