CREATE TABLE Member
(
	MID Int Primary Key
);

CREATE TABLE Employee
(	
	ID Int Primary Key,
	SSN Varchar(50) not null,
	MID Int not null,
	Constraint Employee_Member Foreign Key (MID) REFERENCES Member(MID),
	FName Varchar(20),
	MName Varchar(20),
	LName Varchar(20),
	Address Varchar(20),
	BDate Date,
	Salary Decimal(10, 2)	
);
CREATE TABLE Account
(	
	BioID Int Primary Key,
	username Varchar(20) not null,
	password Varchar(20) not null,	
	ID Int not null,
	Constraint Account_Employee Foreign Key (ID) REFERENCES Employee(ID) 
);
CREATE TABLE Analyst
(
	ID Int Primary Key
);
CREATE TABLE Manager
(
	ID Int Primary Key
);
CREATE TABLE Worker
(
	ID Int Primary Key
);
CREATE TABLE Designer
(
	ID Int Primary Key
);
CREATE TABLE Supplier
(
	SID Int Primary Key,
	Location Varchar(20),
	MID Int not null,
	Constraint Supplier_Member Foreign Key (MID) REFERENCES Member(MID)
);
CREATE TABLE Notification
(
	NID Int Primary Key
);
CREATE TABLE Comment
(
	NID Int not null,
	Comment Varchar(100) not null,
	Constraint Comment_Notification Foreign Key (NID) REFERENCES Notification(NID),
	Constraint Comment_Key Primary Key (NID, Comment)
);
CREATE TABLE Equipment
(
	PID Int Primary Key
);
CREATE TABLE Manager_manages_Equipment
(
	PID Int Primary Key,
	ID Int not null,
	Constraint Manager_manages_Equipment_Equipment Foreign Key (PID) REFERENCES Equipment(PID),
	Constraint Manager_manages_Equipment_Key Foreign Key (ID) REFERENCES Manager(ID)
);

CREATE TABLE Worker_works_on_Equipment
(
	PID Int Primary Key,
	ID Int not null,
	Constraint Worker_works_on_Equipment_Equipment Foreign Key (PID) REFERENCES Equipment(PID),
	Constraint Worker_works_on_Equipment_Worker Foreign Key (ID) REFERENCES Worker(ID)
);
CREATE TABLE Manager_manages_Equipment_session
(
	PID Int not null,
	Session Varchar(100) not null,
	Constraint Manager_manages_Equipment_session_Manager_manages_Equipment 
			Foreign Key (PID) REFERENCES Manager_manages_Equipment(PID),
	Constraint Manager_manages_Equipment_session_Key Primary Key (PID, Session)
);
CREATE TABLE Worker_works_on_Equipment_session
(
	PID Int not null,
	Session Varchar(100) not null,
	Constraint Worker_works_on_Equipment_session_Worker_works_on_Equipment
		Foreign Key (PID) REFERENCES Worker_works_on_Equipment(PID),
	Constraint Worker_works_on_Equipment_session_Key Primary Key (PID, Session)
);
CREATE TABLE Notification_for_Equipment
(
	NID Int Primary Key,
	PID Int not null,
	Date Date,
	Hour Int,
	Constraint Notification_for_Equipment_Equipment Foreign Key (PID) REFERENCES Equipment(PID)
);
CREATE TABLE Part
(
	PID Int Primary Key
);
CREATE TABLE Activity
(
	AID Int Primary Key
);
CREATE TABLE Member_in_Activity
(
	MID Int not null,
	Constraint Member_in_Activity_Member Foreign Key (MID) REFERENCES Member(MID),
	AID Int not null,
	Constraint Member_in_Activity_Activity Foreign Key (AID) REFERENCES Activity(AID),
	Constraint Member_in_Activity_Key Primary Key (MID, AID)
);
CREATE TABLE Member_in_Activity_role
(
	MID Int not null,
	AID Int not null,
	Constraint Member_in_Activity_role_Member_in_Activity
		Foreign Key (MID, AID) REFERENCES Member_in_Activity(MID, AID),
	Role Varchar(100),
	Constraint Member_in_Activity_role_Key Primary Key (MID, AID, Role)
);
CREATE TABLE Project
(
	PID Int Primary Key,
	Name Varchar(50) not null,
	Description Varchar(1000),
	Cost Decimal(10, 2),
	Cost_Efficiency Decimal(10,2)
)

CREATE TABLE Product
(
	PID Int Primary Key
);
CREATE TABLE Product_for_Project
(
	Project_PID Int not null,
	Constraint Product_for_Project_Project Foreign Key (Project_PID) REFERENCES Project(PID),
	Product_PID Int not null,-------ec ec stop here to check
	Constraint Product_for_Project_Product Foreign Key (Product_PID) REFERENCES Product(PID),
	Constraint Product_for_Project_Key Primary Key (Project_PID, Product_PID)
);
CREATE TABLE Model
(
	ID Int not null,
	Constraint Model_Designer Foreign Key (ID) REFERENCES Designer(ID),
	PID Int not null,
	Constraint Model_Product Foreign Key (PID) REFERENCES Product(PID),
	MNumber Int not null,
	DateCreated DATE,
	Constraint Model_Key Primary Key (ID, PID, MNumber)
);
CREATE TABLE Model_in_Project
(
	ID Int not null,
	Product_PID Int not null,	
	MNumber Int not null,
	Constraint Model_in_Project_Model Foreign Key (ID, Product_PID, MNumber) REFERENCES Model(ID, PID, MNumber),
	Project_PID Int not null,
	Constraint Model_in_Project_Project Foreign Key (Project_PID) REFERENCES Project(PID),
	Constraint Model_in_Project_Key Primary Key (ID, Product_PID, MNumber)
);
CREATE TABLE Process
(
	PID Int Primary Key
);
CREATE TABLE Equipment_Process_produces_Product
(
	Equipment_PID Int not null,
	Constraint Equipment_Process_produces_Product_Equipment 
		Foreign Key (Equipment_PID) REFERENCES Equipment(PID),
	Process_PID Int not null,
	Constraint Equipment_Process_produces_Product_Process Foreign Key (Process_PID) REFERENCES Process(PID),
	Product_PID Int not null,
	Constraint Equipment_Process_produces_Product_Product Foreign Key (Product_PID) REFERENCES Product(PID),
	Status Int, --Bool ko duoc nen xai Int tam
	Date DATE,
	Hour Int,
	Constraint Equipment_Process_produces_Product_Key Primary Key (Equipment_PID, Process_PID, Product_PID)
);
CREATE TABLE Equipment_Process_produces_Product_log
(
	Equipment_PID Int not null,
	Process_PID Int not null,
	Product_PID Int not null,
	Constraint Equipment_Process_produces_Product_log_Equipment_Process_produces_Product 
		Foreign Key (Equipment_PID, Process_PID, Product_PID) REFERENCES Equipment_Process_produces_Product(Equipment_PID, Process_PID, Product_PID),
	Log Varchar(1000),
	Constraint Equipment_Process_produces_Product_log__Key 
		Primary Key (Equipment_PID, Process_PID, Product_PID, Log)
);----------------------------------
CREATE TABLE Group1
(
	PID Int not null,
	Constraint Group1_Project Foreign Key (PID) REFERENCES Project(PID),
	GNumber Int not null,
	Location Varchar(50),
	Constraint Group1_Key Primary Key (PID, GNumber)
);
CREATE TABLE Task
(
	PID Int not null,
	GNumber Int not null,
	TNumber Int not null,
	Constraint Task_Group1 Foreign Key (PID, GNumber) REFERENCES Group1(PID, GNumber),
	Constraint Task_Key Primary Key (PID, GNumber, TNumber)
);
CREATE TABLE Supplier_supplies_Part_for_Project
(
	SID Int not null,
	Constraint Supplier_supplies_Part_for_Project_Supplier 
		Foreign Key (SID) REFERENCES Supplier(SID),
	Part_PID Int not null,
	Constraint Supplier_supplies_Part_for_Project_Part 
		Foreign Key (Part_PID) REFERENCES Part(PID),
	Project_PID Int not null,
	Constraint Supplier_supplies_Part_for_Project_Project 
		Foreign Key (Project_PID) REFERENCES Project(PID),
	Date DATE,
	Quantity Int,
	Price Decimal(10, 2),
	Constraint Supplier_supplies_Part_for_Project_Key
		Primary Key (SID, Part_PID, Project_PID)
);
CREATE TABLE Activity_with_Group1
(
	AID Int not null,
	Constraint Activity_with_Group1_Activity Foreign Key (AID) REFERENCES Activity(AID),
	PID Int not null,
	GNumber Int not null,
	Constraint Activity_with_Group1_Group1 
		Foreign Key (PID, GNumber) REFERENCES Group1(PID, GNumber),
	Date DATE,
	Hour Int,
	Constraint Activity_with_Group1_Key Primary Key (AID, PID, GNumber)
);
CREATE TABLE Employee_joins_Group1
(
	ID Int not null,
	PID Int not null,
	GNumber Int not null,
	Constraint Employee_joins_Group1_Group1 
		Foreign Key (PID, GNumber) REFERENCES Group1(PID, GNumber),
	Constraint Employee_joins_Group1_Key Primary Key (ID, PID, GNumber)
);
CREATE TABLE Employee_joins_Group1_period
(
	ID Int not null,
	PID Int not null,
	GNumber Int not null,
	Constraint Employee_joins_Group1_period_Employee_joins_Group1
		Foreign Key (ID, PID, GNumber) REFERENCES Employee_joins_Group1(ID, PID, GNumber),
	Period Int,
	Constraint Employee_joins_Group1_period_Key Primary Key (ID, PID, GNumber, Period)
);
CREATE TABLE Employee_lead_Project
(
	PID Int Primary Key,
	Constraint Employee_lead_Project_Project 
		Foreign Key (PID) REFERENCES Project(PID),
	ID Int not null,
	Constraint Employee_lead_Project_Employee
		Foreign Key (ID) REFERENCES Employee(ID)
);



--Test code
select * from Account;

