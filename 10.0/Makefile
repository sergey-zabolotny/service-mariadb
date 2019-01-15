-include env_make

VERSION ?= 10.0.37

REPO ?= zabolotny/mariadb
NAME = docksal-mariadb-$(VERSION)
IMAGE = $(REPO):$(VERSION)
MYSQL_ROOT_PASSWORD = root
MYSQL_USER = user
MYSQL_PASSWORD = user
MYSQL_DATABASE = default
ENV = -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e MYSQL_DATABASE=$(MYSQL_DATABASE) -e VERSION=$(VERSION)

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(IMAGE) --build-arg VERSION=$(VERSION) .

test:
	IMAGE=$(IMAGE) NAME=$(NAME) bats ../tests/test.bats

push:
	docker push $(IMAGE)

shell:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(IMAGE) /bin/bash

run:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(IMAGE)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(IMAGE)

exec:
	docker exec -it $(NAME) /bin/bash

mysql-query:
	# Usage: make mysql-query QUERY='SHOW DATABASES;'
	docker exec $(NAME) bash -c "mysql --host=localhost --user=root --password=$(MYSQL_ROOT_PASSWORD) -e '$(QUERY)'"

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME) >/dev/null 2>&1 || true

release: build push

default: build
