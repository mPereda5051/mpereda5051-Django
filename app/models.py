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
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    fecha_fabricacion = models.DateField(auto_now_add=True)
    estado = models.CharField(
        max_length=3,
        choices=ESTADOS_PIZZA,
        default='DIS',
    )
    toppings = models.ManyToManyField(Topping)

    def __str__(self):
        return self.nombre
