import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';

List<Map<String, dynamic>> categorizedMenu = [
  {
    'category': 'Пицца',
    'items': [
  Dishes(
    dish_name: "Пицца c хуй его знает",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    filling: const [],
    additional_filling: [],
  ),
  Dishes(
    dish_name: "Пицца конская залупа",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  ),
  Dishes(
    dish_name: "Пицца хер моржовый",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  )
]
  },
  {
    'category': 'Горячие закуски',
    'items': [
  Dishes(
    dish_name: "Крылья свиньи",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    filling: const [],
    additional_filling: [],
  ),
  Dishes(
    dish_name: "Куриные ребрышки",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  ),
  Dishes(
    dish_name: "Запеченный моржовый хер",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  )
]
  },
  {
    'category': 'Гриль',
    'items': [
  Dishes(
    dish_name: "Ебанина на грилле",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    filling: const [],
    additional_filling: [],
  ),
  Dishes(
    dish_name: "Конская залупа на огне",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  ),
  Dishes(
    dish_name: "Хер моржовый с ароматом дымка",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  )
]
  },
  {
    'category': 'Напитки',
    'items': [
  Dishes(
    dish_name: "Виски с колой",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    filling: const [],
    additional_filling: [],
  ),
  Dishes(
    dish_name: "Водичка из под крана",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  ),
  Dishes(
    dish_name: "Водка столичная",
    price: 666,
    weight: 1050,
    description: "Ебать какое пиздатое описание",
    picture: Image.asset('images/pizza_menu.png',
    fit: BoxFit.contain, // Масштабирование изображения по контейнеру
    width: double.infinity,),
    with_fillings: true,
    filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
    additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
  )
]
  },
];