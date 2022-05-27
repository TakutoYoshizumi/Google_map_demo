import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

import '../model/place.dart';

class ListPageModel extends ChangeNotifier {
  String? errorTxt;
  late GoogleMapController controller;
  late final CameraPosition currentPosition;
  GooglePlace? googlePlace;
  List<AutocompletePrediction>? predictions = [];
  List<Place> places = [];

  Future<void> searchLatLng(String txt) async {
    final result = await googlePlace?.autocomplete.get(txt);
    if (result != null) {
      predictions = result.predictions;
      print(predictions![0].description);
      for (AutocompletePrediction prediction in predictions!) {
        googlePlace?.details.get(prediction.placeId!).then((value) async {
          if (value != null &&
              value.result != null &&
              value.result?.photos != null) {
            List<Uint8List?> photos = [];
            await Future.forEach(
              value.result!.photos!,
              (element) {
                Photo photo = element as Photo;
                googlePlace!.photos
                    .get(photo.photoReference!, 200, 200)
                    .then((value) {
                  photos.add(value);
                });
              },
            );
            places.add(
              Place(
                  name: value.result!.name,
                  address: prediction.description,
                  images: photos),
            );
            notifyListeners();
          }
        });
      }
    }
    // List<Location> locations = await locationFromAddress(address);
    // return CameraPosition(
    //   target: LatLng(locations[0].latitude, locations[0].longtude),
    // );
  }

  void initState() {
    googlePlace = GooglePlace("AIzaSyBwOZuIfY6UktZLy67dNxphkrsG3DBeLmk");
    notifyListeners();
  }
}
