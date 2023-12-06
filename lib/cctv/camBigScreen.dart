import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class BigScreen extends StatefulWidget {
  const BigScreen({
    Key? key,
    required this.rtspLInk,
    required this.cameraId,
    required this.cameraName,
  }) : super(key: key);

  final String rtspLInk;
  final String cameraId;
  final String cameraName;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<BigScreen> {
  late VlcPlayerController _controller;

  double _currentScale = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      widget.rtspLInk,
      hwAcc: HwAcc.full,
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cameraName),
      ),
      body: Center(
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
              aspectRatio: 16 / 9,
              placeholder: const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
