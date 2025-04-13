import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PlaylistScreenController _controller = Get.find<PlaylistScreenController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !_controller.isFetchNextData) {
        await _controller.getNextAlbum();
      }
    });
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
        if (_controller.fetchAlbum.isEmpty) {
          return Center(
            child: Lottie.asset(
                "assets/lotties/music_not_found.json",
            ),
          );
        }

        final albumList = _controller.fetchAlbum;

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: albumList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final album = albumList.elementAt(index);
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: album.image ?? "",
                          fit: BoxFit.contain,
                          width: 40,
                          height: 40,
                          placeholder: (context, url) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Skeletonizer(
                                child: SizedBox.square(
                                  dimension: 40,
                                  child: Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      title: Text("${index + 1} : ${album.name ?? ""}"),
                      subtitle: Text(album.artistName ?? ""),
                      trailing: IconButton(
                        onPressed: () {
                          /// TODO: implement route to play/pause screen.
                        },
                        icon: Icon(CupertinoIcons.playpause),
                      ),
                      onTap: () {
                        /// TODO: implement route to play/pause screen.
                      },
                    );
                  },
                ),
              ),
              Obx(() {
                if (_controller.isFetchNextData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator()
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              })
            ],
          ),
        );
      }
    });
  }
}
