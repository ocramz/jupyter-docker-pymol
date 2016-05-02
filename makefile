ACCOUNT = "ocramz"

.DEFAULT_GOAL := help

help:
	@echo "Use \`make <target>' where <target> is one of"
	@echo "  help     to display this help message"
	@echo "  build    to build the docker image"
	@echo "  login    to login to your docker account"
	@echo "  push     to push the image to the docker registry"

pull:
	docker pull ${ACCOUNT}/jupyter-docker-pymol


build:
	docker build -t $(ACCOUNT)/jupyter-docker-pymol .

nb:
	docker run --rm -it -p 8888:8888 ocramz/jupyter-docker-pymol 


login:
	docker login -u $(ACCOUNT)

push: image login
	docker push $(ACCOUNT)/jupyter-docker-pymol


ready:
	make pull
	make nb
