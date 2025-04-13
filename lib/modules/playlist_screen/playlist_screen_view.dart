import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:music_playlist_app/modules/playlist_screen/playlist_screen_controller.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final PlaylistScreenController _controller = Get.find<PlaylistScreenController>();
  final ScrollController _scrollController = ScrollController();
  final _player = AudioPlayer();

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

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                              ),
                            ),
                            title: Text(album.name ?? ""),
                            subtitle: Text(album.artistName ?? ""),
                            trailing: IconButton(
                              onPressed: () async {
                                await _controller.playAlbum(album.id);
                              },
                              icon: Icon(CupertinoIcons.play_circle),
                            ),
                            onTap: () async {
                              await _controller.playAlbum(album.id);
                            },
                          );
                        },
                      ),
                    ),
                    Obx(() {
                      if (_controller.isFetchNextData) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CupertinoActivityIndicator()
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    })
                  ],
                ),
              ),
            ),
            Obx(() {
              final albumDetail = _controller.albumDetail;

              if (_controller.isPlaying && albumDetail != null) {

                return Container(
                  // width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: albumDetail.image ?? "",
                                  ),
                                ),
                                Divider(),
                                Text(albumDetail.name ?? "")
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(color: Colors.transparent,),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: albumDetail.tracks?.length,
                                  itemBuilder: (context, index) {
                                    final track = albumDetail.tracks?.elementAt(index);
                                    final playingTrackId = _controller.playingTrackId;

                                    return ListTile(
                                      dense: true,
                                      leading: track?.id == playingTrackId
                                          ? _player.playing
                                          ? Icon(CupertinoIcons.pause_fill)
                                          : Icon(CupertinoIcons.play_arrow_solid)
                                          : const SizedBox(),
                                      title: Text(
                                        track?.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                      ),
                                      onTap: () async {
                                        final trackUrl = _controller.getTrackUrl(track?.id);
                                        await _player.setUrl(trackUrl ?? "");

                                        if (_player.playing) {
                                          await _player.pause();
                                          await _player.play();
                                        } else {
                                          await _player.play();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Expanded(child: Text("Playing ${albumDetail?.name ?? "-"}")),
                    //         IconButton(onPressed: () {
                    //           _controller.stopMusic();
                    //         },
                    //           icon: Icon(CupertinoIcons.xmark),
                    //         )
                    //       ],
                    //     ),
                    //     Row(
                    //       children: [
                    //         IconButton(
                    //             onPressed: () async {
                    //               final duration = await _player.setUrl(           // Load a URL
                    //                   albumDetail?.tracks?.first.audio ?? "");
                    //               print(duration);
                    //               await _player.play();
                    //             },
                    //             icon: Icon(Icons.add),
                    //         )
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            })
          ],
        );
      }
    });
  }
}
