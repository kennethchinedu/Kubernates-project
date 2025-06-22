IMAGE_REG ?= docker.io
IMAGE_DIRECTORY ?= anamskenneth
FRONTEND_IMAGE := recipe_frontend
BACKEND_IMAGE := recipe_backend
IMAGE_TAG ?=$(shell date +%Y-%m-%d)

#Handing image building and pushing to docker registry

docker_check:
	if ! command -v docker &> /dev/null; then \
		echo "Docker is not installed. Please install Docker first."; \ 
		sudo apt-get install -y docker.io; \
		echo "Docker installed successfully."; \
		exit 1; \
	fi
build_backend_image:
	docker build --no-cache -t $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE)  next_js_aws_devop_project/backend/.


build_frontend_image:
	docker build --no-cache -t $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE)  next_js_aws_devop_project/frontend/.

docker_login:
	echo $${{ secrets.DOCKER_TOKEN }} | docker login -u $${{ secrets.DOCKER_USERNAME }} --password-stdin; \
	echo "Docker login successful";

ps: 
	docker images; 
	docker ps -a;

docker_push: 
	
	docker tag $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE) $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$(IMAGE_TAG)  && \
	docker push $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$(IMAGE_TAG) && \
	docker tag $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE) $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$(IMAGE_TAG) && \
	docker push $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$(IMAGE_TAG) 

#scanning images for vulnerabilities
scan_backend_image:
	trivy image --severity HIGH,CRITICAL $(IMAGE_DIRECTORY)/$(BACKEND_IMAGE):$(IMAGE_TAG)

scan_frontend_image:
	trivy image --severity HIGH,CRITICAL $(IMAGE_DIRECTORY)/$(FRONTEND_IMAGE):$(IMAGE_TAG)