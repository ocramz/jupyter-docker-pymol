ACCOUNT = ""

.DEFAULT_GOAL := help

help:
	@echo "Use \`make <target> [ACCOUNT=<accountname>]' where <accountname> is"
	@echo "your docker account name and <target> is one of"
	@echo "  help     to display this help message"
	@echo "  build    to build the docker image"
	@echo "  login    to login to your docker account"
	@echo "  push     to push the image to the docker registry"

build:
	docker build -t $(ACCOUNT)/jupyter-docker-pymol .

nb:
	docker run -p 8888:8888 -v `/bin/pwd`:/notebooks  -t ocramz/jupyter-docker-pymol

login:
	docker login -u $(ACCOUNT)

push: image login
	docker push $(ACCOUNT)/jupyter-docker-pymol
