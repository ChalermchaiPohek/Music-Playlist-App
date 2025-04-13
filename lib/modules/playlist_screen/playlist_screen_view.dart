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
        title: const Text("My Playlists", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: _buildContent(context),
      ),
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
                            title: Text(album.name ?? "", style: TextStyle(fontWeight: FontWeight.w600),),
                            subtitle: Text(album.artistName ?? ""),
                            trailing: Obx(() {
                              if (_controller.isPlaying && album.id == _controller.albumDetail?.id) {
                                return Lottie.asset(
                                    "assets/lotties/playing_wave.json",
                                    fit: BoxFit.contain
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                            onTap: () async {
                              if (_controller.albumDetail?.id != album.id) {
                                await _player.stop();
                              }

                              await _controller.playAlbum(album.id);
                            },
                          );
                        },
                      ),
                    ),
                    Obx(() {
                      if (_controller.isFetchNextData) {
                        return Center(child: CupertinoActivityIndicator());
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

              if (_controller.isShowPlayer && albumDetail != null) {

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
                          child: FittedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: albumDetail.image ?? "",
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(color: Colors.transparent,),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Text(
                                        "Playlist : ${albumDetail.name ?? ""}",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 2,
                                      ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      _controller.stopMusic();
                                      await _player.stop();
                                    },
                                    icon: Icon(CupertinoIcons.xmark),
                                  ),

                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: albumDetail.tracks?.length,
                                  itemBuilder: (context, index) {
                                    final track = albumDetail.tracks?.elementAt(index);

                                    return Obx(() {
                                      final playingTrackId = _controller.playingTrackId;
                                      _player.playingStream.listen(_controller.triggerPlayerState);

                                      return ListTile(
                                        dense: true,
                                        leading: track?.id == playingTrackId
                                            ? _controller.isPlaying
                                            ? Icon(CupertinoIcons.pause_fill)
                                            : Icon(CupertinoIcons.play_arrow_solid)
                                            : const SizedBox(),
                                        title: Text(
                                          track?.name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                        ),
                                        onTap: () async {
                                          if (playingTrackId == track?.id) {
                                            if (_player.playerState.playing) {
                                              await _player.pause();
                                            } else {
                                              await _player.play();
                                            }
                                          } else {
                                            final trackUrl = _controller.getTrackUrl(track?.id);
                                            await _player.setUrl(trackUrl ?? "");
                                            await _player.play();
                                          }
                                        },
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
