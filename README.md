*This project has been created as part of the 42 curriculum by mpouillo.*

# Inception

- [Description](#description)
    - [Virtual Machines vs Docker](#virtual-machines-vs-docker)
    - [Secrets vs Environment Variables](#secrets-vs-environment-variables)
    - [Docker Network vs Host Network](#docker-network-vs-host-network)
    - [Docker Volumes vs Bind Mounts](#docker-volumes-vs-bind-mounts)
- [Instructions](#instructions)
- [Resources](#resources)

## Description

### Overview

Inception is an introduction to Docker and containerization. The goal is to set up a small infrastructure composed of different services, running on a virtual machine.

For this project, each Docker image must have the same name as its corresponding service. Each service has to run in a dedicated container. For performance reasons, the containers must be built either from the penultimate stable version of Alpine or Debian (I picked Debian). We must write our own Dockerfiles, one per service, and call them in our docker-compose.yml using a Makefile. It is forbidden to pull ready-made Docker images, as well as using services such as DockerHub (Alpine/Debian being excluded from this rule).

We must set up:
- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress + php-fpm only, without NGINX.
- A Docker container that contains MariaDB only, without NGINX.
- A volume that contains the WordPress database.
- A second volume that contains the WordPress website files.
- We must use Docker named volumes for these two persistent storages. Bind mounts are not allowed for these volumes.
- Both named volumes must store their data inside /home/login/data on the host machine. Replace "login" with the learner’s username.
- A docker-network that establishes the connection between the containers.

### Virtual Machines vs Docker

Docker is a platform used to package software into standardized units (containers). The container has both the application code and its environment, including libraries, system tools, and runtime. Docker allows deploying applications on different machines while making sure code runs consistently.

Docker is an operating system for containers. Similar to how a virtual machine virtualizes (removes the need to directly manage) server hardware, containers virtualize the operating system of a server. Docker provides simple commands you can use to build, start, or stop containers.

A Docker image, or container image, is a standalone, executable file used to create a container. This container image contains all the libraries, dependencies, and files that the container needs to run.

In contrast, a virtual machine is a digital copy of a physical machine. It enables running multiple digital copies of a physical machine, on a single machine. Developers configure the virtual machine to create the application’s environment. It’s also possible to run Docker containers on virtual machines (which is exactly what we are doing in this project).

### Secrets vs Environment Variables

Environment variables are variables shared within an environment. They are stored in clear and are visible to the entire application as effectively as global variables. If an application on a docker container allows to dump environment variables, then any secret contained in it would be visible.

Docker secrets, on the other hand, are only accessible to services with valid, explicit access rights. In most cases, only root users within the docker container will have access to it, making them much safer for storing. Docker secrets allow central management of this data and secure transmission to containers that need access to it.

### Docker Network vs Host Network

Docker networks are virtual networks completely isolated from the host machine and other networks. Every container gets its own private IP address within it. To allow outside traffic to reach a container, we must explicitly use port forwarding to map a port on the host machine to a port inside the container. Without it, containers can't talk to the host or other networks.

The host network strips away that virtual isolation layer. Instead of getting their own IP address, containers are directly connected to the host machine's network. If a containerized application opens a port, it will open directly on the physical (or virtual) host machine. Port mapping is therefore unnecessary (and ignored). If the container is compromised, it can be a security risk to the host.

Docker networks are perfect to connect containers that do not need outside access, or need to be isolated from the host. In this project, only the NGINX container (and a few bonus ones) have access to the outside world. Docker networks also allow running multiple instances of the same containerized app on the same machine, without running into the issue of a single port being used by multiple processes. However, Docker's virtual routing causes overhead, meaning host network will be more performant compared to docker networks.

### Docker Volumes vs Bind Mounts

Data created within container dockers is temporary and disappears when the container is deleted. To be separate from the container's lifetime, data must be stored locally and can be managed either by Docker or the user.

Docker volumes are stored on the host machine and managed by Docker itself. Other non-Docker processes don't need to manage it and shouldn't touch it. It's much simpler than managing the file system ourselves.

Bind mounts are the opposite. Instead of letting Docker manage the storage, we point a container directly to a specific absolute path on the host machine. Docker maps it to a specific path inside the container. Any change made to the local machine instantly reflects inside the container, and vice versa.

## Instructions

Build images and start docker containers:

```shell
$> make all
```

Stop containers:
```shell
$> make down
```

Remove unused containers, networks and images:
```shell
$> make clean
```

Remove local data:
```shell
$> make fclean
```

## Resources

- [Inception (Medium)](https://medium.com/@imyzf/inception-3979046d90a0)
- [Inception 42: A Comprehensive Guide to Dockerizing Your First Infrastructure( PART I) (Medium)](https://devabdilah.medium.com/inception-42-a-comprehensive-guide-to-dockerizing-your-first-infrastructure-part-i-bd7d4bdc13e6)
- [Inception 42: A Comprehensive Guide to Dockerizing Your First Infrastructure( PART II)](https://devabdilah.medium.com/inception-42-a-comprehensive-guide-to-dockerizing-your-first-infrastructure-part-ii-bed64a739bf4)
- [Inception 42: A Comprehensive Guide to Dockerizing Your First Infrastructure( PART III)](https://devabdilah.medium.com/inception-42-a-comprehensive-guide-to-dockerizing-your-first-infrastructure-part-iii-a10e93e9d922)
- [IBM - Distinguished Names](https://www.ibm.com/docs/en/ibm-mq/7.5.0?topic=certificates-distinguished-names)
- [42 Inception TIPS](https://tuto.grademe.fr/inception/)
- [Docker Docs](https://docs.docker.com/)
- [Manually Configuring the Redis Object Cache Plugin for WordPress](https://support.pagely.com/hc/en-us/articles/360015193272-Manually-Configuring-the-Redis-Object-Cache-Plugin-for-WordPress)
- [Docker NGINX + WordPress + MariaDB Tutorial - Inception42](https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok)
- [WordPress CLI Docs](https://make.wordpress.org/cli/)