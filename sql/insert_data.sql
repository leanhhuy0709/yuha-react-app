--Just create 1 employee

--Emp 
---Type ID
--100 Employee
--101 Member
--102 Account
--103 Project
--104 Activity
--0 Group
insert into Employee 
	values (100001, '072202001000', 101001, 'Emma', null, 'Watson', 'Paris', '19900415', 12000);
insert into Analyst 
	values (100001);
insert into Member 
	values (101001);
insert into Account
	values (102001, 'emma123', 'emma123', 100001);
insert into Project
	values (103001, 'Car_00', null, 7000, 5000);
insert into Employee_lead_Project
	values (103001, 100001);
insert into Activity
	values (104001);
insert into Member_in_Activity
	values (101001, 104001);
insert into Member_in_Activity_role
	values (101001, 104001, 'Leader');
insert into Group1
	values (103001, 0, 'Paris');
insert into Task
	values (103001, 0, 0);
insert into Activity_with_Group1
	values (104001, 103001, 0, '20221117', 2);
--------To be continue

insert into Employee 
	values (100002, '072202001001', 101002, 'Tony', null, 'Stark', 'London', '19700529', 20000);
insert into Designer 
	values (100002);
insert into Member 
	values (101002);
insert into Account
	values (102002, 'tony0529', 'tony0529', 100002);
insert into Employee_joins_Group1
	values (100002, 103001, 0);
insert into Employee_joins_Group1_period
	values (100002, 103001, 0, 50);
insert into Member_in_Activity
	values (101002, 104001);
insert into Member_in_Activity_role
	values (101002, 104001, 'Designer');


insert into Member 
	values (101003);
insert into Employee 
	values (100003, '072202001002', 101003, 'Huy', 'Anh', 'Lê', 'Tây Ninh', '20020907', 2000);
insert into Account
	values (102003, 'ahuy', 'ahuy', 100003);
---------------------
insert into Project
	values (103002, 'Car_01', 'Test description', 7600, 4000);
insert into Manager
	values (100003);
insert into Employee_lead_Project
	values (103002, 100003);

------------
insert into Group1
	values (103001, 1, 'London');

insert into Group1
	values (103002, 0, 'Tây Ninh');

insert into Group1
	values (103002, 1, 'Bangkok');

insert into Activity
	values (104002);
insert into Activity_with_Group1
	values (104002, 103001, 1, '20221129', 12);

--take account
select bioid, employee.id, ssn, fname, mname, lname, bdate, address, salary 
from Employee join Account on Employee.ID = Account.ID;


select Project.PID, Activity.AID, Group1.GNumber, Date, Hour, MID from (((Activity join Activity_with_Group1 on Activity.AID = Activity_with_Group1.AID) 
	join Group1 on Activity_with_Group1.PID = Group1.PID) join Project on Group1.PID = Project.PID) join Member_in_Activity on Activity.AID = Member_in_Activity.AID
	where Group1.GNumber = Activity_with_Group1.GNumber;

select activity.aid, Project.name, Group1.gnumber, date, hour from ((Activity join Activity_with_Group1 on Activity.AID = Activity_with_Group1.AID)
join Group1 on Activity_with_Group1.PID = Group1.PID)
join Project on Project.PID = Group1.PID
where Activity_with_Group1.GNumber = Group1.GNumber;

select fname, mname, lname, project.pid, Project.name, project.description, project.cost, project.cost_efficiency from (Employee join Employee_lead_Project on Employee.ID = Employee_lead_Project.ID) join Project 
	on Employee_lead_Project.PID = Project.PID;

select * from (Employee join Employee_joins_Group1 on Employee.ID = Employee_joins_Group1.ID) join Group1 
	on Employee_joins_Group1.GNumber = Group1.GNumber
where Employee_joins_Group1.PID = Group1.PID;

select Employee.id, ssn, mid, fname, mname, lname, address, bdate, salary, 
Analyst.ID as analyst, Manager.ID as manager, Worker.ID as worker, Designer.ID as designer, username
from ((((Employee left join Analyst on Employee.ID = Analyst.ID)
left join Manager on Employee.ID = Manager.ID)
left join Worker on Employee.ID = Worker.ID)
left join Designer on Employee.ID = Designer.ID)
join Account on Employee.ID = Account.ID;

select * from Project join Employee_lead_Project on Project.PID = Employee_lead_Project.PID;

IF (0 in (select Group1.GNumber from Group1) and (103001 in (select Group1.PID from Group1))) 
BEGIN select * from Activity;select * from Activity;select * from Activity; END

DELETE FROM Activity_with_Group1 WHERE AID = 123;
DELETE FROM Activity WHERE AID = 123;

select * from Activity;

IF (0 in (select Group1.GNumber from Group1) and (1 in (select Group1.PID from Group1))) BEGIN insert into Activity values (2);insert into Activity_with_Group1 values (3, 4, 5, '6', 7); END