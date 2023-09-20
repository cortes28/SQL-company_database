-- Drop the student table, moving on to a more complex SQL database
DROP TABLE student;

-- super_id and branch_id initially initialized w/out the 'FOREIGN KEY' as the table where it is a key hasnt been created yet
-- later we will be able to update it to be considered as a 'FOREIGN KEY'
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);


-- Foreign key of mgr_id referencing back to employee table where emp_id is the reference and on delete set to null
CREATE TABLE branch(
branch_id INT PRIMARY KEY,
branch_name VARCHAR(40),
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);


-- Now we can set the foreign key on employee table where branch_id is the name from branch(branch_id) and on delete->NULL
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

-- set foreign key on super_id where in employee (same table) reference emp_id  and on delete set to NULL
ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;


CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

-- two items will be considered as a key (composite key) and they are also foreign keys from other tables
-- ON DELETE CASCADE has not been explained set (explanation ->)
CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY (emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

-- composite key alongside with branch_id being a FOREIGN KEY
CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Corporate Since the branch value has not been created, the branch_id value cannot be added into the query
-- it is a foreign key, so it has to exist in its main table first
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

-- Created the branch 'Corporate'
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

-- Note that here super_id is not NULL as Jan does have a supervisor, also branch_id is 1 as the value for corporate branch 
-- exists now
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- branch_id is NULL as the Scranton Branch does not exist at this moment
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

-- Scranton branch is now exists 
INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

--update the employee database where emp_id = 102 has branch_id = 2 as a FOREIGN KEY (now it exists -> can be added)
UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

-- Employees of the Scranton Branch
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- New manager part of the Stamford branch -- FOREIGN KEY for branch_id DNE as the particular branch has not been
-- added to the branch database
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

-- Created the instance of Stamford Branch in branch database
INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

-- Now to update the employee value as now the branch exists
UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

-- add employees from Stamford branch
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- Branch supplier values
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uniball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- Client values
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana County', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- the connection of employee and client 
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


-- ============================================================ --

-- Find all employees
SELECT * 
FROM employee;

-- Find all clients
SELECT * 
FROM client;

-- Find all employees ordered by salary
SELECT * 
FROM employee
ORDER BY salary ASC;

-- Do the same query but order from the highest-paid employee to the lowest
SELECT *
FROM employee
ORDER BY salary DESC;

-- Find all employees ordered by sex then by name
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

-- Find the first 5 employees in the table
SELECT *
FROM employee
LIMIT 5;

-- find the first and last names of all employees
SELECT first_name, last_name
FROM employee;

-- Find the forename and surnames names of all employees
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Find out all the different genders
SELECT DISTINCT sex
FROM employee;


-- ========================= Functions ========================= --

-- Find the number of employees (if null is there -> does not count it)
SELECT COUNT(emp_id)
FROM employee;

-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_date > '1970-01-01';


-- Find the average of all employees' salaries
SELECT AVG(salary)
FROM employee;

-- Find the average of all employees' salaries WHO are male
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- Find the sum of all employees' salaries
SELECT SUM(salary)
FROM employee;

-- Find out how many males and females there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Find the cost of each client
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;


-- =================== WILDCARDS =================== --
-- % = Any # characters, _ = one character

-- Find any client's who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- Find any branch suppliers who are in a label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

--Find any employee born in October
SELECT * 
from employee
WHERE birth_date LIKE '%-10-%';

-- also works
SELECT * 
from employee
WHERE birth_date LIKE '____-02-__';

SELECT *
from client;

-- Find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

-- ========================== union ========================== --

-- Find a list of employee and branch names
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch
UNION 
SELECT client_name
FROM client;

-- Find a list of all clients & branch supplier's names
-- where tehre is the same 'branch_id' can do 'client.branch_id'
SELECT client_name, branch_id
FROM client
UNION
select supplier_name, branch_id
FROM branch_supplier;

--Find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- ========================== JOIN ========================== --
-- = useful for combining information from different tables = --

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- Find all branches and the names of their managers
-- Type of inner join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

-- Type of LEFT join
-- employee values also got included (left table contains these values ->append them too)
-- alongside with the right table of those values that MATCH the condition
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;


-- RIGHT join
-- includes all of the right table values as a RIGHT JOIN, only 
-- left table values that match the condition are added
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;


-- Full outer join < can't do here>

-- =========================== NESTED QUERIES =========================== --
-- where we use multiple SELECT statements stacked upon each other --

-- Find names of all employees who have sold over 30,000 to a single client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);


--Find all clients who are handles by the branch that Michael (Scranton Manager) manages
-- Assume that we know Michael's ID
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
    LIMIT 1 -- makes sure that we only get one branch
);

-- If there is a foreign key, and if in the table where that key gets deleted 
-- if the option of when it gets deleted is set to become NULL, the foreign key everywhere else
-- will get set to NULL

-- On delete cascade-> where ever that foreign key is at, it deletes the entire row
DELETE FROM employee
WHERE emp_id = 102;

-- manager for Scranton gets set to NULL as that is how we have it for those that reference
-- the employee 102 (Michael Scott) as a supervisor_id
SELECT *
from branch;

SELECT *
from employee;

-- Look at what happens when a FOREIGN KEY that is ON DELETE CASCADE appears
DELETE FROM BRANCH
WHERE branch_id = 2;
-- Looking at the branch suppliers, wherever the branch_id = 2 was -> those rows are now deleted
-- No longer any branch_id = 2 as CASCADE got rid of it
SELECT * 
FROM branch_supplier;

SELECT * 
FROM employee;

-- ======================= RE-ADDING VALUES ======================= --
-- re-add Michael Scott and Scranton Branch
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 101, NULL);

SELECT * 
FROM branch;


INSERT INTO branch VALUES(2, 'Scranton', 102, '1999-01-23');


UPDATE employee
SET branch_id = 2
WHERE branch_id IS NULL;

SELECT * 
FROM employee;

UPDATE employee
SET super_id = 102
WHERE branch_id = 2;

SELECT *
FROM employee;

SELECT *
FROM client;

UPDATE client
SET branch_id = 2
WHERE branch_id IS NULL;

SELECT *
FROM client;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA='girrafe'; 

UPDATE employee
SET super_id = 101
WHERE emp_id = 102;

--
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.super_id = 102;

SELECT *
FROM works_with;

-- sums the sales of each employee (id, first name) 
SELECT SUM(works_with.total_sales), works_with.emp_id, employee.first_name
FROM works_with
JOIN employee ON employee.emp_id = works_with.emp_id 
GROUP BY works_with.emp_id;

SELECT *
FROM branch;

-- every employee that is not a member of management
SELECT employee.emp_id, employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id NOT IN (
    SELECT branch.mgr_id
    FROM branch
    WHERE mgr_id IS NOT NULL
);

SELECT *
FROM works_with;

SELECT * 
FROM client;

-- The total sales of each client
SELECT SUM(works_with.total_sales) AS Sales, works_with.client_id, client.client_name
FROM works_with
JOIN client ON works_with.client_id = client.client_id
GROUP BY  works_with.client_id;

-- Review over -- 
-- ========================= TRIGGER ========================= --
-- Trigger is a block of SQL code that we can write which defines a certain action that should
-- happen when a certain operation gets performed on the database
-- Can write a Trigger that would tell SQL to do something for ex -> Entry added in particular database
-- or deleted, modified, ect.


CREATE TABLE trigger_test (
    message VARCHAR(100)
);

-- Triggers must be created on MySQL Command Line
-- Written here for text/note purposes to know what 
-- was executed

-- Before we insert into employee, for each (new) row inserted
-- insert into trigger test the following prompt
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;

-- Note on DELIMITER - Needed as by standard, we end SQL commands
-- with a ';'. However, since we need that character for line 475
-- where we are executing that particular query command (which
-- needs a ';'), We cannot use that same character to end off the
-- entire code of the SQL trigger. Thus, having a delimiter can
-- help SQL understand what will be the delimiter for our case
-- (we set the delimiter here as $$)
-- In PopSQL, can't change the delimiter -> have to do it in
-- MySQL Command Line
-- > DELIMITER $$
-- Then rest ...
-- > DELIMITER ;

INSERT INTO employee VALUES (109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT * 
FROM trigger_test

-- NEW allows us to access a particular attribute about the thing that we just inserted
-- NEW refers to the row that's going to get inserted and now I can access specific columns from that row
-- Here we are using NEW to get the first name of the row that was just inserted
DELIMITER $$
CREATE
    TRIGGER my_trigger1 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;


INSERT INTO employee VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

SELECT * 
FROM trigger_test;

DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES('added male employee');
        ELSEIF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES('added female employee');
        ELSE
            INSERT INTO trigger_test VALUES('added another employee');
        END IF;
    END$$
DELIMITER ;
    
INSERT INTO employee VALUES(111, 'Pamela', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

SELECT *
FROM trigger_test;


-- CAN drop trigger like this -> in the MySQL command client
DROP TRIGGER my_trigger;

-- For schemas, for single line connecting multiple entities (connected by a diamond indicating the action between both like take [student takes class
-- class takes students]) a class does not have to be taken by all students (partial participation which is indicated by a single line ----- ), but for a class
-- at least 1 student needs to take the class (total participation -> double line ====== )
-- that diamond could have a grade connected by the taken diamond, the attribute is not directly linked to the student nor class, but on the taken diamond connecting
-- both entities
-- 1:1 ( class can only have 1 student | student can take 1 class)
-- 1:N ( class can only have 1 student | student can take N classes)
-- N:M ( class taken by N students     | stduents can take M classes)
