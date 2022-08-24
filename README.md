# docker-php7.3-fpm
Base PHP-FPM 7.3 + composer + etcdctl image package

## About
Base package image containing PHP-FPM 7.3 (base), [`composer`][1], and [`etcdctl`][2].

## Requirement
- Linux/Unix-based server
- Docker host
- `etcd` server

## Usage
### Building Image
To build a base image, pick a version from this repository, then run `docker build`.

For example, if you're about to build PHP 7.3 image, run:

```
docker build . -f php_fpm-7.3/Dockerfile -t docker-php7.3-fpm:1.0
```

If you want to expand this image, e.g. copying all project files, running `composer install`, etc; just build a base image, and create a new `Dockerfile`. `Dockerfile` content should look like this:

```docker
FROM docker-php7.3-fpm:1.0

WORKDIR /app
COPY . .

RUN composer install
```

### Running Container with Built Image
To run a container with this image or its derivative, you'll need to prepare:

1. Running `etcd` server containing project's environment variables,
1. Project env's key prefix, and
1. Project's assumed env file location.

If you're done so, to start a container, you'll need to define these environment variables:

- `USE_ETCD`: Set this environment variable to enable fetching environment variables from `etcd` server.
- `ETCD_SERVER`: URL to `etcd` client endpoint, e.g. `http://192.168.0.22:2379`.
- `ENV_PATH`: Full absolute path to env file, e.g. `/app/.env`.
- `ENV_PREFIX`: `etcd` key prefix for env variables, e.g. `/com/qeon/www/envs`.

Now you're ready to start a container. This command should be enough to run a standard container:

```
docker run \
    -d \
    --rm \
    -p 9000:9000 \
    --env "USE_ETCD=yes" \
    --env "ETCD_SERVER=http://192.168.0.22:2379" \
    --env "ENV_PATH=/app/.env" \
    --env "ENV_PREFIX=/com/qeon/www/envs" \
    docker-php7.3-fpm:1.0
```

Don't forget to adjust environment variables and image names before running `docker run`.


[1]: https://getcomposer.org/
[2]: https://github.com/etcd-io/etcd/tree/master/etcdctl