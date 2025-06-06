# Step 1: Use an official Node.js runtime as a base image
FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

COPY . .


RUN npm install 


# RUN npx prisma migrate dev 


EXPOSE 8080

# Step 7: Define the command to run the app
CMD ["npm", "run", "dev"]





