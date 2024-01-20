# PHP FPM Docker Container Images

![GitHub release (with filter)](https://img.shields.io/github/v/release/nulldark/php-fpm)

## Supported tags and respective Dockerfile links
- [`8.3`, `latest`](https://github.com/nulldark/php/blob/master/8.3/Dockerfile)
- [`8.2`](https://github.com/nulldark/php/blob/master/8.2/Dockerfile)

## Quick reference
- **Image based on**:   
  [ghrc.io/nulldark/alpine](https://github.com/nulldark/php)

- **Supported architectures**:    
  `linux/amd64`, `linux/arm64`

- **Maintained by**:  
  [nulldark](https://github.com/nulldark)

- **Where to file issues**:    
  [https://github.com/nulldark/php-fpm/issues](https://github.com/nulldark/php/issues?q=)

## How to use this image

### start a php instance

```console
$ docker run --name some-php-fpm -d php-fpm
```

### ... via [`docker-compose`](https://github.com/docker/compose)
Example `docker-compose.yml` for `php-fpm`:

```yaml
version: '3.1'

services:
    php-fpm:
        image: ghcr.io/nulldark/php-fpm
        restart: always
        ports:
            - "9000:9000"
```

## Environment Variables

The php-fpm image uses several environment variables which are easy to miss.

| Variable       | Default Value  | Description |
|----------------|----------------|-------------|
| `PHP_USER_ID`  | `1000`         |             |
| `PHP_GROUP_ID` | `1000`         |             |
| `PHP_FPM_PORT` | `9000`         |             |