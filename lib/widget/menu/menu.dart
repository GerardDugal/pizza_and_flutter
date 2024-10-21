import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'dart:math';

final Random random = Random();

List<Map<String, dynamic>> categorizedMenu = [
  {
    'category_name': 'Пицца',
    'category_id': 10659,
    'items': []
  },
  {
    'category_name': 'Закуски',
    'category_id': 10661,
    'items': []
  },
  {
    'category_name': 'Холодные напитки',
    'category_id': 10666,
    'items': []
  },
  {
    'category_name': 'Горячие напитки',
    'category_id': 10660,
    'items': []
  },
  // {
  //   'category_name': 'График работы',
  //   'category_id': 10953,
  //   'items': []
  // },
  // {
  //   'category_name': 'ДОПОЛНИТЕЛЬНОЕ МЕНЮ',
  //   'category_id': 11381,
  //   'items': []
  // },
  // {
  //   'category_name': 'Выбери еще...  (50 грамм)',
  //   'category_id': 11861,
  //   'items': []
  // },
  // {
  //   'category_name': 'Дополнительные начинки (100г)',
  //   'category_id': 11862,
  //   'items': []
  // },
  // {
  //   'category_name': 'епрст',
  //   'category_id': 11943,
  //   'items': []
  // },
  // {
  //   'category_name': 'Владельцам Андроид',
  //   'category_id': 12146,
  //   'items': []
  // },
  {
    'category_name': 'Салфетки',
    'category_id': 12144,
    'items': []
  },
];
