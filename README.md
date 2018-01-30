**Docker image sources for setting up the mongo-bi-connector in a container**

# Usage

```docker build -t mongo-bi-connector```

```docker run -p 9015:3307 -d mongo-bi-connector -e DB_NAME=your_mongo_db -e MONGO_HOST=your_mongo_host -e MONGO_PORT=your_mongo_port```

where 8080 is your local machine port

# Is it working?

To check if it's properly working install a mysql client and test the following command :

```mysql --protocol tcp --port 9015 --verbose```

If you have the MySQL welcome message, it is working, you can check your tables with
```use <whatever_your_db>; show tables;```

# Authentication

This image also handles authentication enabled databases
just add the following env variables:

+ MONGO_USERNAME
+ MONGO_PASSWORD
+ MONGO_AUTH_DB
+ SSL_STRING

SSL string will be the subj option to the openssl auto-signed certificate creation that is needed to run sqld in auth mode...

# Docker compose
I added a docker compose exemple as an exemple that links the bi-connector container to a mongo container.

# License

Keep in mind that this include licensed content and requires a Mongodb entreprise license.

# FAQ

**Sometimes the connector connects before my mongo db is loaded thus failing.**

That's why I included the wait-for-it.sh script that will allow you to check if the host and port is available before initializing the connection.
To use it you need to override the  default command

Example with docker compose:

```command: ["wait-for-it.sh", "-t", "0", "my-mongo-db:27017", "--","run.sh","-vv"] ```
