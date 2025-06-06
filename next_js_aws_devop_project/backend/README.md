# Setup

- pull the latest code from github

- then install nodejs and the npm package manager

- run npm install to install all packages\

```
npm install
```

- To setup the application copy the content from .env.example to .env

- make sure you also have docker installed on your machine

- now run

```
~$: docker compose up
```

- now open another terminal and run the below commad to apply migrations

```
npx prisma migrate dev
```

- finally run the command to start the server locally

```
npm run dev
```

# Structure

This project currently use the layered architecture aproach...

the services handle core busincess logic and interact with the database model

the controllers are responsible to create meaninful json response

all routes are available in the routes folder

and server.ts is the main file from where the server is spawned
