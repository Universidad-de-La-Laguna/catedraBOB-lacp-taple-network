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

3. Ejecutar el script de inicialización de nodos (tras haber iniciado Docker), y responder a la terminal interactiva

```bash
./start_nodes.sh
```

4. Crear la gobernanza

```bash
./create-gobernance.sh
```

5. Crear los sujetos de la red: `LACP` , `Diligence` y `Record`

```bash
./create-lacp.sh
./create-diligence.sh
./create-record.sh
```

6. Modificar el sujeto tipo `LACP` por alguien diferente al propietario, sin confirmación.
```bash
./modify-lacp-by-other.sh
```

7. Modificar el sujeto `Record` por el propietario y aprobar la modificación por alguien diferente.
```bash
./modify-record-by-owner.sh
```

## Parada   

```bash
./stop_nodes.sh
```

## Documentación

### Estructuras de datos
`LACP`. 

`Diligence`. Modela la diligencia asociada a un LACP. 
- diligence_id: Identificador interno.
- land_registry_property_number. Número identificador de de la finca registral dentro del Registro de la Propiedad. Ejemplo: "Libro 1127, Sección 2ª, folio 121, finca registral 38013".
- CRU. Código Registral Único. Identifica inequívocamente a la finca dentro del Registro de la Propiedad
- inscription. Ordinal de la inscripción.
- expedition_date: Fecha de expedición de la diligencia.
- registrar_name: Nombre del Registrador de la Propiedad.
- registrar_area: Área sobre la que actúa el Registrador de la Propiedad. Ej: Madrid 14.
- observations: Observaciones del registrador al crear la diligencia.
- lacp_size: Tamaño que otorga la diligencia al libro. Una diligencia rechazada se modela con un tamaño 0.
- lacp_id: Referencia al identificador interno del LACP al que está asociado esta diligencia.

`Record`. Modela un acta de un LACP.
- record_id: Identificador interno.
- record_name: Nombre o título del acta.
- record_start_date_time: Fecha y hora de inicio de la reunión.
- record_end_date_time: Fecha y hora de finalización de la reunión.
- record_type: Naturaleza del acta. Puede ser ordinaria (ORDINARY) o extraordinaria (EXTRAORDINARY).
- record_president: Nombre del presidente de la reunión. En blanco si es el presidente de la comunidad.
- record_secretary: Nombre del secretario de la reunión. En blanco si es el secretario de la comunidad.
- record_place: Lugar de reunión.
- assistants: Lista de asistentes. Además, se pueden especificar sus propiedades y cuotas de participación asociadas.
- body: Contenido, texto, temas a tratar, etc. en la reunión. Acuerdos adoptados.
- status: Estado del acta. Puede estar pendiente de aprobación (PENDING), aceptada (APPROVED) o rechazada (DENIED).
- lacp_id: Referencia al identificador interno del LACP al que está asociado este acta.