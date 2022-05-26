import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPageModel extends ChangeNotifier {
  String? errorTxt;
  late GoogleMapController controller;
  late final CameraPosition currentPosition;

  Future<void> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission(); //権限チェック
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); //権限　取得リクエスト
      if (permission == LocationPermission.denied) {
        return Future.error("現在地の取得はできません");
      }
    }
    final Position _currentPosition = await Geolocator.getCurrentPosition();
    currentPosition = CameraPosition(
      target: LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      ),
      zoom: 16,
    );
    notifyListeners();
  }

  //初期位置情報　表示メソッド
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(
      //Google Map　位置情報
      35.796976811368246,
      139.77157591137333,
    ),
    zoom: 20,
  );

  //ピンのセット メソッド
  final Set<Marker> markers = {
    const Marker(
        infoWindow: InfoWindow(title: "舎人公園", snippet: "舎人公園はこちらです"),
        markerId: MarkerId("1"),
        position: LatLng(
          35.796976811368246,
          139.77157591137333,
        )),
  };

  //位置情報　検索メソッド
  Future<CameraPosition> searchLating(String address) async {
    List<Location> locations = await locationFromAddress(address);
    notifyListeners();
    return CameraPosition(
        target: LatLng(locations[0].latitude, locations[0].longitude),
        zoom: 18);
  }
}
