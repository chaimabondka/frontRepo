# Use an official Node runtime as a parent image
FROM node:14 AS build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install project dependencies
RUN npm install

# Install Angular CLI locally
RUN npm install @angular/cli

# Copy the entire project
COPY . .

# Build the Angular application using the locally installed Angular CLI
RUN npx ng build --output-path=dist

# Use a lightweight web server to serve the Angular app
FROM nginx:alpine

# Copy the built Angular app from the build stage to the Nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
