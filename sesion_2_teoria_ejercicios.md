# Sesión 2: Modelos y Persistencia - Análisis de un Proyecto Existente

En esta sesión, actuaremos como nuevos desarrolladores que se unen a un proyecto de Django ya en marcha. En lugar de crear todo desde cero, nuestro objetivo es entender la estructura de datos existente, cómo ha evolucionado y cómo Django gestiona la coherencia entre el código y la base de datos.

**Objetivos de hoy:**
1.  Analizar los modelos de datos ya creados en el proyecto.
2.  Entender el propósito del directorio de `migrations` como un "historial de cambios" de la base de datos.
3.  Comprender por qué la base de datos se configura "mágicamente" de forma correcta al iniciar el proyecto.
4.  Aplicar lo aprendido creando un nuevo modelo desde cero.

---

## 1. Análisis de los "Planos": Los Modelos Existentes

Al explorar el proyecto, lo primero es abrir `app/models.py`. Este fichero es la **fuente de la verdad** sobre la estructura de datos de nuestra aplicación. En él, encontramos dos clases ya definidas:

```python
from django.db import models

class Topping(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    es_vegetariano = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre

# Constante para los estados de la Pizza
ESTADOS_PIZZA = [
    ('DIS', 'Disponible'),
    ('PRO', 'Promoción'),
    ('PRG', 'Programada'),
    ('CAN', 'Cancelada'),
]

class Pizza(models.Model):
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=10, decimal_places=2) # OJO: max_digits es 10
    fecha_fabricacion = models.DateField(auto_now_add=True)
    estado = models.CharField(
        max_length=3,
        choices=ESTADOS_PIZZA,
        default='DIS',
    )
    toppings = models.ManyToManyField(Topping)

    def __str__(self):
        return self.nombre
```

**Conclusiones del análisis:**
*   Tenemos dos entidades principales: `Topping` y `Pizza`.
*   Se usan campos de varios tipos: `CharField` para texto, `BooleanField` para sí/no, `DecimalField` para precios (muy importante para evitar errores de redondeo) y `DateField` para fechas.
*   **Relación Muitos-a-Muitos (`ManyToManyField`):** Una pizza puede tener muchos toppings y un topping puede estar en muchas pizzas. Django gestionará esto creando una tabla intermedia invisible para nosotros en el código, pero que existirá en la base de datos.

---

## 2. El "Libro de Registro": El Historial en `app/migrations/`

El directorio `app/migrations/` contiene la historia de cómo nuestros modelos han evolucionado. Cada fichero es una "fotografía" de un cambio. En nuestro proyecto encontramos:
*   `0001_initial.py`: Este fichero fue generado la primera vez que se ejecutó `python manage.py makemigrations`. Contiene las instrucciones para **crear** las tablas `Topping` y `Pizza` desde cero.
*   `0002_alter_pizza_precio.py`: Este fichero se generó después de que un desarrollador modificara el modelo `Pizza` (originalmente, el campo `precio` tenía `max_digits=5`). Contiene la instrucción para **alterar** la tabla existente y cambiar la definición de la columna `precio`.

Estos ficheros son la clave para que cualquier miembro del equipo pueda reconstruir la estructura de la base de datos de forma idéntica.

---

## 3. La "Magia": ¿Cómo se Construye la Base de Datos?

Cuando un nuevo desarrollador clona este repositorio y ejecuta `docker-compose up`, ocurre algo fundamental, definido en el fichero `docker-compose.yml`:
```yaml
command: sh -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
```
El comando `python manage.py migrate` se ejecuta **automáticamente** cada vez que arranca el servidor. ¿Qué hace `migrate`?

1.  Se conecta a la base de datos.
2.  Comprueba una tabla especial (`django_migrations`) para ver qué migraciones de los ficheros se han aplicado ya.
3.  Si encuentra ficheros de migración en `app/migrations/` que no están en esa tabla, los ejecuta en orden.

Para un desarrollador nuevo, ninguna migración estará aplicada. Por tanto, Django ejecutará `0001_initial.py` (creando las tablas) y luego `0002_alter_pizza_precio.py` (modificando el campo precio).

**El resultado final es que, con solo levantar los contenedores, la base de datos queda perfectamente sincronizada con el estado actual de los modelos, incluyendo toda su historia de cambios.**

---

## 4. Ejercicio Interactivo: ¡Tu Turno! Creando un Modelo Desde Cero

Ahora que hemos analizado un proyecto existente, es vuestro turno de hacerlo evolucionar.

**Escenario:** Nuestra pizzería necesita llevar un registro de sus **proveedores** de ingredientes.

**Vuestro objetivo:** Definir el modelo `Proveedor`, crear su migración y aplicarla.

### 4.1. Diseña el modelo

Abre `app/models.py` y piensa en cómo definiríais la clase `Proveedor`. Aquí tenéis algunas pistas sobre la información que necesitamos guardar:

*   **Nombre:** El nombre del proveedor (ej: "Harinas del Sur S.L.").
    *   *Pista: ¿Qué tipo de campo es ideal para texto con una longitud máxima?*
*   **Email de contacto:** Necesitamos un campo para el email que, además, valide que el formato es correcto.
    *   *Pista: Django tiene un campo específico para emails.*
    *   *Reto extra: ¿Cómo te asegurarías de que no haya dos proveedores con el mismo email?*
*   **Teléfono:** Un campo de texto simple para el número de teléfono. Este campo no siempre es obligatorio.
    *   *Pista: ¿Cómo le dirías a Django que este campo puede dejarse en blanco en un formulario?*
*   **Fecha de alta:** Queremos registrar automáticamente la fecha en la que añadimos el proveedor al sistema.
    *   *Pista: Ya hemos hecho esto en el modelo `Pizza`.*

Escribe la clase completa del modelo `Proveedor` al final de `app/models.py`.

### 4.2. Genera y aplica la migración

Una vez que tengáis el modelo definido en el código, ¿cuáles son los dos pasos (comandos) que debéis ejecutar para que Django cree la tabla en la base de datos?

1.  El comando para que Django **detecte los cambios** en `models.py` y cree el fichero de migración.
2.  El comando para que Django **aplique esa migración** a la base de datos.

Ejecutadlos en orden desde dentro del contenedor `servidor`.

### 4.3. (Bonus) Haz visible el modelo en el Panel de Administrador

Si has completado los pasos anteriores, la tabla `app_proveedor` ya existe en la base de datos, pero no puedes gestionarla desde el panel de administrador.

*   ¿Qué fichero tienes que modificar para que un modelo aparezca en el admin?
*   ¿Qué necesitas importar y qué línea de código tienes que añadir?

¡Inténtalo! Si lo consigues, podrás crear, ver y editar proveedores desde la interfaz web de Django.