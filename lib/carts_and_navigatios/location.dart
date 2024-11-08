import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/carts_and_navigatios/delivery_zone.dart';
import 'package:pizza_and_flutter/carts_and_navigatios/utils.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

final class FlutterMapWidget extends StatefulWidget {
  final void Function(MapWindow) onMapCreated;
  final VoidCallback? onMapDispose;

  const FlutterMapWidget({
    super.key,
    required this.onMapCreated,
    this.onMapDispose,
  });

  @override
  State<FlutterMapWidget> createState() => FlutterMapWidgetState();
}

final class FlutterMapWidgetState extends State<FlutterMapWidget> {
  late final AppLifecycleListener _lifecycleListener;
  
  Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    130, // Альфа (прозрачность)
    random.nextInt(256), // Красный
    random.nextInt(256), // Зеленый
    random.nextInt(256), // Синий
  );
}

  MapWindow? _mapWindow;
  bool _isMapkitActive = false;

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      top: false,
      child: YandexMap(
        onMapCreated: _onMapCreated,
        platformViewType: PlatformViewType.Hybrid,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startMapkit();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _startMapkit();
        _setMapTheme();
      },
      onInactive: () {
        _stopMapkit();
      },
    );
  }

  @override
  void dispose() {
    _stopMapkit();
    _lifecycleListener.dispose();
    widget.onMapDispose?.call();
    super.dispose();
  }

  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();
    }
  }

  void _onMapCreated(MapWindow window) {
    final List<Polygon> polygons = [];
    for (var point in points) {
      polygons.add(Polygon(
      LinearRing(point),
      [] // Атрибуты полигонов (например, стиль) можно задать здесь
    ),);
    }
    
    window.let((it) {
      widget.onMapCreated(window);
      _mapWindow = it;
      for (final polygon in polygons) {
      it.map.mapObjects.addPolygon(polygon)
      ..strokeWidth = 1.0
      ..strokeColor = getRandomColor()
      ..fillColor = getRandomColor().withAlpha(130);
    }
      it.map.logo.setAlignment(
        const LogoAlignment(
          LogoHorizontalAlignment.Left,
          LogoVerticalAlignment.Bottom,
        ),
      );
    });

    _setMapTheme();
  }

  void _setMapTheme() {
    _mapWindow?.map.nightModeEnabled =
        Theme.of(context).brightness == Brightness.dark;
  }
}