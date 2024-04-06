<div style="width:100%;float:left;clear:both;margin-bottom:50px;">
    <a href="https://github.com/pabloripoll?tab=repositories">
        <img style="width:150px;float:left;" src="https://pabloripoll.com/files/logo-light-100x300.png"/>
    </a>
</div>

# RabbitMQ 3.13

The objective of this repository is having a CaaS [Containers as a Service](https://www.ibm.com/topics/containers-as-a-service) to provide a "ready to use" container with the basic enviroment features to deploy a [RabbitMQ](https://www.rabbitmq.com/) broker service under a lightweight Linux Alpine image for development stage requirements.

The container configuration is as [Host Network](https://docs.docker.com/network/drivers/host/) on `eth0` as [Bridge network](https://docs.docker.com/network/drivers/bridge/), thus it can be accessed through `localhost:${PORT}` by browsers but to connect with it or this with other services `${HOSTNAME}:${PORT}` will be required.

### RabbitMQ Container Service

- [RabbitMQ 3.13](https://www.rabbitmq.com/docs/download)

- [Alpine Linux 3.19](https://www.alpinelinux.org/)

### Docker Hub reference:
[https://hub.docker.com/layers/library/rabbitmq/3.13-management-alpine/](https://hub.docker.com/layers/library/rabbitmq/3.13-management-alpine/images/sha256-5da18052312b38f6415a50a60c6fd2a418336993947fac25d309765353ba1d88)

### Built from Docker RabbitMQ:

[Docker Official Image packaging for RabbitMQ](https://github.com/docker-library/rabbitmq/blob/6cc0f66ec13b06c153a7527c033cf1ad59a97ef3/3.13/alpine/management/Dockerfile)

### Project objetives with Docker

* Built on the lightweight and secure Alpine 3.19 [2024 release](https://www.alpinelinux.org/posts/Alpine-3.19.1-released.html) Linux distribution
* Multi-platform, supporting AMD4, ARMv6, ARMv7, ARM64
* Very small Docker image size (+/-40MB)
* The logs of all the services are redirected to the output of the Docker container (visible with `docker logs -f <container name>`)
* Follows the KISS principle (Keep It Simple, Stupid) to make it easy to understand and adjust the image to your needs
* Services independency to connect the application to other database allocation