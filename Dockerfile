# Use the official Node.js image as the base image
FROM node:18-alpine AS base

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (common for both environments)
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Base Command (this will be overridden in specific stages)
CMD ["node", "index.js"]

# --- Development Stage ---
FROM base AS development

# Install development dependencies
RUN npm install

# Environment variables
ENV NODE_ENV=development

# Enable hot reloading (for example, if using nodemon)
CMD ["npm", "run", "start:dev"]

# --- Production Stage ---
FROM base AS production

# Reinstall only production dependencies
RUN npm ci --only=production

# Environment variables
ENV NODE_ENV=production

# Remove unnecessary files (optional)
RUN rm -rf /app/src/tests /app/.env /app/docker-compose.yml

# Run the application in production mode
CMD ["npm", "run", "start:prod"]
