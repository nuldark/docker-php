# PHP Docker Container Images

![GitHub release (with filter)](https://img.shields.io/github/v/release/nuldark/docker-php)

## Supported tags and respective Dockerfile links
- [`8.3.7`, `8.3`, `8`, `latest`](https://github.com/nuldark/docker-php/blob/master/8.3/base/Dockerfile)
- [`8.3.7-cli`, `8.3-cli`, `8-cli`, `cli`](https://github.com/nuldark/docker-php/blob/master/8.3/cli/Dockerfile)
- [`8.3.7-fpm`, `8.3-fpm`, `8-fpm`, `fpm`](https://github.com/nuldark/docker-php/blob/master/8.3/fpm/Dockerfile)
- [`8.2.19`, `8.2`](https://github.com/nuldark/docker-php/blob/master/8.2/base/Dockerfile)
- [`8.2.19-cli`, `8.2-cli`](https://github.com/nuldark/docker-php/blob/master/8.2/cli/Dockerfile)
- [`8.2.19-fpm`, `8.2-fpm`](https://github.com/nuldark/docker-php/blob/master/8.2/fpm/Dockerfile)

## Quick reference
- **Image based on**:   
  [alpine](https://hub.docker.com/_/alpine)

- **Supported architectures**:    
  `linux/amd64`, `linux/arm64`

- **Maintained by**:  
  [nuldark](https://github.com/nuldark)

- **Where to file issues**:    
  [https://github.com/nuldark/docker-php/issues](https://github.com/nuldark/docker-php/issues?q=)

## How to use this image

### start a php instance

```console
$ docker run --name some-fpm -d php
```

### ... via [`docker-compose`](https://github.com/docker/compose)
Example `docker-compose.yml` for `php-fpm`:

```yaml
version: '3.1'

services:
    php-fpm:
        image: nuldark/php:latest
        restart: always
        ports:
            - "9000:9000"
```

## Environment Variables

The php image uses several environment variables which are easy to miss.

| Variable      | Default Value | Description |
|---------------|---------------|-------------|
| `PHPIZE_DEPS` |               |             |

## LICENSE

View [license](https://www.php.net/license/) information for the software contained in this image.
