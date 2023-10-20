import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/favorite_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import 'favorites_list_item_widget.dart';

class FavoritesListWidget extends StatelessWidget {
  final List<Favorite> favorites;

  FavoritesListWidget({Key key, List<Favorite> this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if (this.favorites.isEmpty) {
         return Center(child: Text("No Favorites1".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 10, right: 22, left: 22));
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: favorites.length,
          itemBuilder: ((_, index) {
            var _favorite = favorites.elementAt(index);
            return FavoritesListItemWidget(favorite: _favorite);
          }),
        );
      }
    });
  }
}
