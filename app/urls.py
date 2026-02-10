# en app/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('pizzas/', views.pizzas_view, name='pizzas_view'),
    path('pizzas/<int:pk>/', views.pizza_detail_view, name='pizza_detail_view'),
]
