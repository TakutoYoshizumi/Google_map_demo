import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/list_view_model.dart';

class ListPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListPageModel>(
      create: (_) => ListPageModel()..initState(),
      child: Consumer<ListPageModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white24,
            title: SizedBox(
              height: 40,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                    )),
                onSubmitted: (value) async {
                  model.searchLatLng(value);
                },
              ),
            ),
          ),
          body: ListView.builder(
              itemCount: model.places.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(model.places[index].address ?? ""),
                  onTap: () {
                    Navigator.pop(context, model.places[index]);
                  },
                );
              }),
        );
      }),
    );
  }
}
