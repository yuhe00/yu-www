IMAGE_TAG=eu.gcr.io/inconspicuous-148119/yu-www:$(shell git log --pretty=format:'%h' -n 1)

all: dist

deploy: docker
	kubectl set image deployment/yu-www yu-www=${IMAGE_TAG} --namespace inconspicuous

docker: dist Dockerfile
	docker build -t ${IMAGE_TAG} .
	docker push ${IMAGE_TAG}

node_modules: package.json
	npm install

dist: $(shell find src -type f) $(shell find public -type f) $(shell find elm-stuff -type f) node_modules *.js *.json
	npm run build
