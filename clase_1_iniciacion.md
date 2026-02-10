# Guía de Inicio y Fundamentos: Django con Docker

## 1. Descripción del Proyecto

Este proyecto está diseñado para **fines educativos**. Su objetivo es servir como una base robusta y bien estructurada para aprender a desarrollar aplicaciones web con Django, poniendo especial énfasis en la persistencia de datos con una base de datos real (MySQL) y el uso de Docker para crear un entorno de desarrollo consistente.

La estructura del proyecto sigue las mejores prácticas de la comunidad de Django, incorporando herramientas modernas como `Docker`, `Ruff` y `Makefile` para crear un entorno de desarrollo profesional y fácil de usar.

### Características Principales

-   **Framework:** Django 4.2.27
-   **Base de datos:** MySQL 8.0
-   **Entorno de desarrollo:** Contenerizado con Docker y Docker Compose
-   **Calidad de código:** Linter `Ruff` preconfigurado.
-   **Automatización:** `Makefile` con atajos para las operaciones más comunes.

---

## 2. Conceptos Clave: Web, Django y Docker

### A. El Servidor Web: La Pizzería de Internet

Imagina que pedimos una pizza a domicilio. El proceso es muy similar a cómo funciona la web.

1.  **Petición (Request):** Llamas por teléfono (petición HTTP) y pides una "pizza barbacoa grande" (la URL, `/pizzas/barbacoa`).
2.  **El Servidor Web (La pizzería):** Atiende el teléfono y pasa el pedido a la cocina. Se encarga de "hablar" el protocolo HTTP.
3.  **El "Backend" (La cocina - Django):** Aquí se procesa el pedido. El jefe de cocina (`urls.py`) sabe qué cocinero (`views.py`) debe preparar la receta, usando ingredientes del almacén (la base de datos, definida en `models.py`).
4.  **Respuesta (Response):** El repartidor coge la pizza en su caja (la respuesta HTML) y te la lleva a casa (a tu navegador).

El servidor de desarrollo que usamos con `python manage.py runserver` es como un "horno-portátil": perfecto para probar recetas, pero no para una pizzería real.

### B. ¿Qué es Django? El Framework para Perfeccionistas con Prisas

Django es un **framework de desarrollo web de alto nivel escrito en Python**. Un "framework" es un conjunto de herramientas y librerías que nos da una estructura y nos facilita la vida para no tener que empezar desde cero. Su filosofía es "baterías incluidas", lo que significa que nos da muchísimas cosas ya hechas, como un panel de administración, un sistema para hablar con la base de datos (ORM) y herramientas de seguridad.

### C. ¿Qué es Docker? Una "Caja Mágica" para tu Aplicación

Imagina que cocinas un plato increíble. Si quieres que un amigo lo pruebe exactamente igual, lo ideal sería meterlo en un tupper mágico que no solo contenga la comida, sino también el plato, los cubiertos y hasta el aire de tu cocina.

**Docker** es ese "tupper mágico" para el software. Permite empaquetar una aplicación con **absolutamente todo lo que necesita para funcionar**: el código, las librerías, las configuraciones, etc. A este paquete lo llamamos **contenedor (container)**.

Esto resuelve para siempre el problema de "¡en mi ordenador sí funciona!", ya que el entorno es siempre idéntico. Para este proyecto, usamos **Docker Desktop**, que es la aplicación que te permite gestionar contenedores fácilmente en tu ordenador.

---

## 3. Guía de Instalación y Primer Uso

### A. Requisitos e Instalación

1.  **Instalar Git:** Necesario para descargar el proyecto. Puedes descargarlo desde [git-scm.com](https://git-scm.com/downloads).
2.  **Instalar Docker Desktop:** Es la herramienta que ejecutará nuestro entorno.
    -   Descárgala desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
    -   La instalación requiere permisos de administrador. En Windows, asegúrate de que la opción para usar WSL2 esté seleccionada.
3.  **Clonar el Repositorio:**
    ```bash
    git clone https://github.com/dvarrui/django-persistencia.git
    cd django-persistencia
    ```

### B. Uso del Proyecto con Makefile

Hemos creado un `Makefile` que simplifica enormemente el uso de Docker.

#### Arranque del Proyecto
Este es el único comando que necesitas para poner todo en marcha:
```bash
make up
```
Este comando construirá las imágenes, instalará dependencias, iniciará los contenedores y preparará la base de datos.

#### Acceder a la Aplicación
-   **Aplicación web:** [http://localhost:8000](http://localhost:8000)
-   **Panel de Administración:** [http://localhost:8000/admin](http://localhost:8000/admin) (Credenciales en `_env/devel.env`)

#### Parar el Proyecto
Para detener todos los contenedores y **eliminar los datos de la base de datos**:
```bash
make down
```

### C. Comandos del Makefile Disponibles
-   `make build`: Construye las imágenes de Docker.
-   `make up`: Arranca los servicios.
-   `make down`: Detiene y elimina los contenedores y datos.
-   `make logs`: Muestra los logs en tiempo real.
-   `make shell`: Abre una terminal dentro del contenedor del servidor.
-   `make lint`: Revisa la calidad del código con `Ruff`.
-   `make lint-fix`: Intenta corregir errores de código automáticamente.

---

## 4. Anatomía del Proyecto

### A. Creación del Proyecto (Desde Cero)

Para entender la estructura, es útil saber que el esqueleto del proyecto se creó con dos comandos fundamentales:

1.  `django-admin startproject django_persistencia .`: Crea el directorio de configuración del proyecto.
2.  `python manage.py startapp app`: Crea la aplicación `app/` donde vivirá nuestra lógica.

### B. Estructura de Ficheros Clave

-   **`Makefile`**: Contiene los atajos (`make up`, `make lint`, etc.) para gestionar el proyecto.
-   **`requirements.txt`**: La lista de librerías de Python que necesita el proyecto.
-   **`docker-compose.yml`**: El "director de orquesta" que define los servicios (servidor y base de datos) y cómo se comunican.
-   **`docker-entrypoint.sh`**: Script que se ejecuta al iniciar el contenedor para preparar el entorno (migraciones, etc.).
-   **`_env/devel.env`**: Fichero con la configuración de entorno (contraseñas, `SECRET_KEY`, etc.).
-   **`django_persistencia/`**: El directorio del proyecto Django.
    -   `settings.py`: El panel de control central de Django.
    -   `urls.py`: El recepcionista que dirige las peticiones a la vista correcta.
-   **`app/`**: Tu aplicación. Aquí es donde escribirás la mayor parte de tu código.
    -   `models.py`: ¡El fichero clave para la persistencia! Defines tus datos con clases de Python.
    -   `views.py`: La sala de máquinas, donde vive la lógica de tu aplicación.
    -   `admin.py`: Permite que tus modelos aparezcan en el panel de administración.

### C. Ejecución Local (Sin Docker - Avanzado)

Si prefieres no usar Docker, puedes configurar un entorno local. Necesitarás tener Python y MySQL instalados.

1.  **Crear y activar un entorno virtual:** `python -m venv venv` y luego `source venv/bin/activate`.
2.  **Instalar dependencias:** `pip install -r requirements.txt`.
3.  **Configurar variables de entorno:** Deberás crear un fichero `.env` para que Django conecte con tu BD local.
4.  **Ejecutar migraciones y arrancar el servidor:** `python manage.py migrate` y `python manage.py runserver`.