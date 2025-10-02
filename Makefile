.PHONY: build manifest run debug push save clean clobber buildaltergo buildprovers

# REPO    = gitlab-research.centralesupelec.fr:4567/boulange/mydocker-images/
REPO    = fredblgr/
NAME    = docker-webtop-framac
TAG     = 2025
MAINTAG = 2025
# Can be overriden with "make ARCH=amd64" for instance
# ARCH   := $$(arch=$$(uname -m); if [ $$arch = "x86_64" ]; then echo amd64; elif [ $$arch = "aarch64" ]; then echo arm64; else echo $$arch; fi)
ARCH   := $(shell if [ `uname -m` = "x86_64" ]; then echo "amd64"; elif [ `uname -m` = "aarch64" ]; then echo "arm64"; else echo `uname -m`; fi)
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(MAINTAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
DOCKERFILE = Dockerfile
DOCKERFILEBASE = Dockerfile_base
DOCKERFILEISABELLE = Dockerfile_Isabelle
DOCKERFILEFRAMAC = Dockerfile_Frama-C
ARCHIMAGE := $(REPO)$(NAME):$(MAINTAG)-$(ARCH)
ARCHIMAGEBASE := $(REPO)docker-webtop-base:$(TAG)-$(ARCH)
ARCHIMAGEISABELLE := $(REPO)docker-webtop-isabelle:$(TAG)-$(ARCH)
ARCHIMAGEFRAMAC := $(REPO)docker-webtop-framac:$(TAG)-$(ARCH)

help:
	@echo "# Available targets:"
	@echo "#   - build: build docker image"
	@echo "#   - clean: clean docker build cache"
	@echo "#   - run: run docker container"
	@echo "#   - push: push docker image to docker hub"

# Build image
build:
	@echo "Building $(ARCHIMAGE) for $(ARCH) from $(DOCKERFILE)"
	@if [ `docker images $(ARCHIMAGEBASE) | wc -l` -lt 2 ] ; then \
		echo "*****************************************" ; \
		echo "* You should 'make build_base' first *" ; \
		echo "*****************************************" ; \
	fi
	@if [ `docker images $(ARCHIMAGEISABELLE) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_isabelle' first *" ; \
		echo "******************************************" ; \
	fi
	@if [ `docker images $(ARCHIMAGEFRAMAC) | wc -l` -lt 2 ] ; then \
		echo "******************************************" ; \
		echo "* You should 'make build_framac' first *" ; \
		echo "******************************************" ; \
	fi
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --build-arg FRAMACIMAGE=$(ARCHIMAGEFRAMAC) \
							 --tag $(ARCHIMAGE) --file $(DOCKERFILE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build base image to experiment with installing new stuff
build_base:
	@echo "Building $(ARCHIMAGEBASE) for $(ARCH) from $(DOCKERFILEBASE)"
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --tag $(ARCHIMAGEBASE) \
							 --file $(DOCKERFILEBASE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Isabelle image
build_isabelle:
	@echo "Building $(ARCHIMAGEISABELLE) for $(ARCH) from $(DOCKERFILEISABELLE)"
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --tag $(ARCHIMAGEISABELLE) \
							 --file $(DOCKERFILEISABELLE) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build Frama-C image
build_framac:
	@echo "Building $(ARCHIMAGEFRAMAC) for $(ARCH) from $(DOCKERFILEFRAMAC)"
	docker build --platform linux/$(ARCH) \
							 --build-arg arch=$(ARCH) \
							 --build-arg BASEIMAGE=$(ARCHIMAGEBASE) \
							 --build-arg ISABELLEIMAGE=$(ARCHIMAGEISABELLE) \
							 --tag $(ARCHIMAGEFRAMAC) \
							 --file $(DOCKERFILEFRAMAC) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [ "$$danglingimages" != "" ]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

login:
	docker login --username fredblgr https://index.docker.io

# Safe way to build multiarchitecture images:
# - build each image on the matching hardware, with the -$(ARCH) tag
# - push the architecture specific images to Dockerhub
# - build a manifest list referencing those images
# - push the manifest list so that the multiarchitecture image exist
manifest:
	docker manifest create $(REPO)$(NAME):$(MAINTAG) $(IMAGES)
	@for arch in $(ARCHS); \
	 do \
	   echo docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	   docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(MAINTAG) $(REPO)$(NAME):$(MAINTAG)-$$arch; \
	 done
	docker manifest push $(REPO)$(NAME):$(MAINTAG)

rmmanifest:
	docker manifest rm $(REPO)$(NAME):$(MAINTAG)


push:
	docker push $(ARCHIMAGE)

save:
	docker save $(ARCHIMAGE) | gzip > $(NAME)-$(MAINTAG)-$(ARCH).tar.gz

# Clear caches
clean:
	docker builder prune

clobber:
	docker rmi $(REPO)$(NAME):$(MAINTAG) $(ARCHIMAGE)
	docker rmi $(ARCHIMAGEISABELLE)
	docker rmi $(ARCHIMAGEFRAMAC)
	docker builder prune --all

run:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

#	  --cap-add SYS_ADMIN
run_base:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEBASE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_isabelle:
	docker run \
	  --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEISABELLE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

run_framac:
	docker run --rm --detach \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGEFRAMAC)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

runpriv:
	docker run --rm --interactive --tty --privileged \
	  --platform linux/$(ARCH) \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--volume ${PWD}/config:/config:rw \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		$(ARCHIMAGE)
	sleep 10
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "http://localhost:3000"

debug:
	docker run --rm --tty --interactive \
	  --platform linux/$(ARCH) \
		--volume ${PWD}/config:/config:rw \
		--env="PUID=`id -u`" --env="PGID=`id -g`" \
		--publish 3000:3000 \
		--publish 3001:3001 \
		--name $(NAME) \
		--entrypoint=bash \
		$(ARCHIMAGE)
