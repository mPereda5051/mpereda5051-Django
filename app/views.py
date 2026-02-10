from django.http import JsonResponse
from .models import Pizza
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def pizzas_view(request):
    if request.method == 'GET':
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
        # Creamos una pizza con los datos del POST
        # Ojo: esto es una simplificación, no hay validación de datos
        nombre = request.POST.get('nombre')
        precio = request.POST.get('precio')
        
        if not nombre or not precio:
            return JsonResponse({'error': 'Faltan nombre o precio'}, status=400)

        pizza = Pizza.objects.create(nombre=nombre, precio=precio)
        
        # Gestionar la relación ManyToMany para los toppings
        topping_ids = request.POST.getlist('toppings')
        if topping_ids:
            pizza.toppings.set(topping_ids)
        
        # Devolvemos la pizza creada
        return JsonResponse({
            'message': 'Pizza creada con éxito',
            'pizza': {
                'id': pizza.id,
                'nombre': pizza.nombre,
                'precio': str(pizza.precio),
                'estado': pizza.get_estado_display(),
            }
        }, status=201)

    return JsonResponse({'error': 'Método no soportado'}, status=405)
