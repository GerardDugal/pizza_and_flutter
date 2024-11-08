import 'package:flutter/material.dart';
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
  final points = [
    Point(latitude: 54.217678127862236, longitude: 37.670281160975925),
    Point(latitude: 54.21704345214346, longitude: 37.66867899292621),
    Point(latitude: 54.21529618239726, longitude: 37.66395116210618),
    Point(latitude: 54.209034350501284, longitude: 37.65511777295756),
    Point(latitude: 54.20969148469725, longitude: 37.64985352914517),
    Point(latitude: 54.21122916967525, longitude: 37.642641872383514),
    Point(latitude: 54.204587797345745, longitude: 37.63354381940499),
    Point(latitude: 54.20398398303256, longitude: 37.62706360242503),
    Point(latitude: 54.20405946030397, longitude: 37.62403807065624),
    Point(latitude: 54.20073832923719, longitude: 37.625218242622786),
    Point(latitude: 54.19956832146104, longitude: 37.625690311409414),
    Point(latitude: 54.19744838389108, longitude: 37.629488319374495),
    Point(latitude: 54.19552965185152, longitude: 37.63444504163402),
    Point(latitude: 54.19452306810606, longitude: 37.641590446449655),
    Point(latitude: 54.19364228713009, longitude: 37.64817795179022),
    Point(latitude: 54.19300056339927, longitude: 37.653735488869074),
    Point(latitude: 54.19291248289669, longitude: 37.65894970319407),
    Point(latitude: 54.195656818100645, longitude: 37.66103583248278),
    Point(latitude: 54.19414745517357, longitude: 37.66611072309958),
    Point(latitude: 54.19189325186329, longitude: 37.675793975807586),
    Point(latitude: 54.190305788062076, longitude: 37.681311646192626),
    Point(latitude: 54.18958439102223, longitude: 37.68314346052428),
    Point(latitude: 54.19183387387207, longitude: 37.687445301378496),
    Point(latitude: 54.192041379235924, longitude: 37.687222725625034),
    Point(latitude: 54.19257295735145, longitude: 37.68862871812466),
    Point(latitude: 54.19426202855112, longitude: 37.69231103288322),
    Point(latitude: 54.20420102693688, longitude: 37.6780631385961),
    Point(latitude: 54.211643257298554, longitude: 37.683073170838924),
    Point(latitude: 54.217326780673176, longitude: 37.67516844112686),
    Point(latitude: 54.215596466461456, longitude: 37.67186187135364),
    Point(latitude: 54.217678127862236, longitude: 37.670281160975925)
];
  

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
    final polygon = Polygon(LinearRing(points), []);
    window.let((it) {
      widget.onMapCreated(window);
      _mapWindow = it;
      
      it.map.mapObjects.addPolygon(polygon);
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