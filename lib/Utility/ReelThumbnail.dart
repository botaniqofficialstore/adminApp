import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReelThumbnail extends StatefulWidget {
  final String videoUrl;
  final String likeCount; // new field
  final Function()? onTap;

  const ReelThumbnail({
    super.key,
    required this.videoUrl,
    required this.likeCount,
    this.onTap,
  });

  @override
  State<ReelThumbnail> createState() => _ReelThumbnailState();
}

class _ReelThumbnailState extends State<ReelThumbnail> {
  Uint8List? thumb;

  @override
  void initState() {
    super.initState();
    generateThumb();
  }

  void generateThumb() async {
    final bytes = await VideoThumbnail.thumbnailData(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 300,
      quality: 60,
    );

    if (mounted) {
      setState(() {
        thumb = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          // ----- THUMBNAIL -----
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5.dp),
            ),
            child: thumb == null
                ? Center(
              child: SizedBox(
                width: 10.dp,
                height: 10.dp,
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: objConstantColor.white,
                  size: 20.dp,
                ),
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(3.dp),
              child: Image.memory(
                thumb!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // ----- HEART ICON + LIKE COUNT -----
          Positioned(
            right: 5.dp,
            bottom: 3.dp,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.heart, // white border heart
                  size: 15.dp,
                  color: Colors.white,
                ),
                SizedBox(width: 2.5.dp),
                objCommonWidgets.customText(context,
                    widget.likeCount, 12,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
