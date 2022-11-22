var sql = require('mssql/msnodesqlv8')

var config = {
    server: "YUHA-PC\\BKDATABASE",
    user: "yuha",
    password: "123456789",
    database: "database_extra",
    driver: "msnodesqlv8"
};

const conn = new sql.ConnectionPool(config).connect().then(
    pool => {return pool;}
)

module.exports = 
{
    conn: conn,
    sql: sql
}

