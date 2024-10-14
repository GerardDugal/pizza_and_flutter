import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/bucket/bucket.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';
import 'package:provider/provider.dart';

List<Widget> ListMenu = [
  Dishes(
    dish_name: "Ебанина с рисом или хуй его знает",
    price: 666,
    weight: 1050,
    picture: null,
  ),
  Dishes(
    dish_name: "вяленная конская залупа",
    price: 666,
    weight: 1050,
    picture: null,
    with_fillings: true,
  ),
  Dishes(
    dish_name: "хер моржовый",
    price: 666,
    weight: 1050,
    picture: null,
    with_fillings: true,
  )
];

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  
  int _selectedIndex = 1; // Начальный индекс, по умолчанию "Меню"

  // Метод для обработки нажатия на кнопки в BottomAppBar с использованием switch-case
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
         // Логика для перехода на главную страницу
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(), // Создайте свой экран HomeScreen
          ),
        );
        break;
      case 1:
        break;
      case 2:
        // Логика для перехода на экран "Корзина"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("Текущий адрес (адрес доставки)")),
      body:GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0, 
          childAspectRatio: 2 / 3, 
        ),
        itemCount: ListMenu.length,
        itemBuilder: (context, index) {
          final item = ListMenu[index];
          return item;
        },
        padding: EdgeInsets.all(20), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главный',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

