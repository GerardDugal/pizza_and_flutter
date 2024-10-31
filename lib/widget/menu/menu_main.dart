import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/textstyle.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/bucket/bucket.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  final int TypeOfOrder;
  String selectedAddressForPickUp;

  Menu({super.key, required this.TypeOfOrder, this.selectedAddressForPickUp = "Выберите адрес доставки"} );
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final ApiClient apicontroller = ApiClient();
  
  String selectedAddressForDelivery = "Выберите адрес доставки";

  int _selectedIndex = 1;
  final ScrollController _scrollController = ScrollController();
  
  final Map<String, double> _categoryOffsets = {}; // Смещения для категорий
  int _highlightedCategoryIndex = 0; // Текущая выделенная категория
  late Future<void> _dishesFuture; // Создаем Future

  // void setIsLoading(isLoading){
  //   _isLoading = isLoading;
  // }
  @override
  void initState() {
    super.initState();
    _dishesFuture = apicontroller.addDishes(); // Сохраняем Future для единственного использования
    
    // Добавляем слушатель для скролла
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategoryLayout(String category, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy + _scrollController.offset;
      setState(() {
        _categoryOffsets[category] = offset;
      });
    });
  }

  void _onScroll() {
    final filteredCategories = categorizedMenu.where((category) => (category['items'] as List).isNotEmpty).toList();
    final scrollOffset = _scrollController.offset;

    for (int i = 0; i < filteredCategories.length; i++) {
      final currentCategory = filteredCategories[i]['category_name'];
      final currentOffset = _categoryOffsets[currentCategory] ?? 0;
      final nextOffset = (i < filteredCategories.length - 1)
          ? _categoryOffsets[filteredCategories[i + 1]['category_name']] ?? double.infinity
          : double.infinity;

      if (scrollOffset >= currentOffset - 600 && scrollOffset < nextOffset - 600) {
        if (_highlightedCategoryIndex != i) {
          setState(() {
            _highlightedCategoryIndex = i;
          });
        }
        break;
      }
    }
  }

  void _scrollToCategory(String categoryName) {
    final categoryOffset = _categoryOffsets[categoryName];

    if (categoryOffset != null) {
      _scrollController.animateTo(
        categoryOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        clearMenu();
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
        setState(() {
      _selectedIndex = 1;
      });
        break;
    }
  }
  
  void clearMenu(){
    for (var element in categorizedMenu) {
      element['items'] = [];
    }
    for (var element in listOfAdditionalMenu) {
      element['items'] = <Map<String, int>>[];
    }
    setState(() {
      
    });
  }

// Метод для отображения модального окна с выбором адреса
void _showAddressForPickUpSelectionModal(BuildContext context) {
  final cartcontroller = Provider.of<CartProvider>(context, listen: false);
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Выберите адрес ресторана",
              style: TextStyles.TitleInMenuDelivery,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listOfAdressesForPickUp.length,
              itemBuilder: (BuildContext context, int index) {
                final address = listOfAdressesForPickUp[index]['address'] ?? '';
                final isEven = index % 2 == 0;
                final bgColor = isEven ? Colors.grey[200] : Colors.pink[50];
                return GestureDetector(
                  onTap: () async {
                    widget.selectedAddressForPickUp = address;
                    apicontroller.setRestaurant(listOfAdressesForPickUp[index]['id'] ?? '');
                    cartcontroller.setAddressForPickUp(address);
                    clearMenu();
                    Navigator.pop(context);
                    await apicontroller.addDishes();
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.store, color: Colors.black54),
                      title: Text(address, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

void _showAddressForDeliverySelectionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Выберите адрес доставки",
              style: TextStyles.TitleInMenuPickUp,
            ),
          ),
          // Добавляем Expanded для скроллинга списка
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listOfAdressesDelivery.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(listOfAdressesDelivery[index]),
                  onTap: () {
                    setState(() {
                      selectedAddressForDelivery = listOfAdressesDelivery[index];
                    });
                    Navigator.pop(context); // Закрыть модальное окно
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

  AppBar appBarForPickUp(BuildContext context) { //appbar для самовывоза
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.selectedAddressForPickUp),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
            setState(() {
              
            });
            _showAddressForPickUpSelectionModal(context);
          },
        ),
      ],
    );
  }

  AppBar appBarForDelivery(BuildContext context) { //appbar для доставки
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(selectedAddressForDelivery),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
            _showAddressForDeliverySelectionModal(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categorizedMenu.where((category) => (category['items'] as List).isNotEmpty).toList();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult:(didPop, result) => clearMenu(),
      child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: widget.TypeOfOrder == 1 ? appBarForDelivery(context) : appBarForPickUp(context),
      body: FutureBuilder<void>(
        future: _dishesFuture, // Используем сохраненное Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          } else {
            return Container(
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
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final isHighlighted = _highlightedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          _scrollToCategory(filteredCategories[index]['category_name']);
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
                              filteredCategories[index]['category_name'],
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
                      for (var category in categorizedMenu)
                        if ((category['items'] as List).isNotEmpty)
                          ...[
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
            );
          }
        },
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
      )
    );
  }

  
}
