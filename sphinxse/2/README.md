# CentOS Sphinx Search Engine
An Sphinx 2.0 from [EPEL](https://fedoraproject.org/wiki/EPEL) build on [CentOS 7](https://hub.docker.com/_/centos/).

Sphinx Search Engine 2.0 build with:
* [CentOS 7](https://hub.docker.com/_/centos/).
* Build full index on start if no index.
* Build index in rotate mode on start if indexes.

## Usage
### With docker client
You can run this container with docker client:
~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/sphinxse/data:/var/lib/sphinx \
  --volumes /docker/volumes/sphinxse/conf:/etc/sphinx:ro \
  --volumes /docker/volumes/sphinxse/log:/var/log/sphinx \
  --expose 9312 \
  llaumgui/centos7-sphinx
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  sphinxse:
    container_name: sphinxse
    image: llaumgui/centos7-sphinx
    restart: always
    mem_limit: 2g
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /docker/volumes/sphinxse/data:/var/lib/sphinx
      - /docker/volumes/sphinxse/conf:/etc/sphinx:ro
      - /docker/volumes/sphinxse/log:/var/log/sphinx
    expose:
      - 9312
~~~

### Call indexer client
You can call indexer with `docker exe`:
~~~bash
docker exec -it ${DOCKER_CONTAINER} /usr/bin/indexer --config /etc/sphinx/sphinx.conf core --all
docker exec -it ${DOCKER_CONTAINER} /usr/bin/indexer --config /etc/sphinx/sphinx.conf --all --rotate
~~~