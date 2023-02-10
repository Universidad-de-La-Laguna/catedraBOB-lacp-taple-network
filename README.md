# Catedra BOB - LACP - Taple Network

Automatización del lanzamiento de la red [Taple](https://www.taple.es/) en un entorno local con docker-compose, para el proyecto de **Libro de Actas de la Comunidad de Propietarios**.

## Requisitos

- [Docker](https://www.docker.com/)
- [Docker-compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)
- [Ubuntu](https://ubuntu.com/) o cualquier otra distribución de linux
- [jq](https://stedolan.github.io/jq/)
- *(Solo en OSX)* [GNU sed](https://www.gnu.org/software/sed/). Instrucciones de instalación y uso por defecto en este [enlace](https://medium.com/@bramblexu/install-gnu-sed-on-mac-os-and-set-it-as-default-7c17ef1b8f64).

## Ejecución

1. Clonar el repositorio

```bash 
git clone https://github.com/Universidad-de-La-Laguna/catedraBOB-lacp-taple-network.git
```

2. Acceder a la carpeta raíz del proyecto

```bash
cd catedraBOB-lacp-taple-network
```

3. Ejecutar el script, y responder a la terminal interactiva

```bash
./start_nodes.sh
```

4. Crear la gobernanza

```bash
./create-gobernance.sh
```

5. Crear un sujeto tipo `Test`

```bash
./create-test-subject.sh
```

6. Modificar el sujeto tipo `Test` por el propietario

```bash
./modify-test-subject-by-owner.sh
```

## Parada

```bash
./stop_nodes.sh
```