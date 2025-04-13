import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_controller.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PlaylistScreenController _controller = Get.find<PlaylistScreenController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlists"),
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading) {
        return Center(
          child: Lottie.asset("assets/lotties/music_loading.json"),
        );
      } else {
        return Center(child: Text("${_controller.fetchAlbum?.results?.length}"),);
      }
    });
    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         UIConst.hDivider,
    //         Text("Food menu", style: Theme.of(context).textTheme.titleLarge,),
    //         UIConst.hDivider,
    //         ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: Food.values.length,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemBuilder: (context, index) {
    //             final item = Food.values.elementAt(index);
    //             return ListTile(
    //               leading: CircleAvatar(backgroundColor: item.colour,),
    //               title: Text(item.name),
    //               subtitle: Text(item.price.toStringAsFixed(2)),
    //               trailing: Obx(() {
    //                 final Iterable<Food> foodByName = _controller.orderedFood.where((p0) => p0.name == item.name,);
    //                 final bool isAlreadyIn = foodByName.isNotEmpty;
    //                 final int foodAmount = foodByName.length;
    //                 if (isAlreadyIn) {
    //                   return CartStepper(
    //                     alwaysExpanded: true,
    //                     stepper: 1,
    //                     value: foodAmount,
    //                     didChangeCount: (value) {
    //                       _controller.updateItemInCart(value, item);
    //                     },
    //                   );
    //                 } else {
    //                   return FilledButton(
    //                     onPressed: () {
    //                       _controller.updateItemInCart(1, item);
    //                     },
    //                     child: Text("Add to cart"),
    //                   );
    //                 }
    //               },),
    //               onTap: null,
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
