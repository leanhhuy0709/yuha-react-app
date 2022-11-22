
const express = require("express");
var bodyParser = require('body-parser');
const PORT = process.env.PORT || 3001;
const app = express();
const {conn, sql} = require('./connect_sql')
app.use(bodyParser.urlencoded({
    extended:true
}));
//---------------------------------------------------------------
app.get("/", (req, res) => {
    //res.json({ message: "Hello Yuha from server!" });
    res.send(`Welcome to server`);
});

app.get("/user", async (req, res) => {
    var pool = await conn;
    var sqlString = "select bioid, Employee.id, ssn, mid, fname, mname, lname, address, bdate, salary, Analyst.ID as analyst, Manager.ID as manager, Worker.ID as worker, Designer.ID as designer, username from ((((Employee left join Analyst on Employee.ID = Analyst.ID) left join Manager on Employee.ID = Manager.ID) left join Worker on Employee.ID = Worker.ID) left join Designer on Employee.ID = Designer.ID) join Account on Employee.ID = Account.ID;";
    await pool.request().query(sqlString, function(err, data){
        if(err) console.log(err);
        res.json(data.recordset);
    });
});

app.get("/project", async (req, res) => {
  var pool = await conn;
  var sqlString = "select fname, mname, lname, Employee.id, project.pid, project.name, project.description, project.cost, project.cost_efficiency from (Employee join Employee_lead_Project on Employee.ID = Employee_lead_Project.ID) join Project on Employee_lead_Project.PID = Project.PID;";
  await pool.request().query(sqlString, function(err, data){
      if(err) console.log(err);
      res.json(data.recordset);
  });
});

app.get("/group", async (req, res) => {
  var pool = await conn;
  var sqlString = "select * from Group1";
  await pool.request().query(sqlString, function(err, data){
      if(err) console.log(err);
      res.json(data.recordset);
  });
});

app.get("/activity", async (req, res) => {
  var pool = await conn;
  var sqlString = "select activity.aid, Project.name, project.pid, Group1.gnumber, date, hour from ((Activity join Activity_with_Group1 on Activity.AID = Activity_with_Group1.AID) join Group1 on Activity_with_Group1.PID = Group1.PID) join Project on Project.PID = Group1.PID where Activity_with_Group1.GNumber = Group1.GNumber;";
  await pool.request().query(sqlString, function(err, data){
      if(err) console.log(err);
      res.json(data.recordset);
  });
});

app.post('/login', async function(req, res) {
    console.log(req.body);
    var usr = req.body.usr;
    var psw = req.body.psw;
  //---------call sql
    var pool = await conn;
    var sqlString = "select * from account;";
    return await pool.request().query(sqlString, function(err, data){
        if(err) console.log(err);
        let result = data.recordset.find((e) => e.username === usr && e.password === psw);
        console.log(result);
        if (result !== undefined)
          //res.send({message: result.BioID});
        { 
          res.redirect('/');
        }
        else
          res.json({msg: "Gei"})

    });
});

app.post('/project', async function(req, res) {
  console.log(req.body);
  //---------call sql
  //insert into Project	values (103002, 'Car_01', 'Test description', 7600, 4000);
  //username -> id
  var pool = await conn;
  var sqlString = `insert into Project values (${Number(req.body.project_pid)}, ${'\'' + String(req.body.project_name) + '\'' }, ${'\'' + String(req.body.project_description) + '\'' }, ${Number(req.body.project_cost)}, ${Number(req.body.project_cost_efficiency)});`;
  sqlString += `insert into Employee_lead_Project values (${Number(req.body.project_pid)}, ${req.body.employee_id});`
  console.log(sqlString);
  return await pool.request().query(sqlString, function(err, data){
      if(err) res.send(err);
      res.redirect('/project');
  });
});

app.post('/activity', async function(req, res) {
  console.log(req.body);
  //---------call sql
  /*insert into Activity
	values (104002);
  insert into Activity_with_Group1
	values (104002, 103001, 1, '20221129', 12); */
  var pool = await conn;
  var sqlString = `IF (${Number(req.body.activity_group_number)} in (select Group1.GNumber from Group1) and (${Number(req.body.activity_pid)} in (select Group1.PID from Group1))) BEGIN insert into Activity values (${Number(req.body.activity_aid)});insert into Activity_with_Group1 values (${Number(req.body.activity_aid)}, ${Number(req.body.activity_pid)}, ${Number(req.body.activity_group_number)}, ${'\'' + String(req.body.activity_date) + '\''}, ${Number(req.body.activity_hour)}); END`;
  console.log(sqlString);
  return await pool.request().query(sqlString, function(err, data){
      if(err) res.send(err);
      res.redirect('/activity');
  });
});


app.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}/`);
});

