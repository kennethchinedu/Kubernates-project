# Used by `image`, `push` & `deploy` targets, override as required
IMAGE_REG ?= docker.io
IMAGE_DIRECTORY ?= anamskenneth
FRONTEND_IMAGE := next_js_aws_devop_project_frontend
BACKEND_IMAGE := next_js_aws_devop_project_backend



# Don't change
SRC_DIR := src

help:  # 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

docker_setup: 
	if ! command -v docker-compose &> /dev/null; then \
    	sudo apt-get install -y docker-compose; \
    fi 

docker_login: 
	echo $${{ secrets.DOCKER_PASSWORD }} | docker login -u $${{ secrets.DOCKER_USERNAME }} --password-stdin; \
	echo "Docker login successful";

image: #Build frontend and backend container images using docker-compose
	docker-compose -f docker-compose.yml build frontend backend

ps: #Build frontend and backend container images using docker-compose
	docker images

push: # Push frontend and backend container images to registry
	# Generate a timestamp for the image tag
	IMAGE_TAG=`date +%d-%m-%Y.%H%M` && \
	docker tag next_js_aws_devop_project_frontend $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$$IMAGE_TAG && \
	docker push $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$$IMAGE_TAG && \
	docker tag next_js_aws_devop_project_backend $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$$IMAGE_TAG && \
	docker push $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$$IMAGE_TAG


pull: # Push frontend and backend container images to registry
	# Generate a timestamp for the image tag
	docker pull $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$$IMAGE_TAG && \
	docker pull $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$$IMAGE_TAG

run:
	# docker run -d --name backend-app $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$$IMAGE_TAG \
	# docker run -d -p 5137:5137 --name frontend-app $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$$IMAGE_TAG
	
	docker run -d --name backend-app -p 8080:8080 $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$(IMAGE_TAG)
	# Start the frontend container
	docker run -d --name frontend-app -p 5173:5173 $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$(IMAGE_TAG)


up: ## ⬆️  Bring up the services locally with docker-compose
	docker-compose up -d

down: ## ⬇️  Stop the services and remove containers
	docker-compose down




# push:  ## 📤 Push container image to registry 
# 	docker push $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

# run: venv  ## 🏃 Run the server locally using Python & Flask
# 	. $(SRC_DIR)/.venv/bin/activate \
# 	&& python src/run.py

# deploy:  ## 🚀 Deploy to Azure Web App 
# 	az group create --resource-group $(AZURE_RES_GROUP) --location $(AZURE_REGION) -o table
# 	az deployment group create --template-file deploy/webapp.bicep \
# 		--resource-group $(AZURE_RES_GROUP) \
# 		--parameters webappName=$(AZURE_SITE_NAME) \
# 		--parameters webappImage=$(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) -o table 
# 	@echo "### 🚀 Web app deployed to https://$(AZURE_SITE_NAME).azurewebsites.net/"

# undeploy:  ## 💀 Remove from Azure 
# 	@echo "### WARNING! Going to delete $(AZURE_RES_GROUP) 😲"
# 	az group delete -n $(AZURE_RES_GROUP) -o table --no-wait

# test: venv  ## 🎯 Unit tests for Flask app
# 	. $(SRC_DIR)/.venv/bin/activate \
# 	&& pytest -v

# test-report: venv  ## 🎯 Unit tests for Flask app (with report output)
# 	. $(SRC_DIR)/.venv/bin/activate \
# 	&& pytest -v --junitxml=test-results.xml

# test-api: .EXPORT_ALL_VARIABLES  ## 🚦 Run integration API tests, server must be running 
# 	cd tests \
# 	&& npm install newman \
# 	&& ./node_modules/.bin/newman run ./postman_collection.json --env-var apphost=$(TEST_HOST)

# clean:  ## 🧹 Clean up project
# 	rm -rf $(SRC_DIR)/.venv
# 	rm -rf tests/node_modules
# 	rm -rf tests/package*
# 	rm -rf test-results.xml
# 	rm -rf $(SRC_DIR)/app/__pycache__
# 	rm -rf $(SRC_DIR)/app/tests/__pycache__
# 	rm -rf .pytest_cache
# 	rm -rf $(SRC_DIR)/.pytest_cache

# # ============================================================================

# venv: $(SRC_DIR)/.venv/touchfile

# $(SRC_DIR)/.venv/touchfile: $(SRC_DIR)/requirements.txt
# 	python3 -m venv $(SRC_DIR)/.venv
# 	. $(SRC_DIR)/.venv/bin/activate; pip install -Ur $(SRC_DIR)/requirements.txt
# 	touch $(SRC_DIR)/.venv/touchfile