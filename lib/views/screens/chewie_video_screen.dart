
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoScreen extends StatefulWidget {
  final String videoUrl;
  final String videoName;

  ChewieVideoScreen({required this.videoUrl, required this.videoName});

  @override
  _ChewieVideoScreenState createState() => _ChewieVideoScreenState();
}

class _ChewieVideoScreenState extends State<ChewieVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
    );
    _chewieController.videoPlayerController.addListener(
      () {
        setState(() {
          isLoading = _chewieController.videoPlayerController.value.isBuffering;
        });
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          widget.videoName,
          style: whiteStyle(),
        ),
        iconTheme: const IconThemeData(
          color: whiteColor,
        ),
        actions: [
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
            ),
            onPressed: () async {
              if (!await launchUrl(
                Uri.parse(widget.videoUrl),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch ${widget.videoUrl}');
              }
            },
            icon: const Icon(
              Icons.download,
            ),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Chewie(
              controller: _chewieController,
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(
                  color: whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
