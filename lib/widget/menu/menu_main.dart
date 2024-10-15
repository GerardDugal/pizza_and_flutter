import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/bucket/bucket.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';

// List<Widget> ListMenu = [
//   Dishes(
//     dish_name: "Ебанина с рисом или хуй его знает",
//     price: 666,
//     weight: 1050,
//     picture: Image.asset('images/pizza_menu.png'),
//     filling: const [],
//     additional_filling: [],
//   ),
//   Dishes(
//     dish_name: "вяленная конская залупа",
//     price: 666,
//     weight: 1050,
//     picture: Image.asset('images/pizza_menu.png'),
//     with_fillings: true,
//     filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
//     additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
//   ),
//   Dishes(
//     dish_name: "хер моржовый",
//     price: 666,
//     weight: 1050,
//     picture: Image.asset('images/pizza_menu.png'),
//     with_fillings: true,
//     filling: const [{"залупа" : 0}, {"хуй" : 0}, {"Говно" : 0}],
//     additional_filling: [{"Курица" : 70}, {"Говядина" : 50}, {"Свинина" : 110}],
//   )
// ];


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;
  int _selectedCategoryIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(),
          ),
        );
        break;
      case 1:
        break;
      case 2:
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
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text("Текущий адрес (адрес доставки)"),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
      body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Горизонтальный скролл для категорий
          Container(
            height: 65,
            padding: EdgeInsets.only(top: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorizedMenu.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _selectedCategoryIndex == index
                          ? Colors.red
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        categorizedMenu[index]['category'],
                        style: TextStyle(
                          color: _selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Заголовок категории
          Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
            child: Text(
              categorizedMenu[_selectedCategoryIndex]['category'],
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Сетка с блюдами
          Expanded( 
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: categorizedMenu[_selectedCategoryIndex]['items'].length,
                itemBuilder: (context, index) {
                  final item = categorizedMenu[_selectedCategoryIndex]['items'][index];
                  return item;
                },
                padding: EdgeInsets.all(20),
              ),
            ),
          ],
        ),
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
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
