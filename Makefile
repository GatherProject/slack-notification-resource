IMAGE   ?= 983760647947.dkr.ecr.us-east-2.amazonaws.com/ronday-build-tools
VERSION ?= dev

build:
	docker build \
	  --build-arg BUILD_DATE="$(shell date -u --iso-8601)" \
	  --build-arg VCS_REF="$(shell git rev-parse --short HEAD)" \
	  --build-arg vERSION="$(VERSION)" \
	  . -t $(IMAGE):$(VERSION)

push: build
	aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 983760647947.dkr.ecr.us-east-2.amazonaws.com
	docker push $(IMAGE):$(VERSION)

release: build
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(VERSION)
