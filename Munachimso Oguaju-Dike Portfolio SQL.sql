--Question 1. Using Inner Join, retrieve the first name, last name and job title of the employee
SELECT p.FirstName, p.LastName, e.JobTitle
FROM Person.Person p
JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID;

--Question 2. Using the Left Join Query retrieve the first name, last name and email address of the employee

SELECT p.FirstName, p.LastName, ea.EmailAddress
FROM Person.Person p
LEFT JOIN Person.EmailAddress ea
ON p.BusinessEntityID = ea.BusinessEntityID;

--Question 3. Using the Right Join Query, retrieve the job title, first name and last name of the employee

SELECT e.JobTitle, p.FirstName, p.LastName
FROM HumanResources.Employee e
RIGHT JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID;

--Question 4. Using the Full Outer Join Query, retrieve the first name, last name and job title of the employee

SELECT p.FirstName, p.LastName, e.JobTitle
FROM Person.Person p
FULL OUTER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID;

--Question 5. Using the Self Join Query, retrieve the business entity id, job title and manager title of the employee

SELECT e1.BusinessEntityID, e1.JobTitle, e2.JobTitle AS ManagerTitle
FROM HumanResources.Employee e1
JOIN HumanResources.Employee e2
ON e1.BusinessEntityID = e2.BusinessEntityID
WHERE e1.BusinessEntityID = e2.BusinessEntityID;

--Question 6. Using the Subquery in WHERE Clause, retrieve the first name and last name of the employee

SELECT p.FirstName, p.LastName
FROM Person.Person p
WHERE p.BusinessEntityID IN (
                             SELECT BusinessEntityID FROM HumanResources.Employee);

--Question 7. Using the Subquery in SELECT Clause, retrieve the first name and last name of the employee and count the number of emails.

SELECT p.FirstName, p.LastName,
    (SELECT COUNT(*) FROM Person.EmailAddress ea WHERE ea.BusinessEntityID = p.BusinessEntityID) AS EmailCount
FROM Person.Person p;


--Question 8. Using the Common Table Expression (CTE), retrieve the business entity, job title and level of the employee.

WITH EmployeeHierarchy AS (
    SELECT BusinessEntityID, JobTitle, 0 AS Level
    FROM HumanResources.Employee
    WHERE BusinessEntityID = 1
    UNION ALL
    SELECT e.BusinessEntityID, e.JobTitle, eh.Level + 1
    FROM HumanResources.Employee e
    JOIN EmployeeHierarchy eh ON e.BusinessEntityID = eh.BusinessEntityID
)
SELECT * FROM EmployeeHierarchy;

--Question 9. Using the Common Table Expression (CTE), retrieve the department id in the sales department.

WITH DepartmentCTE AS (
    SELECT DepartmentID, Name
    FROM HumanResources.Department
    WHERE Name = 'Sales'
    UNION ALL
    SELECT d.DepartmentID, d.Name
    FROM HumanResources.Department d
    JOIN DepartmentCTE dc ON d.DepartmentID = dc.DepartmentID)
SELECT * FROM DepartmentCTE;

--Question 10. Using JOIN Query, retrieve the first name, last name.

SELECT p.FirstName, p.LastName, COUNT(e.BusinessEntityID) AS EmployeeCount
FROM Person.Person p
JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID
GROUP BY p.FirstName, p.LastName;

--Question 11. Using Join with subquery, retrieve the first name, last name and job title of the employee

SELECT p.FirstName, p.LastName, e.JobTitle
FROM Person.Person p
JOIN (SELECT BusinessEntityID, JobTitle FROM HumanResources.Employee) e
ON p.BusinessEntityID = e.BusinessEntityID;

--Question 12. What is the total sales of each sales person

WITH SalesCTE AS (
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY SalesPersonID
)
SELECT e.FirstName, e.LastName, s.TotalSales
FROM SalesCTE s
JOIN Sales.SalesPerson sp
ON s.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person e
ON sp.BusinessEntityID = e.BusinessEntityID;

--Question 13. What is the total name of each sales person using multiple joins

WITH EmployeeSales AS (
    SELECT sp.BusinessEntityID, SUM(soh.TotalDue) AS SalesAmount
    FROM Sales.SalesPerson sp
    JOIN Sales.SalesOrderHeader soh
    ON sp.BusinessEntityID = soh.SalesPersonID
    GROUP BY sp.BusinessEntityID
)
SELECT e.FirstName, e.LastName, es.SalesAmount
FROM EmployeeSales es
JOIN Person.Person e
ON es.BusinessEntityID = e.BusinessEntityID;

--Question 14. Retrieve the sales details of each customer

SELECT sh.CustomerID, sd.* 
FROM Sales.SalesOrderDetail sd
LEFT JOIN Sales.SalesOrderHeader sh 
ON sh.SalesOrderID = sd.SalesOrderID;

--Question 15. What is the number of employees in each department
SELECT d.Name AS Department, COUNT(e.BusinessEntityID) AS EmployeeCount
FROM HumanResources.Department d
JOIN HumanResources.EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
JOIN HumanResources.Employee e ON edh.BusinessEntityID = e.BusinessEntityID
GROUP BY d.Name;
