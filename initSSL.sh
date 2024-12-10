#!/bin/bash

# Define the directory where SSL certificates will be stored
SSL_DIR="./ssl"
COUNTRY="US"
STATE="California"
LOCALITY="San Francisco"
ORGANIZATION="My Organization"
ORGANIZATIONAL_UNIT="IT Department"
COMMON_NAME="phpformchallenge"
EMAIL="admin@phpformchallenge.com"

# Check if the directory exists; if not, create it
if [ ! -d "$SSL_DIR" ]; then
  echo "Creating SSL directory: $SSL_DIR"
  mkdir -p "$SSL_DIR"
fi

# Define the certificate and key file paths
CRT_FILE="$SSL_DIR/server.crt"
KEY_FILE="$SSL_DIR/server.key"

# Check if the SSL certificate and key already exist
if [ -f "$CRT_FILE" ] && [ -f "$KEY_FILE" ]; then
  echo "SSL certificate and key already exist. Skipping generation."
else
  # Generate the self-signed SSL certificate and key
  echo "Generating self-signed SSL certificate..."
  openssl req -new -newkey rsa:2048 -days 365 -nodes -keyout "$KEY_FILE" -out "$SSL_DIR/server.csr" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"

  # Generate the self-signed certificate
  openssl x509 -req -days 365 -in "$SSL_DIR/server.csr" -signkey "$KEY_FILE" -out "$CRT_FILE"

  # Remove the CSR file after certificate generation
  rm -f "$SSL_DIR/server.csr"

  # Check if the certificate generation was successful
  if [ $? -eq 0 ]; then
    echo "SSL certificate and key generated successfully."
  else
    echo "Error generating SSL certificate and key."
    exit 1
  fi
fi

# Build the Docker container
echo "Building Docker container..."
docker-compose build
if [ $? -ne 0 ]; then
  echo "Error building Docker container."
  exit 1
fi

# Start up the container (detached mode)
echo "Starting up the Docker container..."
docker-compose up -d
docker-compose ps

# Wait for the container to be healthy (maximum of 10 attempts)
attempt=0
max_attempts=10
echo "Waiting for the container to be healthy (attempts will be max $max_attempts)..."
while [ $attempt -lt $max_attempts ]; do
  container_health=$(docker inspect --format '{{.State.Health.Status}}' phpformchallenge 2>/dev/null)
  
  if [ -n "$container_health" ]; then
    if [ "$container_health" == "healthy" ]; then
      echo "[+] Container phpformchallenge is healthy."
      break
    fi
  else
    echo "Health check not available for phpformchallenge, assuming container is up."
    break
  fi

  attempt=$((attempt+1))
  echo "Attempt $attempt: Container is not healthy yet. Retrying in 5 seconds..."
  sleep 5
done

# If the container is still not healthy after max attempts, exit with an error
if [ $attempt -ge $max_attempts ]; then
  echo "Error: Container did not become healthy within $max_attempts attempts."
  exit 1
fi


# Copy the SSL certificate and key into the container
echo "Copying SSL certificate and key into the container..."
docker cp "$CRT_FILE" phpformchallenge:/etc/ssl/certs/server.crt
docker cp "$KEY_FILE" phpformchallenge:/etc/ssl/private/server.key

# Ensure the SSL certificate and key were copied successfully
if [ $? -ne 0 ]; then
  echo "Error copying SSL certificate and key into the container."
  exit 1
fi

# Restart Apache in the container (with SSL enabled)
echo "Restarting Apache inside the container..."
docker exec -it phpformchallenge apache2ctl restart

# Check Apache
