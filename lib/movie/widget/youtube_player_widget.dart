import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final String videoId;

  const YoutubePlayerWidget({super.key, required this.videoId, required String youtubeKey});

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );

    return YoutubePlayerScaffold(
      controller: controller,
      builder: (context, player) {
        return Scaffold(
          body: Center(child: player),
        );
      },
    );
  }
}
