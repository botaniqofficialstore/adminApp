import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../Constants/ConstantVariables.dart';
import 'PdfDownloader.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? imageUrl2;
  final String title;
  final bool isDownloadable;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.imageUrl2,
    required this.title,
    this.isDownloadable = false,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final List<String> images;
  int currentIndex = 0;

  final PageController _pageController = PageController();

  late final TransformationController _singleController;
  late final List<TransformationController> _controllers;

  bool _isZoomed = false;
  Offset _doubleTapPosition = Offset.zero;
  late final List<double> _rotations;
  Size _imageSize = Size.zero;
  late List<int> _quarterTurns;



  TransformationController get _activeController =>
      images.length == 1 ? _singleController : _controllers[currentIndex];

  @override
  void initState() {
    super.initState();

    images = [
      widget.imageUrl,
      if (widget.imageUrl2?.isNotEmpty == true) widget.imageUrl2!,
    ];

    _singleController = TransformationController()
      ..addListener(_onTransformChanged);

    _controllers = List.generate(
      images.length,
          (_) => TransformationController()..addListener(_onTransformChanged),
    );

    _rotations = List.filled(images.length, 0.0);
    _quarterTurns = List.filled(images.length, 0);

  }

  @override
  void dispose() {
    _singleController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _activeController.value.getMaxScaleOnAxis();
    final zoomed = scale > 1.0;

    if (zoomed != _isZoomed) {
      setState(() => _isZoomed = zoomed);
    }
  }

  void _resetAllZoom() {
    if (images.length == 1) {
      _singleController.value = Matrix4.identity();
      _rotations[0] = 0;
    } else {
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].value = Matrix4.identity();
        _rotations[i] = 0;
      }
    }
    _isZoomed = false;
  }


  void _onDoubleTap() {
    final controller = _activeController;
    final scale = controller.value.getMaxScaleOnAxis();

    final radians =
        _rotations[currentIndex] * 3.141592653589793 / 180;

    if (scale > 1.0) {
      // reset zoom but KEEP rotation
      controller.value = Matrix4.identity()
        ..rotateZ(radians);
      _isZoomed = false;
      return;
    }

    const zoom = 3.0;
    final pos = _doubleTapPosition;

    controller.value = Matrix4.identity()
      ..translate(pos.dx * (1 - zoom), pos.dy * (1 - zoom))
      ..scale(zoom)
      ..rotateZ(radians);

    _isZoomed = true;
  }


  void _rotateImage() {
    setState(() {
      // Increment quarter turns (90 degrees each)
      _quarterTurns[currentIndex] = (_quarterTurns[currentIndex] + 1) % 4;

      // Reset zoom when rotating to prevent clipping issues
      _activeController.value = Matrix4.identity();
      _isZoomed = false;
    });
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              /// IMAGE VIEW
              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  physics: (_isZoomed || _rotations[currentIndex] % 180 != 0)
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    _resetAllZoom();
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.dp),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool isRotatedSideWays = _quarterTurns[index] % 2 != 0;

                            return GestureDetector(
                              onDoubleTapDown: (d) =>
                              _doubleTapPosition = d.localPosition,
                              onDoubleTap: _onDoubleTap,
                              child: InteractiveViewer(
                                transformationController:
                                _activeController,
                                minScale: 1.0,
                                maxScale: 4.0,

                                /// ✅ FIXED
                                scaleEnabled: true,
                                panEnabled: _isZoomed,

                                clipBehavior: Clip.none,
                                boundaryMargin: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth,
                                  vertical: constraints.maxHeight,
                                ),
                                // Inside your PageView itemBuilder -> InteractiveViewer
                                child: RotatedBox(
                                  quarterTurns: _quarterTurns[index],
                                  child: Image.network(
                                    images[index],
                                    width: isRotatedSideWays ? constraints.maxHeight : constraints.maxWidth,
                                    height: isRotatedSideWays ? constraints.maxWidth : constraints.maxHeight,
                                    fit: BoxFit.contain, // Keep contain to ensure it fits the screen
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.white, size: 50),
                                  ),
                                ),

                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// TOP BAR
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                  EdgeInsets.only(left: 8.dp, right: 10.dp),
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
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        minimumSize: Size(0, 0),
                        child: Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                          size: 18.dp,
                        ),
                      ),
                      SizedBox(width: 5.dp),
                      objCommonWidgets.customText(
                        context,
                        widget.title,
                        15,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      const Spacer(),
                      if (widget.isDownloadable)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: downloadPDF,
                          child: Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 22.5.dp,
                          ),
                        ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _rotateImage,
                        child: Icon(
                          Icons.rotate_left,
                          color: Colors.white,
                          size: 22.5.dp,
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

  Future<void> downloadPDF() async {
    final imgs = [
      widget.imageUrl,
      if (widget.imageUrl2?.isNotEmpty == true) widget.imageUrl2!,
    ];

    final name =
        '${widget.title.replaceAll(" ", "_")}_${DateTime.now().millisecondsSinceEpoch}';

    await PdfDownloader.downloadImagesAsPdf(
      imageUrls: imgs,
      fileName: name,
    );
  }
}
