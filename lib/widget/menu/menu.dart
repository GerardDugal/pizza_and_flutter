import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'dart:math';

final Random random = Random();

int getRandomPrice() {
  return random.nextInt(901) + 100; // Генерация случайной цены от 100 до 1000
}

int getRandomWeight() {
  return random.nextInt(1301) + 200; // Генерация случайной граммовки от 200 до 1500
}

// List<Map<String, dynamic>> categorizedMenu = [
//   {
//     'category': 'Пицца',
//     'items': [
//       Dishes(
//         dish_name: "Пицца с помидорами черри",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Классическая пицца с томатным соусом и свежей моцареллой.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         filling: const [],
//         additional_filling: [],
//       ),
//       Dishes(
//         dish_name: "Пепперони",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Пицца с пикантной колбасой пепперони и сыром.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Тесто": 0},
//           {"Сыр": 0},
//           {"Томатный соус": 0}
//         ],
//         additional_filling: [
//           {"Пепперони": 70},
//           {"Грибы": 40},
//           {"Перец": 30}
//         ],
//       ),
//       Dishes(
//         dish_name: "Четыре сыра",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Нежная пицца с четырьмя видами сыра.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Тесто": 0},
//           {"Моцарелла": 0},
//           {"Горгонзола": 0},
//           {"Пармезан": 0},
//           {"Чеддер": 0},
//         ],
//         additional_filling: [
//           {"Мед": 20},
//           {"Базилик": 15},
//           {"Оливковое масло": 10}
//         ],
//       ),
//     ]
//   },
//   {
//     'category': 'Горячие закуски',
//     'items': [
//       Dishes(
//         dish_name: "Крылья Баффало",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Острые куриные крылышки в соусе Баффало.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         filling: const [
//           {"Курица": 0},
//           {"Чесночный соус": 0},
//         ],
//         additional_filling: [
//           {"Соус Баффало": 50},
//           {"Сельдерей": 10},
//           {"Картофель фри": 100}
//         ],
//       ),
//       Dishes(
//         dish_name: "Сырные палочки",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Палочки с расплавленным сыром и хрустящей корочкой.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Сыр": 0},
//           {"Тесто": 0},
//         ],
//         additional_filling: [
//           {"Чили соус": 30},
//           {"Кетчуп": 20},
//           {"Майонез": 20}
//         ],
//       ),
//       Dishes(
//         dish_name: "Мини-бургеры",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Нежные мини-бургеры с мясом и свежими овощами.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Говядина": 0},
//           {"Булочка": 0},
//           {"Листья салата": 0}
//         ],
//         additional_filling: [
//           {"Курица": 70},
//           {"Соус": 20},
//           {"Помидор": 10}
//         ],
//       ),
//     ]
//   },
//   {
//     'category': 'Гриль',
//     'items': [
//       Dishes(
//         dish_name: "Шашлык из курицы",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Сочное мясо курицы, запеченное на гриле.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Курица": 0},
//           {"Специи": 0},
//         ],
//         additional_filling: [
//           {"Лимон": 20},
//           {"Зеленый лук": 10},
//           {"Соус": 30}
//         ],
//       ),
//       Dishes(
//         dish_name: "Гриль-овощи",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Ассорти из свежих овощей, запеченных на гриле.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Овощи": 0},
//           {"Специи": 0},
//         ],
//         additional_filling: [
//           {"Оливковое масло": 10},
//           {"Бальзамический уксус": 15}
//         ],
//       ),
//       Dishes(
//         dish_name: "Стейк из говядины",
//         price: getRandomPrice(),
//         weight: getRandomWeight(),
//         description: "Сочный стейк, приготовленный до идеальной степени прожарки.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [
//           {"Говядина": 0},
//           {"Специи": 0},
//         ],
//         additional_filling: [
//           {"Соус": 30},
//           {"Картофель": 50},
//           {"Салат": 15}
//         ],
//       ),
//     ]
//   },
//   {
//     'category': 'Напитки',
//     'items': [
//       Dishes(
//         dish_name: "Коктейль «Мохито»",
//         price: getRandomPrice(),
//         weight: 500,
//         description: "Освежающий коктейль с мятой и лаймом.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [],
//         additional_filling: [
//           {"Мята": 5},
//           {"Лайм": 10},
//           {"Сахар": 5}
//         ],
//       ),
//       Dishes(
//         dish_name: "Лимонад",
//         price: getRandomPrice(),
//         weight: 500,
//         description: "Домашний лимонад из свежих лимонов.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [],
//         additional_filling: [
//           {"Лимон": 10},
//           {"Сахар": 15}
//         ],
//       ),
//       Dishes(
//         dish_name: "Кофе Эспрессо",
//         price: getRandomPrice(),
//         weight: 250,
//         description: "Крепкий кофе с насыщенным вкусом.",
//         picture: Image.asset(
//           'images/pizza_menu.png',
//           fit: BoxFit.contain,
//           width: double.infinity,
//         ),
//         with_fillings: true,
//         filling: const [],
//         additional_filling: [
//           {"Молоко": 20},
//           {"Сахар": 5}
//         ],
//       ),
//     ]
//   },
// ];
