# USER DOCUMENTATION

## Available services

| Service Name      | Internal Port(s)      | External Port(s)      | Description                                                   |
| ----------------- | --------------------- | --------------------- | ------------------------------------------------------------- |
| NGINX             | 443                   | 443                   | Interface with outside world                                  |
| Wordpress         | 9000                  | None                  | Serves website data requested through NGINX container         |
| MariaDB           | 3306                  | None                  | Stores databases required by WordPress                        |
| Redis             | 6379                  | None                  | Saves frequently requested data in cache for quick retrieval  |
| FTP               | 20, 21, 40000-40005   | 20, 21, 40000-40005   | Allows outside access to local WordPress files                |
| Static website    | 8080                  | None                  | Serves website data requested through NGINX container         |
| Adminer           | 8080                  | None                  | Provides easy access to WordPress database                    |
| Portainer         | 9443                  | None                  | Web overview of local docker containers                       |

## Instructions

### Start the project

Run:

```shell
make all
```

Equivalent to:

```shell
make build
make up
```

### Stop the project

Run:

```shell
make down
```

Remove unused containers, images and volumes:

```shell
make clean
```

## Access web services

> [!WARNING]
> To access using `<login>.42.fr`, make sure to update `/etc/hosts`:
>
> ```bash
> echo "127.0.0.1 <login>.42.fr" >> /etc/hosts
> ```

| Service               | Address                           | Description                       |
| --------------------- | --------------------------------- | --------------------------------- |
| WordPress             | `https://<login>.42.fr`           | Main WordPress public website     |
| WordPress admin panel | `https://<login>.42.fr/wp-admin`  | WordPress administrator dashboard |
| Static website        | `https://<login>.42.fr/static`    | Bonus static website              |
| Adminer               | `https://<login>.42.fr/adminer`   | Database management interface     |
| Portainer             | `https://<login>.42.fr/portainer` | Container management interface    |

## Locate and manage credentials

Environment variables are stored in `./srcs/.env`. They are stored as a list of KEY=VALUE pairs, one per line.

| Key               | Description                                   |
| ----------------- | --------------------------------------------- |
| DOMAIN_NAME       | Custom domain name (e.g., \<login\>.42.fr)    |
| COUNTRY           | Country name                                  |
| STATE             | State name                                    |
| LOCALITY          | Locality name                                 |
| ORGANIZATION      | Organization name                             |
| ORGANIZATION_UNIT | Organization unit                             |
| COMMON_NAME       | Common name                                   |
| USER_ID           | User ID                                       |
| MYSQL_DATABASE    | MariaDB database name                         |



Secrets are stored in `./secrets/<name>.txt`.

You can change the contents of a file to update its value. Values must be a single string.

| Filename                  | Description                                   |
| ------------------------- | --------------------------------------------- |
| db_password.txt           | User password for MariaDB database            |
| db_root_password.txt      | Root password for MariaDB database            |
| db_user.txt               | User name for MariaDB database                |
| ftp_password.txt          | User password for FTP service                 |
| ftp_user.txt              | User name for FTP service                     |
| portainer_password.txt    | Administrator password for Portainer service  |
| wp_admin_email.txt        | Administrator e-mail for WordPress service    |
| wp_admin_password.txt     | Administrator password for WordPress service  |
| wp_admin_user.txt         | Administrator name for WordPress service      |
| wp_email.txt              | User e-mail for WordPress service             |
| wp_password.txt           | User password for WordPress service           |
| wp_user.txt               | User name for WordPress service               |

## Check service status

Run:

```shell
docker ps
```

To execute commands inside of a docker container, run:

```shell
docker exec -it <container_name> CONTAINER COMMAND [ARG...]
```