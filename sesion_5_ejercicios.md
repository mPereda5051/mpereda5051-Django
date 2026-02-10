# Sesión 5: Creando un Cliente Web con HTML y JavaScript (AJAX)

¡Bienvenido a la sesión 5! Hasta ahora, hemos construido y probado nuestra API usando herramientas de backend como `cURL`. Hoy, daremos un paso más allá y construiremos una interfaz de usuario (un "cliente") con HTML y JavaScript que consuma nuestra API.

Aprenderemos a hacer peticiones HTTP desde el navegador sin recargar la página, una técnica conocida como **AJAX** (*Asynchronous JavaScript and XML*), usando la moderna API `fetch`.

**Objetivos de hoy:**
1.  Servir una página HTML desde una vista de Django.
2.  Usar la API `fetch` de JavaScript para hacer peticiones `GET` y `POST`.
3.  Manipular el DOM (la estructura HTML) para mostrar datos dinámicamente.
4.  Interceptar eventos de formulario para comunicarnos con nuestra API sin recargar la página.

---

## 1. Ejercicio: Servir la Página HTML Principal

Primero, necesitamos que Django sirva un fichero HTML vacío que será el lienzo para nuestra aplicación.

### 1.1. Crear el Directorio de Plantillas

Por convención, Django busca los ficheros HTML (plantillas) dentro de un directorio llamado `templates` en cada app. Y dentro de ese, se suele crear otro directorio con el nombre de la app para evitar colisiones.

**Acción:** Crea la siguiente estructura de directorios:
```
app/
└── templates/
    └── app/
```
Puedes usar los comandos `mkdir -p app/templates/app`.

### 1.2. Crear la Plantilla `pizzas.html`

**Acción:** Crea el fichero `app/templates/app/pizzas.html` con este contenido:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pizzería Django</title>
    <style>
        body { font-family: sans-serif; padding: 2em; }
        form { margin-top: 2em; border-top: 1px solid #ccc; padding-top: 1em; }
        ul { list-style-type: none; padding: 0; }
        li { margin-bottom: 0.5em; }
    </style>
</head>
<body>
    <h1>Nuestras Pizzas</h1>
    <ul id="pizza-list">
        <!-- Las pizzas se cargarán aquí con JavaScript -->
    </ul>

    <form id="create-pizza-form">
        <h2>Crear Nueva Pizza</h2>
        <label for="nombre">Nombre:</label>
        <input type="text" id="nombre" name="nombre" required>
        <br><br>
        <label for="precio">Precio:</label>
        <input type="number" id="precio" name="precio" step="0.01" required>
        <br><br>
        <button type="submit">Crear Pizza</button>
    </form>

    <script>
        // Nuestro código JavaScript irá aquí
    </script>
</body>
</html>
```

### 1.3. Crear la Vista para el Frontend

**Acción:** Añade esta nueva vista al final de `app/views.py`. Su única misión es mostrar el HTML.

```python
# Al final de app/views.py
from django.shortcuts import render

def frontend_view(request):
    return render(request, 'app/pizzas.html')
```

### 1.4. Crear la URL para el Frontend

**Acción:** Añade la ruta para la nueva vista en `app/urls.py`.

```python
# en app/urls.py
# ... (las otras importaciones)
urlpatterns = [
    path('frontend/', views.frontend_view, name='frontend_view'), # ¡Línea nueva!
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
    path('pizzas/<int:pk>/', views.pizza_detail_view, name='pizza_detail_view'),
]
```

**¡Prueba inicial!** Guarda los cambios, y visita `http://localhost:8000/frontend/` en tu navegador. Deberías ver la página HTML estática.

---

## 2. Ejercicio: Cargar la Lista de Pizzas (`GET` con `fetch`)

Ahora, haremos que la página cobre vida.

### 2.1. Escribir el script para obtener los datos

**Acción:** Reemplaza el comentario `// Nuestro código JavaScript irá aquí` en `pizzas.html` con el siguiente código:

```javascript
document.addEventListener('DOMContentLoaded', () => {
    const pizzaList = document.getElementById('pizza-list');

    // Función para obtener y mostrar las pizzas
    async function fetchPizzas() {
        // Limpiamos la lista antes de volver a pintarla
        pizzaList.innerHTML = '';

        const response = await fetch('/pizzas/');
        const data = await response.json();

        data.pizzas.forEach(pizza => {
            const li = document.createElement('li');
            li.textContent = `${pizza.nombre} - ${pizza.precio}€ (${pizza.estado})`;
            pizzaList.appendChild(li);
        });
    }

    // Cargar las pizzas al iniciar la página
    fetchPizzas();
});
```

**Explicación:**
- `DOMContentLoaded`: Nos aseguramos de que el script se ejecute solo cuando todo el HTML ha sido cargado.
- `async function / await`: Es la forma moderna de manejar código asíncrono (como peticiones de red) en JavaScript.
- `fetch('/pizzas/')`: Lanza la petición `GET` a nuestra API.
- `response.json()`: Convierte la respuesta JSON en un objeto de JavaScript.
- `forEach` y `document.createElement`: Recorremos los datos y creamos elementos HTML para mostrarlos en la página.

**Acción:** Recarga la página `http://localhost:8000/frontend/` en tu navegador. ¡Ahora deberías ver la lista de pizzas que tengas en tu base de datos!

---

## 3. Ejercicio: Crear Pizzas desde el Formulario (`POST` con `fetch`)

### 3.1. Interceptar el envío del formulario

**Acción:** Añade el siguiente código dentro del `DOMContentLoaded`, después de la llamada a `fetchPizzas()`.

```javascript
// ... dentro del addEventListener('DOMContentLoaded', ...)

const pizzaForm = document.getElementById('create-pizza-form');

pizzaForm.addEventListener('submit', async (event) => {
    // Prevenimos el comportamiento por defecto del formulario (recargar la página)
    event.preventDefault();

    // Usamos FormData para recoger fácilmente los datos del formulario
    const formData = new FormData(pizzaForm);

    const response = await fetch('/pizzas/', {
        method: 'POST',
        body: formData // No necesitamos cabeceras, FormData las gestiona
    });

    if (response.ok) {
        // Si la pizza se creó con éxito, refrescamos la lista y limpiamos el formulario
        fetchPizzas();
        pizzaForm.reset();
    } else {
        // Mostramos un error si algo fue mal
        const errorData = await response.json();
        alert('Error al crear la pizza: ' + JSON.stringify(errorData));
    }
});
```

**Explicación:**
- `event.preventDefault()`: Esta es la línea clave que evita que la página se recargue.
- `new FormData(pizzaForm)`: Un objeto que captura automáticamente todos los valores de los campos del formulario.
- `fetch('/pizzas/', { method: 'POST', body: formData })`: Hacemos la petición `POST`, enviando los datos del formulario en el cuerpo (`body`).

**Acción:** Recarga la página. Ahora intenta crear una pizza usando el formulario. Deberías ver cómo la lista se actualiza instantáneamente sin que la página parpadee.

---
¡Felicidades! Has construido una aplicación de página única (Single Page Application o SPA) muy simple que consume una API de Django.
