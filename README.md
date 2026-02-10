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

## 2. Configuración del Entorno Local

Aunque el proyecto se ejecuta con Docker, algunas herramientas de calidad de código (como el linter `Ruff`) se ejecutan localmente. Para ello, es fundamental crear un **entorno virtual** de Python y tener las dependencias instaladas.

### A. Crear y Activar un Entorno Virtual

Un entorno virtual aísla las dependencias de este proyecto de otros que tengas en tu sistema.

-   **En macOS o Linux (Terminal):**
    ```bash
    # Crear el entorno (solo la primera vez)
    python3 -m venv venv
    # Activar el entorno (cada vez que abras una nueva terminal)
    source venv/bin/activate
    ```

-   **En Windows:**
    ```bash
    # 1. Crear el entorno (solo la primera vez)
    python -m venv venv
    ```
    ```bash
    # 2. Activar el entorno (depende de tu terminal)

    # Si usas la terminal clásica (CMD)
    .\venv\Scripts\activate.bat

    # Si usas PowerShell
    .\venv\Scripts\Activate.ps1
    ```
    > **¡Ojo en PowerShell!** Si al activar el entorno recibes un error sobre "la ejecución de scripts está deshabilitada", ejecuta primero este comando para permitirlo solo en tu sesión actual y luego vuelve a intentar la activación:
    > `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`

> **Nota sobre PyCharm:** Si abres el proyecto con PyCharm, el IDE normalmente detectará la ausencia de un entorno virtual y te ofrecerá crear uno automáticamente. Este proceso es equivalente a los comandos anteriores.

### B. Instalar Dependencias

Una vez que tengas el entorno virtual **activado** (verás `(venv)` al principio de la línea de tu terminal), instala las librerías necesarias:
```bash
pip install -r requirements.txt
```
Este comando instalará Django, `Ruff` y otras herramientas en tu entorno virtual, dejándote listo para usar comandos como `make lint`.

---

## 3. Guía de Inicio Rápido (Docker)

Con el entorno local ya configurado para las herramientas, el siguiente paso es arrancar la aplicación con Docker.

1.  **Crear tu repositorio desde esta plantilla:**
    -   En la parte superior de la página de GitHub, haz clic en el botón verde **"Use this template"**.
    -   Selecciona **"Create a new repository"**.
    -   **¡Importante!** Asegúrate de marcar la casilla **"Include all branches"** para copiar todas las ramas del proyecto (como `iniciacion`).
    -   Dale un nombre a tu nuevo repositorio y haz clic en **"Create repository"**. ¡Ya tienes tu propia copia!

2.  **Clonar tu nuevo repositorio:**
    Ahora, descarga el código de **tu repositorio** a tu ordenador.
    ```bash
    git clone https://github.com/<TU_USUARIO_DE_GITHUB>/<NOMBRE_DE_TU_NUEVO_REPO>.git
    cd <NOMBRE_DE_TU_NUEVO_REPO>
    ```

3.  **Arrancar los servicios:**
    Este único comando construirá las imágenes la primera vez y arrancará el servidor de Django y la base de datos. Recuerda que Docker Desktop debe estar arrancado.

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

## 4. Comandos Disponibles (`make` / `./make.bat`)

Para ejecutar un comando, usa `make <comando>` en macOS/Linux, o `make.bat <comando>` en Windows.

-   **`build`**: Construye o reconstruye las imágenes de Docker.
-   **`up`**: Arranca todos los servicios en segundo plano.
-   **`down`**: Detiene y elimina los contenedores, redes y volúmenes.
-   **`logs`**: Muestra los logs de los servicios en tiempo real.
-   **`shell`**: Abre una terminal (`bash`) dentro del contenedor del servidor.
-   **`lint`**: Revisa la calidad del código con `Ruff` (requiere el entorno virtual activado).
-   **`lint-fix`**: Intenta corregir automáticamente los errores de `linting`.
