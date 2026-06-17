# DEVELOPER DOCUMENTATION

## Project data structure

```shell
.
├── DEV_DOC.md
├── LICENSE
├── Makefile
├── notes.md
├── README.md
├── secrets
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── db_user.txt
│   ├── ftp_password.txt
│   ├── ftp_user.txt
│   ├── portainer_password.txt
│   ├── wp_admin_email.txt
│   ├── wp_admin_password.txt
│   ├── wp_admin_user.txt
│   ├── wp_email.txt
│   ├── wp_password.txt
│   └── wp_user.txt
├── srcs
│   ├── docker-compose.yml
│   └── requirements
│       ├── bonus
│       │   ├── adminer
│       │   │   └── Dockerfile
│       │   ├── ftp
│       │   │   ├── confs
│       │   │   │   └── vsftpd.conf
│       │   │   ├── Dockerfile
│       │   │   └── tools
│       │   │       └── setup_ftp.sh
│       │   ├── portainer
│       │   │   └── Dockerfile
│       │   ├── redis
│       │   │   ├── confs
│       │   │   │   └── redis.conf
│       │   │   └── Dockerfile
│       │   └── static_website
│       │       ├── confs
│       │       │   └── nginx.conf
│       │       ├── Dockerfile
│       │       └── tools
│       │           ├── index.html
│       │           └── styles.css
│       ├── mariadb
│       │   ├── confs
│       │   │   └── 50-server.cnf
│       │   ├── Dockerfile
│       │   └── tools
│       │       └── init_db.sh
│       ├── nginx
│       │   ├── confs
│       │   │   └── nginx.conf
│       │   └── Dockerfile
│       └── wordpress
│           ├── confs
│           │   └── www.conf
│           ├── Dockerfile
│           └── tools
│               └── setup_wordpress.sh
└── USER_DOC.md
```

## Environment setup

### Host system prerequisites

- Set up a Virtual Machine, using the hypervisor of your choice.
- Install the required dependencies:
    - make
    - docker-ce
    - docker-compose-plugin

### Configuration files

The project relies on an environment file located at `./srcs/.env`. For security reasons, this file is ignored by Git and must be manually provided.

Example template:

```
DOMAIN_NAME=login.42.fr

# OpenSSL
COUNTRY=country
STATE=state
LOCALITY=city
ORGANIZATION=organization
ORGANIZATION_UNIT=unit
COMMON_NAME=common_name
USER_ID=login

# MySQL
MYSQL_DATABASE=database_name
```

### Secrets

A `./secrets/` directory must be manually provided and filled with the required files, as listed in the `USER_DOC.md` file. Each file must contain a single plaintext string with no trailing newlines. For security reasons, this folder is ignored by Git.

## Build and launch lifecycle

The provided makefile acts as an interface for `docker-compose.yml`. Docker Compose reads instructions from `srcs/docker-compose.yml` to build local Dockerfiles instead of pulling pre-made images from DockerHub.

Initial launch:
- Provide and configure secrets.
- Create host data directories at `/home/$(USER)/data` (optional, automatically done by the Makefile).
- Run `make build` to build Docker images.
- Run `make up` to start Docker containers.

## Container and volume management

Makefile reference

| Rules     | Action                                                |
| -----     | ----------------------------------------------------- |
| all       | `build` + `up`                                        |
| build     | Build Docker images                                   |
| up        | Start Docker containers                               |
| down      | Stop Docker containers                                |
| clean     | Prune unused Docker images, containers and volumes    |
| fclean    | `clean` + Delete local host data directories          |
| re        | `fclean` + `all`                                      |

View Docker Container logs in real time:

```shell
# List docker containers
docker ps

# Follow log output
docker logs -f <container_name>
```

Force rebuild a container:

```shell
docker compose -f srcs/docker-compose.yml build --no-cache <service_name>
```

List active networks and internal IP addresses:

```shell
# List network names
docker network ls

# Inspect a specific network to see container internal IP addresses
docker network inspect <network_name>
```

> [!WARNING]
> Running `make fclean` will purge the actual `/home/${USER}/data/ directories on the host machine, resetting the WordPress installation entirely.

## Data storage

Data persistence is achieved by storing data on the host machine and configuring a Docker Named Volume in the `docker-compose.yml` file to point to those host directories. This ensures data persistence even if containers are destroyed, rebuilt or updated, while keeping managed by Docker.

Volumes:
- mariadb_data: `/home/${USER}/data/mariadb/`
- wordpress_data: `/home/${USER}/data/wordpress/`
- portainer_data: `/home/${USER}/data/portainer/`