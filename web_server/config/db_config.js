const { Pool } = require('pg');

const connection = new Pool({
  connectionString: "postgres://idggzaqz:8_psvBJRa2sZrqkLawGdsRz6yVjEZLFN@salt.db.elephantsql.com:5432/idggzaqz",
  idleTimeoutMillis: 30000,
})

module.exports = connection;