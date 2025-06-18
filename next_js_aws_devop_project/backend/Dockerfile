# Step 1: Use an official Node.js runtime as a base image
FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install 

COPY . .


# RUN npm run build


RUN  npx prisma db push 


EXPOSE 8080

# Step 7: Define the command to run the app
CMD ["npm", "run", "dev"]





