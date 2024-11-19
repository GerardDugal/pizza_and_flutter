import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:provider/provider.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pizza_and_flutter/widget/my_orders/pickup_orders/pickup_orders.dart';
import '../my_orders/delivery_orders/delivery_orders.dart'; // Для форматирования времени

class CheckoutScreenPickUp extends StatefulWidget {
  @override
  _CheckoutScreenPickUpState createState() => _CheckoutScreenPickUpState();
}

class _CheckoutScreenPickUpState extends State<CheckoutScreenPickUp> {
  final TextEditingController _commentController = TextEditingController();
  DateTime? _selectedPickupDateTime; // Выбранные дата и время
  String? _selectedAddress;
  bool _orderSubmitted = false;

  // Список доступных времен самовывоза
  List<String> timeSlots = List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  // Выбор даты и времени самовывоза
Future<void> _selectPickupDateTime(BuildContext context) async {
  await initializeDateFormatting('ru', null); // Инициализация данных для русского языка
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      DateTime tempSelectedDate = DateTime.now();
      String tempSelectedTime = timeSlots[0];
      return Container(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
              child: Text(
                "ДАТА И ВРЕМЯ ПОЛУЧЕНИЯ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Выбор даты
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        tempSelectedDate = DateTime.now().add(Duration(days: index));
                      },
                      children: List<Widget>.generate(30, (index) {
                        DateTime date = DateTime.now().add(Duration(days: index));
                        return Center(
                          child: Text(DateFormat('E, MMM d', 'ru').format(date)),
                        );
                      }),
                    ),
                  ),
                  // Выбор времени
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        tempSelectedTime = timeSlots[index];
                      },
                      children: timeSlots.map((time) => Center(child: Text(time))).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Кнопка "Готово"
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: CupertinoButton(
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _selectedPickupDateTime = DateTime(
                      tempSelectedDate.year,
                      tempSelectedDate.month,
                      tempSelectedDate.day,
                      int.parse(tempSelectedTime.split(":")[0]),
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text('Готово', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  // Показываем панель выбора оплаты
  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Чтобы нельзя было закрыть свайпом
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return _orderSubmitted
                ? _buildOrderSuccessContent() // Показ галочки и сообщения об успехе
                : _buildPaymentOptionsContent(modalSetState); // Показ вариантов оплаты
          },
        );
      },
    );
  }

// Содержимое панели с вариантами оплаты
Widget _buildPaymentOptionsContent(StateSetter modalSetState) {
  return Container(
    height: 230,
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Выберите способ оплаты",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        // Кнопка оплаты картой
        GestureDetector(
          onTap: () {
            modalSetState(() {
              _completeOrder(modalSetState); // Завершаем заказ при выборе оплаты картой
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Светлый фон
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, color: Colors.grey[800]),
                SizedBox(width: 10),
                Text(
                  "Картой",
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        // Кнопка оплаты наличными
        GestureDetector(
          onTap: () {
            modalSetState(() {
              _completeOrder(modalSetState); // Завершаем заказ при выборе оплаты наличными
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Светлый фон
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.grey[800]),
                SizedBox(width: 10),
                Text(
                  "Наличными",
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



// Содержимое после отправки заказа (галочка и сообщение)
Widget _buildOrderSuccessContent() {
  return Container(
    height: 800,
    width: double.infinity,
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.check, color: Colors.red, size: 60),
        ),
        SizedBox(height: 20),
        Text(
          "СТАТУС ЗАКАЗА",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        Text(
          "Ваш заказ отправлен на оформление!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 30),]),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context); // Закрываем модальное окно
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Убираем стандартные отступы ElevatedButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.transparent, // Прозрачный фон для ElevatedButton
            shadowColor: Colors.transparent, // Убираем тень кнопки
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Светлый фон кнопки
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Понятно",
              style: TextStyle(
                color: Colors.black, // Темный цвет текста
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        )
      ],
    ),
  );
}


  // Завершение заказа и обновление состояния
  void _completeOrder(StateSetter modalSetState) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    setState(() {
      _orderSubmitted = true;
    });

    final List<CartItem> ListOfDishes = List.from(cart.items);
    ListOfPickUpOrders.add(PickUp(
      number: 1,
      price: cart.calctotalToPay(),
      date: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      status: Status.inprogress,
      count_positions: cart.positionsAmount,
      detailedStatus: DetailedStatus.adopted,
      dishList: ListOfDishes,
      pickup_adress: _selectedAddress.toString(),
      pickup_time: _selectedPickupDateTime.toString(),
    ));
    ApiClient().sendOrder(cart.AddressForPickUpId, cart.calctotalToPay(), ListOfDishes);
    cart.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    _selectedAddress = cart.AddressForPickUp;
    return Scaffold(
      appBar: AppBar(
        title: Text("Оформление заказа", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Адрес самовывоза", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0), // Нижняя серая линия
                      ),
                    ),
                    child: DropdownButtonHideUnderline( // Скрывает стандартное подчеркивание DropdownButton
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Адрес компании"),
                        value: _selectedAddress,
                        items: listOfAdressesForPickUp
                            .map((addressMap) => addressMap["address"])
                            .toSet()
                            .map((uniqueAddress) {
                          return DropdownMenuItem<String>(
                            value: uniqueAddress,
                            child: Text(uniqueAddress, overflow: TextOverflow.ellipsis, maxLines: 1),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            cart.setAddressForPickUp(newValue, listOfAdressesForPickUp.where((address) => address['address'] == newValue));
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Время самовывоза", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Блок с выбором даты и времени
                  GestureDetector(
                    onTap: () => _selectPickupDateTime(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1.0), // Нижняя серая линия
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [ // Отступ между иконкой и текстом
                          Text(
                            _selectedPickupDateTime == null
                                ? "Выберите дату и время"
                                : DateFormat('E, MMM d, HH:mm', 'ru').format(_selectedPickupDateTime!),
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.access_time, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Комментарии", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0), // Нижняя серая линия
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: "Ваш комментарий",
                              border: OutlineInputBorder(borderSide: BorderSide.none), // Без рамки
                              contentPadding: EdgeInsets.all(1), // Отступы внутри поля
                            ),
                            maxLines: 1, // Поле ввода в одну строчку
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey), // Иконка крестика
                          onPressed: () {
                            setState(() {
                              _commentController.clear(); // Очистить текст в поле
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 243, 243, 243),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Заказ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Сумма"),
                      Text("${cart.totalAmount().toString()} ₽", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Скидка -${cart.discountPercent}%", style: TextStyle(color: Colors.red)),
                      Text(" ${cart.calculatediscountInRublesTotal().toStringAsFixed(0)} ₽",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Всего к оплате", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                      Text("${cart.calctotalToPay().toStringAsFixed(0)} ₽",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentOptions(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Оформить заказ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
