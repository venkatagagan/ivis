import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.rtspLInk,
    required this.status,
    required this.cameraName,
  }) : super(key: key);

  final String rtspLInk;
  final String status;
  final String cameraName;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

bool shouldReloadContainers = false;

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController _controller;

  double _currentScale = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      widget.rtspLInk,
      hwAcc: HwAcc.full,
      autoInitialize: false,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Align(alignment: Alignment.center),
          Row(
            children: [
              SizedBox(
                width: 30,
              )
            ],
          ),
          Container(
            width: 300,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                // Positioned widget at the top-left corner
                Positioned(
                  top: 10,
                  left: 25,
                  child: Text(
                    widget.cameraName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 13,
                  left: 280,
                  child: Text(
                    widget.status,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                    top: 36,
                    left: 25,
                    right: 25,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: GestureDetector(
                        onScaleStart: (ScaleStartDetails details) {
                          _baseScale = _currentScale;
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          setState(() {
                            _currentScale = _baseScale * details.scale;
                          });
                        },
                        onScaleEnd: (ScaleEndDetails details) {
                          // Handle any scale end logic here if needed
                        },
                        child: Transform.scale(
                          scale: _currentScale,
                          child: VlcPlayer(
                            controller: _controller,
                            aspectRatio: 25 / 9,
                            placeholder: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
