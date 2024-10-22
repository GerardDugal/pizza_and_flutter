import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/bucket/bucket.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;
  int _highlightedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final Map<String, double> _categoryOffsets = {}; // Хранение позиций категорий

  @override
  void initState() {
    super.initState();
    // Добавляем слушатель для скролла
    _scrollController.addListener(_onScroll);
  }

  // Метод для обновления активной категории при скролле
  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    for (int i = 0; i < categorizedMenu.length; i++) {
      final offset = _categoryOffsets[categorizedMenu[i]['category_name']] ?? 0;

      // Проверяем, попадает ли категория в видимую область экрана
      if (scrollOffset >= offset - 200) {
        setState(() {
          _highlightedCategoryIndex = i;
        });
      }
    }
  }

  // Метод для скролла к нужной категории
  void _scrollToCategory(int index) {
    final categoryOffset = _categoryOffsets[categorizedMenu[index]['category_name']] ?? 0;
    
    _scrollController.animateTo(
      categoryOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Метод для получения позиции категории при построении
  void _onCategoryLayout(String category, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy + _scrollController.offset;
      setState(() {
        _categoryOffsets[category] = offset;
      });
    });
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
                      _scrollToCategory(index);
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
                          categorizedMenu[index]['category_name'],
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
                      child: Builder(
                        builder: (context) {
                          _onCategoryLayout(category['category_name'], context);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                            child: Text(
                              category['category_name'],
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
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
                          childAspectRatio: 400 / 590,
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
