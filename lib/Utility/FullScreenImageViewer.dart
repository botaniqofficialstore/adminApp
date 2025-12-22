import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../Constants/ConstantVariables.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [

              /// 🔥 IMAGE WITH ZOOM
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  panEnabled: true,
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const CupertinoActivityIndicator(
                          radius: 16,
                          color: Colors.white,
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.broken_image,
                          size: 150.dp,
                          color: Colors.white54,
                        );
                      },
                    ),
                  ),
                ),
              ),

              /// 🔝 TOP BAR
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.dp,
                    vertical: 12.dp,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [

                      /// TITLE
                      Expanded(
                        child: objCommonWidgets.customText(
                          context,
                          title,
                          15,
                          Colors.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ),

                      /// CLOSE BUTTON
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
