# Sesión 4: Vistas de Detalle, Edición y Borrado (API)

En la sesión anterior analizamos un endpoint que gestionaba una **colección** de recursos (`/pizzas/`). Hoy completaremos el ciclo CRUD (Create, Read, Update, Delete) estudiando cómo interactuar con un **recurso específico** a través de su ID, como ver, modificar o borrar una pizza concreta.

**Objetivos de hoy:**
1.  Analizar cómo se captura un parámetro dinámico desde una URL (ej: `/pizzas/1/`).
2.  Entender cómo una sola vista puede manejar `GET` (detalle), `PUT` (actualización) y `DELETE` (borrado).
3.  Aprender a procesar un cuerpo de petición en formato JSON para las actualizaciones.
4.  Aplicar lo aprendido para construir un nuevo endpoint de detalle desde cero.

---

## 1. Análisis del Endpoint de Detalle (`/pizzas/<id>/`)

En el proyecto ya existe un endpoint que permite operar sobre una pizza específica. Vamos a analizar su construcción.

### 1.1. La URL Dinámica con Parámetros

El primer paso es la ruta. En `app/urls.py`, se ha añadido una nueva línea:
```python
# en app/urls.py
# ...
urlpatterns = [
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
    path('pizzas/<int:pk>/', views.pizza_detail_view, name='pizza_detail_view'), # ¡Línea Analizada!
]
```
**Análisis:**
-   `<int:pk>`: Esta es la sintaxis de Django para capturar un fragmento de la URL. Significa:
    -   `int`: Espera que esta parte sea un número entero.
    -   `pk`: El nombre que le damos a esa variable. Se pasará como un argumento con ese nombre a la vista (`def pizza_detail_view(request, pk):`).
-   `pk` es la abreviatura estándar de *Primary Key* (Clave Primaria), el identificador único de un registro en la base de datos.

### 1.2. La Vista "Todo en Uno": `pizza_detail_view`

Esta única función en `app/views.py` contiene toda la lógica para gestionar una pizza individual.

```python
# en app/views.py
from django.shortcuts import get_object_or_404 # ¡Importante!
# ... otras importaciones

@csrf_exempt
def pizza_detail_view(request, pk):
    # 1. Obtener el objeto es el primer paso, común a todos los métodos.
    pizza = get_object_or_404(Pizza, pk=pk)
    
    if request.method == 'GET':
        # 2. Lógica de Lectura (Detalle)
        data = {
            'id': pizza.id, 'nombre': pizza.nombre, 'precio': str(pizza.precio),
            'estado': pizza.get_estado_display(),
            'toppings': list(pizza.toppings.all().values('id', 'nombre')),
        }
        return JsonResponse(data)

    if request.method == 'PUT':
        # 3. Lógica de Actualización
        data = json.loads(request.body)
        pizza.nombre = data.get('nombre', pizza.nombre)
        pizza.precio = data.get('precio', pizza.precio)
        pizza.estado = data.get('estado', pizza.estado)
        
        if 'toppings' in data:
            pizza.toppings.set(data['toppings'])

        pizza.save()
        # Se devuelve el objeto actualizado
        return JsonResponse({'id': pizza.id, 'nombre': pizza.nombre, 'precio': str(pizza.precio)})

    if request.method == 'DELETE':
        # 4. Lógica de Borrado
        pizza.delete()
        return JsonResponse({}, status=204)

    return JsonResponse({'error': 'Método no soportado'}, status=405)
```

**Análisis detallado:**
1.  **`get_object_or_404(Pizza, pk=pk)`**: Este es el método más idiomático para obtener un objeto. Intenta hacer `Pizza.objects.get(pk=pk)`. Si no lo encuentra, en lugar de lanzar un error que pararía el programa, Django devuelve automáticamente una respuesta `404 Not Found`.
2.  **Lógica `GET`**: Similar a la vista de lista, pero solo serializamos el único objeto `pizza` que hemos obtenido. Para el campo `ManyToManyField`, `.toppings.all()` nos da los objetos Topping relacionados.
3.  **Lógica `PUT`**:
    -   `json.loads(request.body)`: A diferencia de `request.POST` (que lee datos de formulario), `request.body` contiene el cuerpo de la petición en bruto. Si el cliente nos envía JSON, debemos procesarlo con la librería `json`.
    -   `data.get('nombre', pizza.nombre)`: Usamos `.get()` con el valor actual del objeto como valor por defecto. Esto nos permite hacer actualizaciones parciales (a veces llamado `PATCH`).
    -   `pizza.save()`: Como el objeto `pizza` fue obtenido de la base de datos (ya tiene un `pk`), Django es lo suficientemente inteligente para saber que `save()` debe ejecutar un `UPDATE` en la base de datos, no un `INSERT`.
4.  **Lógica `DELETE`**:
    -   `pizza.delete()`: El ORM proporciona este método simple para eliminar el registro de la base de datos.
    -   `status=204`: Es el código de estado HTTP estándar para "No Content". Indica que la operación fue exitosa, pero no hay nada que devolver en el cuerpo de la respuesta.

### 1.3. Verificación con cURL

Podemos probar los 3 métodos en el endpoint que ya existe:
-   **Obtener detalle (GET):**
    ```bash
    curl http://localhost:8000/pizzas/1/
    ```
-   **Actualizar (PUT):**
    ```bash
    curl -X PUT -H "Content-Type: application/json" -d '{"nombre": "Margarita Clásica"}' http://localhost:8000/pizzas/1/
    ```
-   **Borrar (DELETE):**
    ```bash
    curl -X DELETE http://localhost:8000/pizzas/1/
    ```

---

## 2. Ejercicio Práctico: API de Detalle para Toppings

¡Tu turno! Ahora que has analizado el ciclo completo para una Pizza, tu misión es construir el endpoint de detalle para los `Toppings`, que vivirá en `/toppings/<id>/`.

**Vuestro objetivo:** Crear una vista `topping_detail_view` que maneje peticiones `GET`, `PUT` y `DELETE` para un topping específico.

### 2.1. Define la ruta

En `app/urls.py`, ¿qué nueva línea de `path` necesitas añadir para capturar la URL de detalle de un topping y dirigirla a una nueva vista `topping_detail_view`?

### 2.2. Construye la vista de detalle

En `app/views.py`, crea la función `topping_detail_view`. Hazte las siguientes preguntas para guiarte:

1.  ¿Qué argumentos debe recibir la función, además de `request`?
2.  ¿Cuál es la primera llamada que deberías hacer para obtener el objeto `Topping` o devolver un 404 si no existe?
3.  **Para la lógica `GET`**, ¿cómo serializarías un único objeto `Topping` a JSON?
4.  **Para la lógica `PUT`**, ¿cómo leerías los datos `JSON` del `request.body`? ¿Y cómo actualizarías los campos del objeto `Topping` antes de guardarlo?
5.  **Para la lógica `DELETE`**, ¿qué método del objeto `topping` deberías llamar y qué código de estado HTTP deberías devolver?

### 2.3. ¡Pruébalo!

Finalmente, escribe y ejecuta tus propios comandos de `cURL` para:
1.  Ver el detalle de un topping específico con `GET`.
2.  Actualizar el nombre de ese topping con `PUT`.
3.  Borrar ese topping de la base de datos con `DELETE`.
4.  Verificar con un `GET` a `/toppings/` que el topping ya no está en la lista.
