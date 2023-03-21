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

### 1. Inicialización de la red TAPLE

1.2. Clonar el repositorio

```bash 
git clone https://github.com/Universidad-de-La-Laguna/catedraBOB-lacp-taple-network.git
```

1.2. Acceder a la carpeta raíz del proyecto

```bash
cd catedraBOB-lacp-taple-network
```

1.3. Ejecutar el script de inicialización de nodos (tras haber iniciado Docker), y responder a la terminal interactiva

```bash
./start_nodes.sh
```

1.4. Crear la gobernanza

```bash
./create-gobernance.sh
```

### 2. Casos de uso del LACP

2.1. Crear el sujeto: `LACP`
```bash
./create-lacp.sh
```

2.2. Crear el sujeto `Diligence`, y modificar el LACP por el registrador, sin confirmación
```bash
./create-diligence.sh
./modify-lacp-by-other.sh
```

2.3. Crear el sujeto `Record`, modificarlo por el propietario y aprobar la modificación por alguien diferente.
```bash
./create-record.sh
./modify-record-by-owner-request.sh
./modify-record-by-owner-approval.sh
```

## Parada   

```bash
./stop_nodes.sh
```

## Documentación

### Estructuras de datos
`LACP`. Modela el Libro de Actas de la Comunidad de Propietarios.
- lacp_id: Identificador interno.
- community_name: Nombre de la comunidad.
- community_address: Dirección de la comunidad.
- president_name: Nombre del presidente de la comunidad.
- president_contact: Contacto del presidente.
- secretary_name: Nombre del secretario de la comunidad.
- secretary_contact: Contacto del secretario.
- diligence_id: Referencia al identificador de la diligencia asociada al LACP.

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