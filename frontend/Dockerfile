# ------------------- Stage 1: Build Stage ------------------------------
FROM node:21 AS frontend-builder

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# tests
# RUN npm run test

# ------------------- Stage 2: Final Stage ------------------------------
FROM node:21-slim

# Set the working directory to /app
WORKDIR /app

# Copy built assets and dependencies from frontend-builder stage
COPY --from=frontend-builder /app .

# Copy the .env.sample file to .env.local
# Note: .env.docker is already copied from the builder stage (line 23)
# and won't be available in CI/CD since it's gitignored
# COPY .env.docker .env.local
# COPY . .

# Expose port 5173 for the Node.js application
EXPOSE 5173

# Define the default command to run the application in development mode
CMD ["npm", "run", "dev", "--", "--host"]
