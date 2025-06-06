
FROM node:18-alpine

WORKDIR /usr/src/frontend

COPY package*.json .

COPY . .

RUN npm install
RUN npm audit fix --force


EXPOSE 5173

# Run the frontend
CMD ["npm", "run", "dev"]
