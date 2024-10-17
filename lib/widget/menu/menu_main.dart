import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/bucket/bucket.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;
  int _highlightedCategoryIndex = 0;
  ScrollController _scrollController = ScrollController();
  Map<String, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();

    // Инициализация ключей для каждой категории
    for (var category in categorizedMenu) {
      _categoryKeys[category['category']] = GlobalKey();
    }

    // Добавляем слушатель для скролла
    _scrollController.addListener(_onScroll);
  }

  // Метод для обновления активной категории при скролле
  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < categorizedMenu.length; i++) {
      final key = _categoryKeys[categorizedMenu[i]['category']];
      if (key != null) {
        final context = key.currentContext;
        if (context != null) {
          final box = context.findRenderObject() as RenderBox;

          // Определение позиции категории
          final categoryOffset = box.localToGlobal(Offset.zero).dy;
          final categoryHeight = box.size.height;

          // Проверяем, находится ли категория в пределах видимости экрана
          if (categoryOffset + categoryHeight > 0 &&
              categoryOffset < screenHeight) {
            // Если категория в пределах видимости, обновляем подсветку
            setState(() {
              _highlightedCategoryIndex = i;
            });
            break; // Выходим из цикла при нахождении первой видимой категории
          }
        }
      }
    }
  }

  // Метод для плавного скролла к нужной категории
  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 300),
        alignment: 0.1,
      );
    }
  }

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
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Горизонтальный список категорий
            Container(
              height: 65,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorizedMenu.length,
                itemBuilder: (context, index) {
                  final isHighlighted = _highlightedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      _scrollToCategory(categorizedMenu[index]['category']);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: isHighlighted ? Border.all(color: Colors.red, width: 2) : null,
                      ),
                      child: Center(  
                        child: Text(
                          categorizedMenu[index]['category'],
                          style: TextStyle(
                            color: isHighlighted ? Colors.white : Colors.black,
                            fontSize: 17,
                            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Основной скролл с категориями и блюдами
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  for (var category in categorizedMenu) ...[
                    // Якорь категории
                    SliverToBoxAdapter(
                      key: _categoryKeys[category['category']],
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                        child: Text(
                          category['category'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Сетка с блюдами
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2 / 3,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = category['items'][index];
                            return item;
                          },
                          childCount: category['items'].length,
                        ),
                      ),
                    ),
                  ],
                ],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
