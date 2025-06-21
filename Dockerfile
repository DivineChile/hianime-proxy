# Stage 1: Build the TypeScript code
FROM node:20

# Set working directory
WORKDIR /app

# Copy dependency definitions
COPY package*.json ./

# Install all dependencies (including devDeps like TypeScript)
RUN npm install

# Copy the rest of the project
COPY . .

# Compile TypeScript to JavaScript
RUN npm run build

# Stage 2: Production container
FROM node:20

WORKDIR /app

# Copy only the build output and necessary files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Expose app port
EXPOSE 3000

# ✅ Run compiled JS entry point
CMD ["node", "dist/src/index.js"]