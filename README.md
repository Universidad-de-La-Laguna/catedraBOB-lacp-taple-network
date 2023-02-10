# TAPLE LOCAL LAUNCH AUTOMATION

### Automatización del lanzamiento de la red [Taple](https://www.taple.es/) en un entorno local con docker-compose



https://user-images.githubusercontent.com/44450566/216692392-04886180-fcb0-44b2-b420-8c0597dbcd8d.mp4



## Requisitos

- [Docker](https://www.docker.com/)
- [Docker-compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)
- [Ubuntu](https://ubuntu.com/) o cualquier otra distribución de linux

> En OSX, se debe tener instalado GNU sed y tenerlo por defecto.
> Para instalar GNU sed usar:
> ```
> brew install gsed
> ```
> Para usarlo por defecto, añadir a `.bash_profile` o similar:
> ```
> export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
> ```
> Para saber la ruta exacta usar `brew info gsed`

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

5. Crear la gobernanza

```bash
./create-gobernance.sh
```

6. Crear un sujeto tipo `Test`

```bash
./create-test-subject.sh
```

7. Modificar el sujeto tipo `Test` por el propietario

```bash
./modify-test-subject-by-owner.sh
```

```

## Parada

```bash
./stop_nodes.sh
```