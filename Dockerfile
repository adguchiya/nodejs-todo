# FROM node:12.2.0-alpine
# WORKDIR app
# COPY . .
# RUN npm install
# RUN npm run test
# EXPOSE 8001
# CMD ["node","app.js"]

# Use the official Node.js image as the base image
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY . .

# Install project dependencies
RUN npm install

# Copy the rest of the project files to the working directory
COPY . .

# Set the port number
ENV PORT=8001

# Expose the specified port
EXPOSE $PORT

# Start the application
CMD ["npm", "start"]
