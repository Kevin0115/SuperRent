# SuperRent
### CPSC 304 Project (Team 11)

## PostgreSQL Instructions
1. Go to `https://customer.elephantsql.com/`
2. Sign in with GitHub account
3. Make a free database instance
4. Make note of the `URL` - this will be used in the next section
5. Go to the **Browser** section of your DB instance
6. Run any SQL commands to create/populate tables

## Startup Instructions (Server)
1. Open up Git Bash in desired directory
2. Run `git clone https://github.com/Kevin0115/SuperRent.git`
3. Open up `SuperRent/config/db_config.js`, and replace the `connectionString` with your own.
4. Open up a Node terminal (or PowerShell, or UNIX Terminal)
5. Run `cd SuperRent/web_server`
6. Run `npm start`
7. Open `localhost:3000`
8. Play around with the website (and try out the existing endpoints, as defined in `SuperRent/routes/`


## Startup Instructions (Client)
1. Open up a Node terminal (or PowerShell, or UNIX Terminal)
2. Run `cd SuperRent/web_client`
3. Run `npm start`
7. Open `localhost:3000` *TODO: This port will clash with the server. Change one of them*