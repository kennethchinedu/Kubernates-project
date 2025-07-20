
FROM node:18-alpine

WORKDIR /usr/src/frontend

COPY package*.json .

RUN npm install

COPY . .


# RUN npm run build
# RUN npm audit fix --force


EXPOSE 5173

# Run the frontend
CMD ["npm", "run", "dev"]


########################################

# FROM node:18-alpine

# # Set working directory
# WORKDIR /usr/src/frontend

# # Install deps and build app
# COPY package*.json ./
# RUN npm install

# COPY . .
# RUN npm run build

# # Install serve globally to serve the built site
# RUN npm install -g serve

# # Expose port (same as what 'serve' will use)
# EXPOSE 5173

# # Run static server to serve dist folder
# CMD ["serve", "-s", "dist", "-l", "5173"]

#################################

# FROM node:18-alpine

# # Set working directory
# WORKDIR /usr/src/frontend

# # Accept build-time environment variable
# ARG VITE_APP_BACKEND_BASE_URL
# ENV VITE_APP_BACKEND_BASE_URL=$VITE_APP_BACKEND_BASE_URL

# # Install deps and build app
# COPY package*.json ./
# RUN npm install

# COPY . .

# # Build with env embedded
# RUN npm run build

# # Install serve globally to serve the built site
# RUN npm install -g serve
# EXPOSE 5173


# CMD ["serve", "-s", "dist", "-l", "5173"]
