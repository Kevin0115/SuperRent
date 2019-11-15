const { Pool } = require('pg');

const connection = new Pool({
  connectionString: "postgres://mrzqbmvs:ram3ih28HLRulsb4zI9F9qGVHDfAMYxO@salt.db.elephantsql.com:5432/mrzqbmvs",
  idleTimeoutMillis: 30000,
})

module.exports = connection;