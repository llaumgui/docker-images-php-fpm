# php-FPM Docker images

[![Author][ico-bluesky]][link-bluesky]
[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pull][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![Software License][ico-license]](LICENSE)

Repository with my php-fpm Dockerfile for my Docker/Podman images.

## Alpine based php-fpm Docker image

Available for:

* PHP 8.4
* PHP 8.3

Usage:

```bash
docker pull llaumgui/php
```

or:

```bash
docker pull ghcr.io/llaumgui/php:latest
```

And see [documentation](https://github.com/llaumgui/docker-images-php-fpm/tree/main/8.4).

## Debian based php-fpm Docker image for Nextcloud

Available for:

* PHP 8.4

Usage:

```bash
docker pull llaumgui/php:8.4-nextcloud-fpm
```

or:

```bash
docker pull ghcr.io/llaumgui/php:8.4-nextcloud-fpm
```

And see [documentation](https://github.com/llaumgui/docker-images-php-fpm/tree/main/8.4-nextcloud).

[ico-bluesky]: https://img.shields.io/static/v1?label=Author&message=llaumgui&color=208bfe&logo=bluesky&style=flat-square
[link-bluesky]: https://bsky.app/profile/llaumgui.kulakowski.fr
[ico-docker]: https://img.shields.io/docker/pulls/llaumgui/php?color=%2496ed&logo=docker&style=flat-square
[link-docker]: https://hub.docker.com/r/llaumgui/php
[ico-ghactions]: https://img.shields.io/github/actions/workflow/status/llaumgui/docker-images-php-fpm/devops.yml?label=DevOps&logo=github&style=flat-square
[link-ghactions]: https://github.com/llaumgui/docker-images-php-fpm/actions
[ico-version]: https://img.shields.io/docker/v/llaumgui/php?sort=semver&color=%2496ed&logo=docker&style=flat-square
[ico-license]: https://img.shields.io/github/license/llaumgui/docker-images-php-fpm?style=flat-square
