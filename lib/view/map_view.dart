import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googole_map/view/list_view.dart';
import 'package:provider/provider.dart';

import '../model/place.dart';
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
                        controller: model.textController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                            )),
                        // onSubmitted: (value) async {
                        //   try {
                        //     CameraPosition result =
                        //         await model.searchLating(value);
                        //     model.controller.animateCamera(
                        //         CameraUpdate.newCameraPosition(result));
                        //     model.markers.add(
                        //       Marker(
                        //         markerId: MarkerId("2"),
                        //         position: result.target,
                        //         infoWindow: InfoWindow(title: "検索結果"),
                        //       ),
                        //     );
                        //     if (model.errorTxt != null) {
                        //       model.errorTxt = null;
                        //     }
                        //   } catch (e) {
                        //     model.errorTxt = "正しい住所を入力してください";
                        //   } finally {
                        //     model.notifyListeners();
                        //   }
                        // },
                        onTap: () async {
                          Place? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListPageView(),
                            ),
                          );
                          model.searchedPlace = result;
                          model.notifyListeners();
                          if (model.searchedPlace != null) {
                            model.textController.text =
                                model.searchedPlace!.name!;
                            CameraPosition searchedPosition =
                                await model.searchLating(
                                    model.searchedPlace!.address ?? "");
                            model.markers.add(
                              Marker(
                                  markerId: MarkerId("3"),
                                  position: searchedPosition.target,
                                  infoWindow: InfoWindow(title: "検索結果")),
                            );
                            model.controller.animateCamera(
                              CameraUpdate.newCameraPosition(searchedPosition),
                            );
                            double _distance = Geolocator.distanceBetween(
                              model.currentPosition.target.latitude,
                              model.currentPosition.target.longitude,
                              searchedPosition.target.latitude,
                              searchedPosition.target.longitude,
                            );
                            model.distance =
                                (_distance / 1000).toStringAsFixed(1);
                          }
                        },
                      ),
                    ),
                    Column(
                      children: [
                        model.errorTxt == null
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  model.errorTxt!,
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                        model.searchedPlace == null
                            ? Container()
                            : SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        model.searchedPlace!.images.length,
                                    itemBuilder: (context, index) {
                                      return Image.memory(
                                          model.searchedPlace!.images[index]!);
                                    }),
                              )
                      ],
                    ),
                    Expanded(
                      child: GoogleMap(
                        markers: model.markers,
                        mapType: MapType.terrain, //Google Map 表示設定
                        initialCameraPosition: model.initialPosition,
                        onMapCreated: (GoogleMapController controller) async {
                          await model.getCurrentPosition();
                          model.controller = controller;
                          // model.markers.add(
                          //   Marker(
                          //     infoWindow: InfoWindow(title: "現在地"),
                          //     markerId: MarkerId("3"),
                          //     position: model.currentPosition.target, //現在地
                          //   ),
                          // );
                          model.controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  model.currentPosition));
                        },
                        myLocationEnabled: true, //trueでボタンクリック時に現在地に戻る
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${model.distance}km'),
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
