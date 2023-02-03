# Automatización del lanzamiento de la red taple en un entorno local con docker-compose


## Visualizacion de la ejecución



https://user-images.githubusercontent.com/44450566/216692392-04886180-fcb0-44b2-b420-8c0597dbcd8d.mp4



## Requisitos

- [Docker](https://www.docker.com/)
- [Docker-compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)
- [Ubuntu](https://ubuntu.com/) o cualquier otra distribución de linux

## Ejecución

1. Clonar el repositorio

```bash 
git clone https://github.com/rubensantibanezacosta/taple-local-automation.git
```

2. Acceder a la carpeta raíz del proyecto

```bash
cd taple-local-automation
```

3. Asegurar que el script tiene permisos de lectura

```bash
chmod 777 start_nodes.sh
```

4. Ejecutar el script, y responder a la terminal interactiva

```bash
./start_nodes.sh
```

