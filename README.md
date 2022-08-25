# docker-php7.3-fpm
Base PHP-FPM 7.3 + composer + etcdctl image package.

## Note
Note that the repository name does not represent current condition of this repository. Right now you can build the image using different versions of PHP-FPM.

## About
Base package image containing PHP-FPM 7.3 (base), [`composer`][1], and [`etcdctl`][2].

## Requirement
- Linux/Unix-based server
- Docker host
- `etcd` server (optional)

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

### Using Github Actions
This repository has Github Actions workflows to manually/automatically build images and publish it on Github Container Registry (GHCR).

To use this feature, you'll need to:
1. Generate Github Personal Access Token (PAT).

    To allow Github Actions workflows to automatically publish images to GHCR, you'll need to generate Github PAT to authenticate to GHCR.

    To generate Github PAT, see [this page][3]. Note that your Github PAT needs `repo`, `write:packages`, and `read:packages` permission.

2. Update this repository's Actions secret.

    Both ways to build and publish images via Github Actions workflows requires these secrets to be set:

    - `GHCR_USERNAME`
    - `GHCR_TOKEN`

        Github account username and its PAT to use to authenticate to GHCR.

        Note that if you're using Github organization, you'll probably want to create an account to act as _machine user_. See [this page][4] for more information.

        Also, if the Github account is invited as an _outside collaborator_, make sure that the account have at least __Write__ role on this repository.

    - `GHCR_ACTOR`

        Github account/organization to store images in. This account or organization name should not need to be equal to `GHCR_USERNAME`, but it is possible to use the same value for both secrets.

#### Build and Publish Images Manually
To manually build and publish images to GHCR, you'll need to:
1. Go to [Actions][5] page of this repository.
2. Click on _Manual Build and Publish Images_ workflow.
3. Click on _Run workflow_.
4. Select _Branch: main_ on _Use workflow from_.
4. Click on green _Run workflow_ button to run workflow.

#### Build and Publish Images on Release
To build and publish images to GHCR on release, you'll need to create a Release:
1. Optionally, create a tag to be released on the repository.
1. Go to [Releases][6] page of this repository.
1. Click on _Create a new release_ or _Draft a new release_, whichever button is available.
1. Click on _Choose a tag_.
    - If you already have a tag created to be released, choose the tag name from the list of tags here.
    - If you haven't created a tag already, type a new name for the tag and click on _Create new tag: \<tag name\> on publish_.
1. On _Write_ tab, in _Describe this release_ textbox, add informations about the release, e.g. basic release informations, PRs merged, Issues solved, changelogs, etc.
1. Click on _Publish release_ to release the tag.
    - Note that this will trigger _Build and Publish Images on Release_ workflow on Github Actions to run; building and publishing new images to GHCR.

### Running Container with Built Image
To run a container with this image or its derivative, you'll need to prepare:

1. An optional `etcd` server containing project's environment variables,
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

If you want to skip using `etcd` server and obtain environment variables from elsewhere, you may run:

```
docker run \
    -d \
    --rm \
    -p 9000:9000 \
    docker-php7.3-fpm:1.0
```

Don't forget to adjust environment variables and image names before running `docker run`.

[1]: https://getcomposer.org/
[2]: https://github.com/etcd-io/etcd/tree/master/etcdctl
[3]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[4]: https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts#personal-accounts
[5]: https://github.com/Qeon-Digital-House/docker-php7.3-fpm/actions
[6]: https://github.com/Qeon-Digital-House/docker-php7.3-fpm/releases
