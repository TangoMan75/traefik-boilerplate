#/**
# * TangoMan Traefik
# *
# * @version  0.1.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @license  MIT
# */

.PHONY: help up open shell clear build start stop status restart acme network

#--------------------------------------------------
# Colors
#--------------------------------------------------

TITLE     = \033[1;42m
CAPTION   = \033[1;44m
BOLD      = \033[1;34m
LABEL     = \033[1;32m
DANGER    = \033[31m
SUCCESS   = \033[32m
WARNING   = \033[33m
SECONDARY = \033[34m
INFO      = \033[35m
PRIMARY   = \033[36m
DEFAULT   = \033[0m
NL        = \033[0m\n

#--------------------------------------------------
# Help
#--------------------------------------------------

## Print this help
help:
	@printf "${TITLE} TangoMan Traefik ${NL}\n"

	@printf "${CAPTION} Description:${NL}"
	@printf "${WARNING} TangoMan Traefik${NL}\n"

	@printf "${CAPTION} Usage:${NL}"
	@printf "${WARNING} make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${NL}\n"

	@printf "${CAPTION} Commands:${NL}"
	@awk '/^### /{printf"\n${BOLD}%s${NL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf " ${LABEL}%-12s${DEFAULT} ${PRIMARY}%s${NL}",substr($$1,0,index($$1,":")),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##############################################
### Traefik Local
##############################################

## Build and start traefik
up: network build acme start

## Open traefik dashboard in default browser
open:
	@printf "${INFO}nohup xdg-open http://traefik.localhost >/dev/null 2>&1${NL}"
	@nohup xdg-open http://traefik.localhost >/dev/null 2>&1

# ## Open traefik dashboard in default browser
# open:
# 	@printf "${INFO}nohup xdg-open `docker inspect startups --format 'http://{{.NetworkSettings.Networks.tango.IPAddress}}' 2>/dev/null` >/dev/null 2>&1${NL}"
# 	@nohup xdg-open `docker inspect startups --format 'http://{{.NetworkSettings.Networks.tango.IPAddress}}' 2>/dev/null` >/dev/null 2>&1

## Open a terminal in the traefik container
shell:
	@printf "${INFO}docker-compose exec traefik sh${NL}"
	@docker-compose exec traefik sh

## Clear logs
clear:
	@printf "${INFO}sudo rm ./logs/*.log${NL}"
	@sudo rm ./logs/*.log

##################################################
### Docker-Compose Container
##################################################

## Build docker stack
build:
	@printf "${INFO}docker-compose build${NL}"
	@docker-compose build

## Start docker stack
start:
	@printf "${INFO}docker-compose up --detach --remove-orphans${NL}"
	@docker-compose up --detach --remove-orphans

## Stop docker stack
stop:
	@printf "${INFO}docker-compose stop${NL}"
	@docker-compose stop

## List containers
status:
	@printf "${INFO}docker-compose ps${NL}"
	@docker-compose ps

## Restart container
restart: stop start

##################################################
### Traefik Let's Encrypt
##################################################

## Create acme.json file
acme:
	@printf "${INFO}touch ./config/acme.json${NL}"
	@touch ./config/acme.json

	@printf "${INFO}chmod 600 ./config/acme.json${NL}"
	@chmod 600 ./config/acme.json

##################################################
### Docker-Compose Network
##################################################

## Create `tango` network
network:
	@printf "${INFO}docker network create tango${NL}"
	-@docker network create tango

## Remove "tango" network
remove-network:
	@printf "${INFO}docker network rm tango${NL}"
	@docker network rm tango

