import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReelThumbnail extends StatelessWidget {
  final String videoUrl;
  final String likeCount;
  final Function()? onTap;

  const ReelThumbnail({
    super.key,
    required this.videoUrl,
    required this.likeCount,
    this.onTap,
  });

  // Extract Cloudinary thumbnail URL
  String getThumbnailUrl(String url) {
    // Example input:
    // https://res.cloudinary.com/dya1uuvah/video/upload/v1761138705/xxxx.mp4
    final base = url.split(".mp4").first;
    return "$base.jpg";
    // Cloudinary automatically generates thumbnail if .jpg requested
  }

  @override
  Widget build(BuildContext context) {
    final thumbUrl = getThumbnailUrl(videoUrl);

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5.dp),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.dp),
              child: Image.network(
                thumbUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: LoadingAnimationWidget.twoRotatingArc(
                      color: objConstantColor.white,
                      size: 20.dp,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: objCommonWidgets.customText(context,
                        "Can't load.", 14,
                        objConstantColor.white,
                        objConstantFonts.montserratMedium),
                  );
                },
              ),
            ),
          ),

          Positioned(
            right: 5.dp,
            bottom: 3.dp,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.heart, // outlined heart
                  size: 15.dp,
                  color: Colors.white,
                ),
                SizedBox(width: 2.5.dp),
                objCommonWidgets.customText(
                  context,
                  likeCount,
                  12,
                  objConstantColor.white,
                  objConstantFonts.montserratSemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
