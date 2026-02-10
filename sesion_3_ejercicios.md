# Sesión 3: Vistas y Serialización (API con Django Puro)

En esta sesión analizaremos cómo se ha construido una "API" (Interfaz de Programación de Aplicaciones) para interactuar con nuestros modelos a través de HTTP. En lugar de páginas HTML, nuestras vistas devolverán datos en formato JSON, el lenguaje universal de la web moderna.

**Objetivos de hoy:**
1.  Analizar cómo se estructura un endpoint de API que maneja `GET` y `POST`.
2.  Entender el proceso de "serialización": convertir un objeto de Django en JSON.
3.  Comprender cómo gestionar la seguridad (CSRF) en una API.
4.  Aplicar lo aprendido para crear un nuevo endpoint de API desde cero.

---

## 1. Análisis del Endpoint `/pizzas/`

En el proyecto ya existe un endpoint funcional en la URL `/pizzas/`. Vamos a diseccionar cómo está construido.

### 1.1. La Arquitectura: De la URL a la Vista

El flujo de una petición en Django sigue un camino claro:

**1. El enrutador principal (`django_persistencia/urls.py`):**
Este fichero delega el control a nuestra aplicación. La línea `path('', include('app.urls'))` le dice a Django: "para cualquier URL, busca las reglas en el fichero `urls.py` de la aplicación `app`".

**2. El enrutador de la app (`app/urls.py`):**
Aquí se define la ruta específica de nuestro endpoint.
```python
# en app/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
]
```
Esta línea conecta la URL `/pizzas/` con la función `pizzas_view` que se encuentra en `app/views.py`.

### 1.2. El Corazón de la Lógica: `app/views.py`

Aquí es donde ocurre toda la magia. Este es el código completo que da vida a nuestro endpoint:

```python
# en app/views.py
from django.http import JsonResponse
from .models import Pizza, Topping
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def pizzas_view(request):
    if request.method == 'GET':
        # Lógica para obtener la lista de pizzas
        pizzas = Pizza.objects.all()
        data = []
        for pizza in pizzas:
            data.append({
                'id': pizza.id,
                'nombre': pizza.nombre,
                'precio': str(pizza.precio),
                'estado': pizza.get_estado_display(),
            })
        return JsonResponse({'pizzas': data})

    if request.method == 'POST':
        # Lógica para crear una nueva pizza
        nombre = request.POST.get('nombre')
        precio = request.POST.get('precio')
        
        if not nombre or not precio:
            return JsonResponse({'error': 'Faltan nombre o precio'}, status=400)

        pizza = Pizza.objects.create(nombre=nombre, precio=precio)
        
        topping_ids = request.POST.getlist('toppings')
        if topping_ids:
            pizza.toppings.set(topping_ids)
        
        return JsonResponse({
            'message': 'Pizza creada con éxito',
            'pizza': { 'id': pizza.id, 'nombre': pizza.nombre, 'precio': str(pizza.precio) }
        }, status=201)

    return JsonResponse({'error': 'Método no soportado'}, status=405)
```

**Análisis detallado:**
-   **`@csrf_exempt`**: Este "decorador" es crucial. Django tiene una protección de seguridad llamada CSRF para evitar ataques a través de formularios web. Como nuestra API no usa formularios, debemos indicarle explícitamente que no realice esta comprobación. Sin esto, cualquier petición `POST` fallaría con un error 403.
-   **`if request.method == 'GET':`**: Esta es la forma de separar la lógica para peticiones de lectura.
    -   `Pizza.objects.all()`: Se utiliza el ORM para obtener todos los objetos `Pizza`.
    -   **Serialización manual:** El bucle `for` convierte cada objeto `pizza` (que Python no sabe cómo hacer JSON) en un diccionario, que es una estructura que sí se puede traducir fácilmente. Este proceso se llama **serialización**.
    -   `JsonResponse`: Es una clase especial de Django que se encarga de convertir el diccionario de Python en una respuesta HTTP con el `Content-Type` correcto (`application/json`).
-   **`if request.method == 'POST':`**: Aquí se gestiona la creación de nuevos recursos.
    -   `request.POST.get('nombre')`: Se extraen los datos enviados en el cuerpo de la petición.
    -   `Pizza.objects.create(...)`: El ORM se encarga de crear el nuevo registro en la base de datos de forma segura.
    -   `pizza.toppings.set(...)`: Así se gestiona una relación `ManyToManyField`. Le pasamos una lista de IDs de los toppings y Django se encarga de crear las relaciones en la tabla intermedia.
    -   `status=201`: Es una buena práctica de las APIs devolver el código de estado `201 Created` para indicar que un recurso se ha creado con éxito.

### 1.3. Verificación con cURL

Podemos usar la herramienta de línea de comandos `cURL` para interactuar con nuestra API ya funcional.

1.  **Probar `GET`:**
    ```bash
    curl http://localhost:8000/pizzas/
    ```
    Esto nos devolverá la lista de pizzas que haya en la base de datos.

2.  **Probar `POST` (Crear una Pizza):**
    Primero, necesitamos saber los IDs de algunos toppings. Podemos usar el shell de Django (`docker-compose exec servidor python manage.py shell`) para crearlos si no existen.
    Luego, lanzamos la petición:
    ```bash
    curl -X POST -d "nombre=Barbacoa&precio=12.50&toppings=1&toppings=3" http://localhost:8000/pizzas/
    ```
    Si todo va bien, recibiremos un JSON confirmando la creación.

---

## 2. Ejercicio Práctico: Creación de la API de Toppings

Ahora es vuestro turno. Aplicando lo que hemos analizado, vuestra tarea es construir un endpoint completo en `/toppings/`.

**Vuestro objetivo:** Crear una vista `toppings_view` que, al igual que `pizzas_view`, sea capaz de gestionar peticiones `GET` y `POST`.

### 2.1. Diseña y construye la vista

Dentro de `app/views.py`, crea una nueva función `toppings_view`. Piensa en las siguientes preguntas:

*   ¿Qué decorador necesitarás si quieres que tu vista acepte peticiones `POST` desde `cURL`?
*   **Para la lógica `GET`:**
    *   ¿Qué comando del ORM usarías para obtener todos los toppings?
    *   ¿Cómo serializarías la lista de toppings a un formato JSON? ¿Qué campos del modelo `Topping` te gustaría mostrar?
*   **Para la lógica `POST`:**
    *   ¿Cómo accederías al `nombre` y `es_vegetariano` enviados en la petición?
    *   El valor de `es_vegetariano` llegará como un string (`'True'` o `'False'`). ¿Cómo lo convertirías a un booleano de Python (`True` o `False`) antes de crear el objeto?
    *   ¿Qué método del ORM usarías para crear el nuevo `Topping` en la base de datos?

### 2.2. Conecta la URL

En `app/urls.py`, añade una nueva ruta para que la URL `/toppings/` apunte a la vista que acabas de crear.

### 2.3. ¡Pruébalo!

Escribe y ejecuta tus propios comandos de `cURL` para:
1.  Crear un nuevo topping (ej: Champiñones) usando el método `POST`.
2.  Verificar que el nuevo topping aparece en la lista al hacer una petición `GET`.

¡Buena suerte!
