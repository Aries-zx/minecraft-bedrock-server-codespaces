#!/bin/bash

# Configuración de variables
SERVER_DIR="/workspace/minecraft-server"
SERVER_ZIP="bedrock-server.zip"

# Función para obtener la última versión
get_latest_version() {
    echo "🔍 Buscando la última versión del servidor..."
    # URL de la página de descarga del servidor
    DOWNLOAD_PAGE="https://www.minecraft.net/en-us/download/server/bedrock"
    
    # Obtener la URL de descarga de la última versión
    DOWNLOAD_URL=$(curl -s $DOWNLOAD_PAGE | grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | head -n 1)
    
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "❌ Error: No se pudo encontrar la URL de descarga"
        exit 1
    fi
    
    echo "✅ URL de descarga encontrada: $DOWNLOAD_URL"
    return 0
}

echo "🚀 Iniciando configuración del servidor de Minecraft Bedrock..."

# Crear directorio si no existe
mkdir -p $SERVER_DIR
cd $SERVER_DIR

# Copiar archivo de configuración predeterminado si no existe
if [ ! -f "server.properties" ]; then
    echo "📝 Copiando configuración predeterminada..."
    cp ../scripts/server.properties ./server.properties
fi

# Descargar o actualizar el servidor
echo "🔄 Verificando la última versión del servidor..."
get_latest_version

if [ -f "bedrock_server" ]; then
    echo "📝 Comprobando actualizaciones..."
    CURRENT_VERSION=$(./bedrock_server --version 2>&1 | grep -o '[0-9.]*' | head -n 1)
    NEW_VERSION=$(echo $DOWNLOAD_URL | grep -o '[0-9.]*' | head -n 1)
    
    if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
        echo "🆕 Nueva versión disponible: $NEW_VERSION"
        echo "📥 Descargando nueva versión..."
        mv bedrock_server bedrock_server.old
    else
        echo "✅ Ya tienes la última versión instalada"
        return 0
    fi
fi

echo "📥 Descargando servidor de Minecraft Bedrock..."
if ! wget -O $SERVER_ZIP "$DOWNLOAD_URL"; then
    echo "❌ Error al descargar el servidor"
    if [ -f "bedrock_server.old" ]; then
        echo "🔄 Restaurando versión anterior..."
        mv bedrock_server.old bedrock_server
    fi
    exit 1
fi

echo "📦 Extrayendo archivos..."
if ! unzip -o $SERVER_ZIP; then
    echo "❌ Error al extraer los archivos"
    if [ -f "bedrock_server.old" ]; then
        echo "🔄 Restaurando versión anterior..."
        mv bedrock_server.old bedrock_server
    fi
    rm $SERVER_ZIP
    exit 1
fi

# Limpiar archivos temporales
rm $SERVER_ZIP
if [ -f "bedrock_server.old" ]; then
    rm bedrock_server.old
fi

# Dar permisos de ejecución
chmod +x bedrock_server

echo "✅ Servidor descargado y configurado correctamente"

# Verificar si el servidor ya está corriendo
if screen -list | grep -q "minecraft"; then
    echo "⚠️ El servidor ya está en ejecución"
    exit 1
fi

# Iniciar el servidor
echo "🎮 Iniciando servidor de Minecraft..."
screen -dmS minecraft ./bedrock_server

echo "✨ ¡Servidor iniciado correctamente!"
echo "Para acceder a la consola del servidor: screen -r minecraft"
echo "Para salir de la consola: Ctrl+A seguido de D"
