# Use an official Node.js runtime as the base image
#FROM node:20

# Set the working directory
#WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
#COPY package*.json ./

# Install dependencies
#RUN npm install

# Copy the rest of the application files
#COPY . .

# Expose port 3000
#EXPOSE 3000

# Start the application
#CMD ["npm", "start"]


ARG BASE_IMAGE=957779811736.dkr.ecr.ap-south-1.amazonaws.com/node:latest
FROM ${BASE_IMAGE} As build

LABEL Fronted-Food="1.0.0.0" \
      contact="Chandan" \
      description="A minimal Node.js Docker image for Brand-pts application in Staging" \
      base.image="Node" \
      maintainer="Test@gmail.com"

ENV TZ=Asia/Kolkata

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app
ADD . /app


# Install dependencies again
 # Install dependencies (this is where npm install will happen)
RUN npm install

# Build the app
#RUN npm run build

# Final stage
FROM 957779811736.dkr.ecr.ap-south-1.amazonaws.com/node:latest
WORKDIR /app
COPY --from=build /app .

# Set a non-root user
USER node

EXPOSE 3000

# Health check
#HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
 # CMD curl --fail http://staging.marketplace.envr.earth/health || exit 1

# Start the app
CMD ["npm", "run", "start"]
