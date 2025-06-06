#!/bin/bash


# Docker registry and image details
IMAGE_REG="docker.io"  # You can change this to another registry if needed
IMAGE_DIRECTORY="anamskenneth"
FRONTEND_IMAGE="next_js_aws_devop_project_frontend"
BACKEND_IMAGE="next_js_aws_devop_project_backend"

# Update package lists and install dependencies
echo "Updating package lists..."
sudo apt-get update -y

# Install Make if not installed
if ! command -v make &> /dev/null; then
    echo "Make not found. Installing Make..."
    sudo apt install make -y 
    echo "make installed successfully"
fi

# Install Docker and Docker Compose if not installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    sudo apt-get install -y docker.io
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo apt-get install -y docker-compose
fi



# Set environment variables (using values from the script or .env file)
echo "export DATABASE_URL=${DATABASE_URL}" >> ~/.bashrc
echo "export POSTGRES_DB=${POSTGRES_DB}" >> ~/.bashrc
echo "export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" >> ~/.bashrc
echo "export POSTGRES_PORT=${POSTGRES_PORT}" >> ~/.bashrc
echo "export POSTGRES_USER=${POSTGRES_USER}" >> ~/.bashrc
echo "export DOCKER_USERNAME=${DOCKER_USERNAME}" >> ~/.bashrc
echo "export DOCKER_PASSWORD=${DOCKER_PASSWORD}" >> ~/.bashrc

echo "Enviromental variables added successfully"

# Make sure Docker service is running
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker


#docker login
echo "Logging into Docker..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
    echo "Docker login failed. Exiting..."
    exit 1
fi
echo "Docker login successful."


# Function to check if a container is running and stop/remove it if necessary
check_container_status() {
    CONTAINER_NAME=$1
    if [ "$(sudo docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Container $CONTAINER_NAME is running. Stopping and removing it..."
        sudo docker stop $CONTAINER_NAME
        sudo docker rm $CONTAINER_NAME
        if [ $? -ne 0 ]; then
            echo "Failed to stop/remove container $CONTAINER_NAME. Exiting..."
            exit 1
        fi
        echo "Container $CONTAINER_NAME stopped and removed successfully."
    else
        echo "Container $CONTAINER_NAME is not running."
    fi
}


# Check if frontend container is running, stop/remove if necessary
check_container_status "$FRONTEND_IMAGE"

# Check if backend container is running, stop/remove if necessary
check_container_status "$BACKEND_IMAGE"


#pulling frontend image
echo "Pulling frontend Docker image..."
sudo docker pull "$IMAGE_REG/$IMAGE_DIRECTORY/$FRONTEND_IMAGE:latest"
if [ $? -ne 0 ]; then
    echo "Failed to pull frontend image. Exiting..."
    exit 1
fi
echo "Frontend Docker image pulled successfully."


# Pull the backend Docker image
echo "Pulling backend Docker image..."
sudo docker pull "$IMAGE_REG/$IMAGE_DIRECTORY/$BACKEND_IMAGE:latest"
if [ $? -ne 0 ]; then
    echo "Failed to pull backend image. Exiting..."
    exit 1
fi
echo "Backend Docker image pulled successfully."



# Run the frontend container
echo "Running the frontend container..."
sudo docker run -d -e VITE_APP_BACKEND_BASE_URL=http://18.205.7.77:8080 -p 80:5173 --name "$FRONTEND_IMAGE" "$IMAGE_REG/$IMAGE_DIRECTORY/$FRONTEND_IMAGE:latest"
if [ $? -ne 0 ]; then
    echo "Failed to run frontend container. Exiting..."
    exit 1
fi
echo "Frontend container is now running."

# Run the backend container
echo "Running the backend container..."
sudo docker run -d -e CLIENT_URL=http://18.205.7.77:5173 -p 8080:8080 --name "$BACKEND_IMAGE" "$IMAGE_REG/$IMAGE_DIRECTORY/$BACKEND_IMAGE:latest"
if [ $? -ne 0 ]; then
    echo "Failed to run backend container. Exiting..."
    exit 1
fi
echo "Backend container is now running."

echo "Setup complete."


