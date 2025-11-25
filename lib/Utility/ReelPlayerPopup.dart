import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:video_player/video_player.dart';

import '../Constants/ConstantVariables.dart';
import 'PreferencesManager.dart';

class ReelPlayerPopup extends StatefulWidget {
  final String videoUrl;
  final String likeCount;
  final String description;

  const ReelPlayerPopup({
    super.key,
    required this.videoUrl,
    required this.likeCount,
    required this.description});

  @override
  State<ReelPlayerPopup> createState() => _ReelPlayerPopupState();
}

class _ReelPlayerPopupState extends State<ReelPlayerPopup> {
  late VideoPlayerController _controller;
  bool showIcon = false;
  bool isPlaying = true;
  final Set<int> _expandedCaptions = {};

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }

      showIcon = true; // show overlay icon
    });

    // hide icon after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => showIcon = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          GestureDetector(
            onTap: togglePlayPause,
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
          ),

          // ====== OVERLAY PLAY/PAUSE ICON =======
          if (showIcon)
            Center(
              child: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 70,
                color: Colors.white.withOpacity(0.9),
              ),
            ),

          // ===== CLOSE BUTTON =====
          Positioned(
            top: 15.dp,
            right: 15.dp,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    PreferencesManager.getInstance().then((pref) {
                      pref.setBooleanValue(
                          PreferenceKeys.isDialogOpened, false);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(decoration: BoxDecoration(
                    color: objConstantColor.yellow, // background color
                    shape: BoxShape.circle, // makes it circular
                  ), padding: EdgeInsets.all(8.dp),
                      child: Icon(
                          Icons.edit, size: 15.dp, color: Colors.black)),
                ),
                SizedBox(width: 10.dp),
                GestureDetector(
                  onTap: () {
                    PreferencesManager.getInstance().then((pref) {
                      pref.setBooleanValue(
                          PreferenceKeys.isDialogOpened, false);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(decoration: BoxDecoration(
                    color: objConstantColor.yellow, // background color
                    shape: BoxShape.circle, // makes it circular
                  ), padding: EdgeInsets.all(5.dp),
                      child: Icon(Icons.close_rounded, size: 20.dp,
                          color: Colors.black)),
                ),
              ],
            ),
          ),

          Positioned(
            right: 10.dp,
            bottom: 150.dp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.heart_solid, // white border heart
                  size: 35.dp,
                  color: Colors.red,
                ),
                customeText(
                  '${widget.likeCount}',
                  12,
                  objConstantColor.white,
                  objConstantFonts.montserratMedium,
                ),
                SizedBox(height: 15.dp),

              ],
            ),
          ),

          // 👤 Profile & caption
          Positioned(
            left: 15,
            bottom: 25,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: objConstantColor.navyBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5.dp),
                    child: ClipOval(
                      child: Image.asset(
                        objConstantAssest.logo,
                        width: 35.dp,
                        height: 35.dp,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.dp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        customeText(
                          'BotaniQ',
                          14,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                        SizedBox(width: 2.dp),
                        Image.asset(
                          objConstantAssest.verifiedIcon,
                          width: 15.dp,
                          height: 15.dp,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_expandedCaptions.contains(0)) {
                            _expandedCaptions.remove(0);
                          } else {
                            _expandedCaptions.add(0);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 65.w,
                        constraints: const BoxConstraints(
                          minHeight: 0,
                          maxHeight: double.infinity,
                        ),
                        child: AnimatedSize(
                          duration:
                          const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Text(
                            widget.description,
                            softWrap: true,
                            overflow:
                            _expandedCaptions.contains(0)
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            maxLines:
                            _expandedCaptions.contains(0)
                                ? null
                                : 1,
                            style: TextStyle(
                              color: objConstantColor.white,
                              fontSize: 12.dp,
                              fontFamily: objConstantFonts
                                  .montserratMedium,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customeText(String text, int size, Color color, String font) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size.dp,
        fontFamily: font,
      ),
    );
  }
}
