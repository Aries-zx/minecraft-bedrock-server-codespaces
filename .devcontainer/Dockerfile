FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    libcurl4 \
    libssl1.1 \
    screen \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Configuramos el directorio de trabajo
WORKDIR /workspace

# Exponemos el puerto de Minecraft Bedrock
EXPOSE 19132/udp
EXPOSE 19133/udp
EXPOSE 3000

# Creamos el directorio para el servidor
RUN mkdir -p /workspace/minecraft-server
