import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/start_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(
    apiKey: 'd9884e4d-0407-4150-af08-641ddca746d9'
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if(listOfAdressesForPickUp.isEmpty)
    {ApiClient().addAddresses();}
    return MaterialApp(
      theme: ThemeData(
    fontFamily: 'Inter',
    ),
      home: const StartScreen(),
    );
  }
}

