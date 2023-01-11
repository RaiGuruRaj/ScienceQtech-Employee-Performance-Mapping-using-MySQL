use employee;
select * from data_science_team;
select * from emp_record_table;
select * from proj_table;

#Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and
#DEPARTMENT from the employee record table, and make a list of
#employees and details of their department.

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;

#Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER,
#DEPARTMENT, and EMP_RATING if the EMP_RATING is:
#• less than two

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING < 2;

#• greater than four

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING > 4;

#• between two and four

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING between 2 and 4;

#Write a query to concatenate the FIRST_NAME and the LAST_NAME of
#employees in the Finance department from the employee table and then
#give the resultant column alias as NAME.

select concat(first_name,last_name) Name, dept
from emp_record_table
where dept = 'Finance';

#Write a query to list only those employees who have someone
#reporting to them. Also, show the number of reporters (including the
#President).

select emp_id, role, emp_record_table.manager_id, No_of_reporters
from emp_record_table,
(select manager_id, count(*) No_of_reporters
from emp_record_table
group by manager_id) m
where emp_record_table.emp_id = m.manager_id;

#Write a query to list down all the employees from the healthcare and
#finance departments using union. Take data from the employee record
#table.

select emp_id, first_name, dept
from emp_record_table
where dept= 'healthcare'
union
select emp_id, first_name, dept
from emp_record_table
where dept= 'finance';

#Write a query to list down employee details such as EMP_ID,
#FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING
#grouped by dept. Also include the respective employee rating along
#with the max emp rating for the department.

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, e.dept, EMP_RATING, d.max_emp_rating
from emp_record_table e
join
(select DEPT, max(emp_rating) max_emp_rating
from emp_record_table
group by dept) d
on e.dept = d.dept;

#Write a query to calculate the minimum and the maximum salary of the
#employees in each role. Take data from the employee record table.

select role, min(salary), max(salary) from emp_record_table group by role;

#Write a query to assign ranks to each employee based on their
#experience. Take data from the employee record table.

select emp_id, first_name, role, exp, 
rank() over(order by exp desc) 'rank'
from emp_record_table;

#Write a query to create a view that displays employees in various
#countries whose salary is more than six thousand. Take data from the
#employee record table.

create view employees as
select first_name, country, salary
from emp_record_table
where salary > 6000;
select * from employees;

#Write a nested query to find employees with experience of more
#than ten years. Take data from the employee record table.

select first_name, last_name, exp
from emp_record_table
where exp in
(select exp
from emp_record_table
where exp > 10);

#Write a query to create a stored procedure to retrieve the details of
#the employees whose experience is more than three years. Take data
#from the employee record table.

delimiter $$
create procedure employees_exp_details()
begin
select *
from emp_record_table
where exp > 3;
end $$
call employees_exp_details();

#Write a query using stored functions in the project table to check
#whether the job profile assigned to each employee in the data science
#team matches the organization’s set standard.
#The standard is:
#For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
#For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
#For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
#For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST'

delimeter $$
create function employee_role(exp int)
returns varchar(40)
deterministic 
begin
declare employee_role varchar(40);
if exp> 12 and 16 then
set employee_role= 'Manager';
elseif exp> 10 and 12 then
set employee_role= 'Lead Data Scientist';
elseif exp> 5 and 10 then
set employee_role= 'Senior Data Scintist';
elseif exp> 2 and 5 then
set employee_role= 'Associate Data Scientist';
elseif exp<= 2 then
set employee_role= 'Junior Data Scientist';
end if;
return(employee_role);
end $$
select exp, employee_role(exp)
from data_science_team;

#Create an index to improve the cost and performance of the query to
#find the employee whose FIRST_NAME is ‘Eric’ in the employee table
#after checking the execution plan.

#create index idx_first_name
#on emp_record_table(first_name(20));
select *
from emp_record_table
where first_name = 'eric';

#Write a query to calculate the average salary distribution based on the
#continent and country. Take data from the employee record table.

select emp_id, first_name, last_name, country, continent,
avg(salary) over(partition by country) avg_sal_in_country,
avg(salary) over(partition by continent) avg_sal_in_continent,
count(*) over(partition by country) avg_sal_in_country,
count(*) over(partition by continent) avg_sal_in_continent
from emp_record_table;