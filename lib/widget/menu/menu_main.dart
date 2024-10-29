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

  const Menu({super.key, required this.TypeOfOrder});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final ApiClient apicontroller = ApiClient();
  String selectedAddressForPickUp = "Выберите адрес ресторана";
  String selectedAddressForDelivery = "Выберите адрес доставки";
  int _selectedIndex = 1;
  int _highlightedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final Map<String, double> _categoryOffsets = {}; // Хранение позиций категорий
  late Future<void> _dishesFuture; // Создаем Future

  // void setIsLoading(isLoading){
  //   _isLoading = isLoading;
  // }


  @override
  void initState() {
    super.initState();
    // apicontroller.addDishes();
    _dishesFuture = apicontroller.addDishes(); // Сохраняем Future для единственного использования
    // Добавляем слушатель для скролла
    _scrollController.addListener(_onScroll);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Сохраняем ссылку на провайдер
  //   apicontroller.addDishes(context);
  // }

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

  // Метод для получения позиции категории при построении
  void _onCategoryLayout(String category, BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero).dy + _scrollController.offset;
    
    setState(() {
      _categoryOffsets[category] = offset; // Сохраняем позицию категории
    });
  });
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
    // final listen = Provider.of<CartProvider>(context, listen: false);
    // listen.setLoading(true);
  }

 // Метод для отображения модального окна с выбором адреса
// Метод для отображения модального окна с выбором адреса
void _showAddressForPickUpSelectionModal(BuildContext context){
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      final addressProvider = Provider.of<CartProvider>(context, listen: false); // Получаем провайдер
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Выберите адрес ресторана",
              style: TextStyles.TitleInMenuDelivery
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listOfAdressesForPickUp.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(listOfAdressesForPickUp[index]['address']),
                  onTap: () async {
                    // Устанавливаем адрес в провайдере
                    addressProvider.setAddressForPickUp(listOfAdressesForPickUp[index]['address']);
                    
                    // Вызываем другие методы, если нужно
                    apicontroller.setRestaurant(listOfAdressesForPickUp[index]['id']);
                    clearMenu();
                    Navigator.pop(context);
                    await apicontroller.addDishes();
                    // Обновляем состояние, если это необходимо
                    setState(() {}); // Перерисовка текущего виджета
                     // Закрыть модальное окно
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
      title: Text(selectedAddressForPickUp),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
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
                      itemCount: filteredCategories.length, // Используем длину отфильтрованного списка
                      itemBuilder: (context, index) {
                        final isHighlighted = _highlightedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _highlightedCategoryIndex = index; // Обновляем выделенный индекс
                            });
                            _scrollToCategory(filteredCategories[index]['category_name']); // Передаем имя категории для скролла
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
