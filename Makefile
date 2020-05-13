.PHONY: help install importdb clean-cache rebuild start stop logs ps bash

NAME = Formation-M2
VERSION = 0.1.0
TARGETS := $(MAKEFILE_LIST)
SHELL := /bin/bash

help: ## [Help] This help
	@grep -E '^[2a-zA-Z_-]+:.*?## .*$$' $(TARGETS) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## DOCKER
start: ## [Docker] Start the containers
	docker-compose up

startd: ## [Docker] Start the containers detached
	docker-compose up -d

build: ## [Docker] Build the containers
	docker-compose build

stop: ## [Docker] Stop the containers
	docker-compose stop

ps: ## [Docker] Show running containers
	docker-compose ps

logs: ## [Docker] Show output of containers
	docker-compose logs

bash: ## [Docker] Launch bash on web container with magento user
	docker-compose exec --user magento web /bin/bash

bash-www-data: ## [Docker] Launch bash on web container in www-data
	docker-compose exec web /bin/bash -c 'su www-data -s /bin/bash'

bash-root: ## [Docker] Launch bash on web container in root
	docker-compose exec web /bin/bash

## Varnish
vanishlog: ## [Varnish]show varnishlog
	docker-compose exec varnish varnishlog

## INSTALL
addhost: ## [Install][hosts] add host into /etc/hosts
	sudo ./bin/change-hosts.sh

## REDIS
redis-cache-cli: ## [Redis] Run redis-cli for cache instance
	docker-compose exec redis-cache redis-cli

redis-cache-flush: ## [Redis] Flush cache instance
	docker-compose exec redis-cache redis-cli flushall

redis-session-cli: ## [Redis] Run redis-cli for session instance
	docker-compose exec redis-session redis-cli

redis-session-flush: ## [Redis] Flush session instance
	docker-compose exec redis-session redis-cli flushall

install: ## [Install] Fresh install
	docker-compose exec db mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	docker-compose exec web /usr/local/bin/prepare-magento
	docker-compose exec --user magento web /usr/local/bin/install-magento
	make addhost
	make redis-cache-flush
	make redis-session-flush
	echo 'Install finished: access here http://127.0.0.1/'
