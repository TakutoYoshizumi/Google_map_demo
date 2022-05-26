import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../view_model/map_view_model.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageModel>(
      create: (_) => MyPageModel(),
      child: Scaffold(
        body: Center(
          child: Consumer<MyPageModel>(
            builder: (context, model, child) {
              return Container(
                child: Column(
                  children: [
                    SafeArea(
                        child: TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                          )),
                      onSubmitted: (value) async {
                        try {
                          CameraPosition result =
                              await model.searchLating(value);
                          model.controller.animateCamera(
                              CameraUpdate.newCameraPosition(result));
                          model.markers.add(
                            Marker(
                              markerId: MarkerId("2"),
                              position: result.target,
                              infoWindow: InfoWindow(title: "検索結果"),
                            ),
                          );
                          if (model.errorTxt != null) {
                            model.errorTxt = null;
                          }
                        } catch (e) {
                          model.errorTxt = "正しい住所を入力してください";
                        } finally {
                          model.notifyListeners();
                        }
                      },
                    )),
                    model.errorTxt == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              model.errorTxt!,
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 18,
                              ),
                            ),
                          ),
                    Expanded(
                      child: GoogleMap(
                        markers: model.markers,
                        mapType: MapType.terrain, //Google Map 表示設定
                        initialCameraPosition: model.initialPosition,
                        onMapCreated: (GoogleMapController controller) async {
                          await model.getCurrentPosition();
                          model.controller = controller;
                          model.markers.add(
                            Marker(
                              infoWindow: InfoWindow(title: "現在地"),
                              markerId: MarkerId("3"),
                              position: model.currentPosition.target, //現在地
                            ),
                          );
                          model.controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  model.currentPosition));
                        },
                        myLocationEnabled: true, //trueでボタンクリック時に現在地に戻る
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//AIzaSyBwOZuIfY6UktZLy67dNxphkrsG3DBeLmk
