# Proyecto Django - Persistencia

## Descripción

Este proyecto está diseñado para **fines educativos**. Su objetivo es servir como una base robusta y bien estructurada para aprender a desarrollar aplicaciones web con Django, poniendo especial énfasis en la persistencia de datos con una base de datos real (MySQL) y el uso de Docker para crear un entorno de desarrollo consistente.

La estructura del proyecto sigue las mejores prácticas de la comunidad de Django, incorporando herramientas modernas como `Docker`, `Ruff` y `Makefile` para crear un entorno de desarrollo profesional y fácil de usar.

## Características

-   Framework: Django 4.2.27
-   Base de datos: MySQL 8.0
-   Entorno de desarrollo: Contenerizado con Docker y Docker Compose
-   Calidad de código: Linter `Ruff` preconfigurado.
-   Automatización: `Makefile` y `make.bat` con comandos para las operaciones más comunes.

---

## 1. Requisitos Previos

Antes de empezar, asegúrate de tener las siguientes herramientas instaladas.

### Docker Desktop

Docker es la plataforma que nos permitirá ejecutar el proyecto dentro de contenedores, garantizando un entorno consistente.

-   **Para Windows (10/11):**
    -   Descarga e instala Docker Desktop desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
    -   La instalación requiere permisos de administrador y que tengas WSL2 activado.
-   **Para macOS (Intel/Apple Silicon):**
    -   Descarga e instala Docker Desktop desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
    -   Sigue las instrucciones del instalador.

---

## 2. Guía de Inicio Rápido

El primer paso es crear tu propia copia de este proyecto para poder trabajar de forma independiente.

1.  **Crear tu repositorio desde esta plantilla:**
    -   En la parte superior de la página de GitHub, haz clic en el botón verde **"Use this template"**.
    -   Selecciona **"Create a new repository"**.
    -   **¡Importante!** Asegúrate de marcar la casilla **"Include all branches"** para copiar todas las ramas del proyecto (como `iniciacion`).
    -   Dale un nombre a tu nuevo repositorio y haz clic en **"Create repository"**. ¡Ya tienes tu propia copia!

2.  **Clonar tu nuevo repositorio:**
    Ahora, descarga el código de **tu repositorio** a tu ordenador. Reemplaza `<TU_USUARIO_DE_GITHUB>` por tu nombre de usuario.
    ```bash
    git clone https://github.com/<TU_USUARIO_DE_GITHUB>/<NOMBRE_DE_TU_NUEVO_REPO>.git
    cd <NOMBRE_DE_TU_NUEVO_REPO>
    ```

3.  **Arrancar los servicios:**
    Este único comando construirá las imágenes la primera vez y arrancará el servidor de Django y la base de datos. Recuerda que Docker Desktop debe estar arrancado y el servicio corriendo.

    -   **En macOS o Linux:**
        ```bash
        make up
        ```
    -   **En Windows:**
        ```bash
        ./make.bat up
        ```

4.  **Acceder a la aplicación:**
    -   Abre tu navegador en [http://localhost:8000](http://localhost:8000)
    -   Accede al panel de administración en [http://localhost:8000/admin](http://localhost:8000/admin) (las credenciales por defecto son `admin`/`admin`).

---

## 3. Comandos Disponibles (`make` / `make.bat`)

Para ejecutar un comando, usa `make <comando>` en macOS/Linux, o `make.bat <comando>` en Windows.

-   **`build`**: Construye o reconstruye las imágenes de Docker. Útil si cambias `requirements.txt` o `Dockerfile`.
-   **`up`**: Arranca todos los servicios en segundo plano.
-   **`down`**: Detiene y elimina los contenedores, redes y volúmenes (¡borra los datos de la BD!).
-   **`logs`**: Muestra los logs de los servicios en tiempo real.
-   **`shell`**: Abre una terminal (`bash`) dentro del contenedor del servidor.
-   **`lint`**: Revisa la calidad del código con `Ruff` (se ejecuta localmente).
-   **`lint-fix`**: Intenta corregir automáticamente los errores de `linting`.
