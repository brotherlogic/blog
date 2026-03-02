# Stage 1: Build the Hugo site
# We use a specific Hugo version to ensure consistent builds.
FROM klakegg/hugo:0.123.3-ext-alpine AS builder

# Set the working directory inside the container
WORKDIR /src

# Copy the local project files to the container
COPY . .

# Build the static site. The output will be in the /src/public directory.
RUN hugo


# Stage 2: Create the final, lightweight image with Nginx
FROM nginx:1.25-alpine

# Copy the built static files from the 'builder' stage to the Nginx web server directory
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80 to allow incoming traffic
EXPOSE 80

# Nginx will automatically start when the container runs
CMD ["nginx", "-g", "daemon off;"]
