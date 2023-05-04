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

## 0. Requisitos previos
0.1. Clonar el repositorio de GitHub
```bash 
git clone https://github.com/Universidad-de-La-Laguna/catedraBOB-lacp-taple-network.git
```

0.2. Acceder a la carpeta raíz del proyecto
```bash
cd catedraBOB-lacp-taple-network
```

### 1. Inicialización de la red TAPLE
1.1. Inicializar los nodos (tras haber iniciado Docker), y responder a la terminal interactiva
```bash
./start_nodes.sh
```

1.2. Crear la gobernanza
```bash
./create-governance.sh
```

### 2. Casos de uso del LACP

2.1. Crear el sujeto `LACP`
```bash
./create-lacp.sh
```

2.2. Crear el sujeto `Diligence`, y modificar el LACP por alguien diferente a su propietario (registrador) sin confirmación requerida
```bash
./create-diligence.sh
./modify-lacp-by-other.sh
```

2.3. Crear el sujeto `Record`, modificarlo por el propietario (secretario) y aprobar la modificación por alguien diferente (presidente).
```bash
./create-record.sh
./modify-record-by-owner-request.sh
./modify-record-by-owner-approval.sh
```

2.4. Visualizar los sujetos de la red: `Diligence`, `LACP` y `Record` por parte de un comunero, 
además de la propia gobernanza de la red.
```bash
./view-subjects.sh
```

### 3. Pruebas de seguridad de la red TAPLE
3.1. Comprobar que sólo el registrador puede modificar un LACP
```bash
./create-lacp.sh
./create-diligence.sh
./modify-lacp-error.sh
```
> Nota: El script debe tener como salida dos errores (uno por intento de modificación del presidente y otro del secretario)

3.2. Comprobar que sólo el secretario puede modificar actas

```bash
./create-record.sh
./modify-record-request-error.sh
```

> Nota: El script debe tener como salida dos errores (uno por intento de modificación del presidente y otro del registrador)

3.3. Comprobar que sólo el presidente puede aprobar modificaciones de actas

```bash
./create-record.sh
./modify-record-approval-error.sh
```

> Nota: El script debe tener como salida dos errores (uno por intento de modificación del registrador y otro del secretario)

## Parar los nodos

```bash
./stop_nodes.sh
```

## Documentación

### Estructuras de datos
`LACP`. Modela el Libro de Actas de la Comunidad de Propietarios.
- community_name: Nombre de la comunidad.
- community_address: Dirección de la comunidad.
- president_name: Nombre del presidente de la comunidad.
- president_contact: Contacto del presidente.
- secretary_name: Nombre del secretario de la comunidad.
- secretary_contact: Contacto del secretario.
- diligence_id: Referencia al identificador (Subject ID) de la diligencia asociada al LACP.

`Diligence`. Modela la diligencia asociada a un LACP. 
- land_registry_property_number. Número identificador de de la finca registral dentro del Registro de la Propiedad. Ejemplo: "Libro 1127, Sección 2ª, folio 121, finca registral 38013".
- CRU. Código Registral Único. Identifica inequívocamente a la finca dentro del Registro de la Propiedad
- inscription. Ordinal de la inscripción.
- expedition_date: Fecha de expedición de la diligencia.
- registrar_name: Nombre del Registrador de la Propiedad.
- registrar_area: Área sobre la que actúa el Registrador de la Propiedad. Ej: Madrid 14.
- observations: Observaciones del registrador al crear la diligencia.
- lacp_size: Tamaño que otorga la diligencia al libro. Una diligencia rechazada se modela con un tamaño 0.
- lacp_id: Referencia al identificador (Subject ID) del LACP al que está asociado esta diligencia.

`Record`. Modela un acta de un LACP.
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
- lacp_id: Referencia al identificador (Subject ID) del LACP al que está asociado el acta.