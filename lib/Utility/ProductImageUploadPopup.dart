import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import '../CodeReusable/CodeReusability.dart';
import 'MediaHandler.dart';
import 'NetworkImageLoader.dart';

class ProductImageUploadPopup extends StatefulWidget {
  final String mainPhoto;
  final List<String> initialImages; // Passed from previous screen

  const ProductImageUploadPopup({super.key,
    required this.mainPhoto,
    required this.initialImages});

  @override
  State<ProductImageUploadPopup> createState() => _ProductImageUploadPopupState();
}

class _ProductImageUploadPopupState extends State<ProductImageUploadPopup> {
  late List<String> _imageUrls;
  late String _mainImageUrl;

  @override
  void initState() {
    super.initState();
    // Initialize with passed data
    _imageUrls = List.from(widget.initialImages);
    _mainImageUrl = widget.mainPhoto;
  }

  // Logic for Progress Bar
  int get filledSetCount {
    final int main = _mainImageUrl.isNotEmpty ? 1 : 0;
    return main + _imageUrls.length;
  }

  // Existing validation: Keep >= 3 as per your logic, but visual limit is now 4
  bool get _isDoneEnabled => filledSetCount > 3;

  Color get _progressColor {
    if (filledSetCount == 1) return Colors.red;
    if (filledSetCount == 2) return Colors.deepOrange;
    if (filledSetCount == 3) return Colors.yellowAccent;
    return Colors.green;
  }

  void _submitData() {
    // Return the updated list to previous screen
    Navigator.pop(context, _imageUrls);
  }

  // ---------------- Logic ----------------

  void updateMainPhoto(String imagePath) {
    setState(() {
      _mainImageUrl = imagePath;
    });
  }

  void updatePackagePhoto(String imagePath, int index) {
    setState(() {
      // Validation 2: Save gallery photo at the specific cell index
      if (index < _imageUrls.length) {
        _imageUrls[index] = imagePath;
      } else {
        _imageUrls.add(imagePath);
      }
    });
  }

  Future<void> uploadImage(BuildContext context, int index, {bool isMainImage = false}) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    Logger().log('-----> image $imagePath');
    if (imagePath != null) {
      if (isMainImage){
        updateMainPhoto(imagePath);
      } else {
        updatePackagePhoto(imagePath, index);
      }
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(left: 15.dp, right: 15.dp, top: 5.dp, bottom: 10.dp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.arrow_back_outlined, color: Colors.black87, size: 20.dp),
                    ),
                    objCommonWidgets.customText(context, 'Product Media', 14, Colors.black, objConstantFonts.montserratSemiBold),
                    CupertinoButton(
                      onPressed: _isDoneEnabled ? _submitData : null,
                      padding: EdgeInsets.zero,
                      child: objCommonWidgets.customText(
                          context, 'Save', 14, _isDoneEnabled ? Colors.deepOrange : Colors.grey, objConstantFonts.montserratSemiBold),
                    )
                  ],
                ),
              ),

              _buildAnimatedProgressBar(),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15.dp),
                  children: [
                    // SECTION 1: MAIN IMAGE
                    _buildSectionHeader("Main Product Image", "This is the first image customers will see"),
                    _buildMainImageCard(),

                    SizedBox(height: 25.dp),

                    // SECTION 2: SUB IMAGES GRID
                    _buildSectionHeader("Product Gallery", "Add different angles or details (Min. 3)"),
                    _buildImageGrid(),

                    SizedBox(height: 50.dp), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(context, title, 13, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 2.dp),
          objCommonWidgets.customText(context, subTitle, 10, Colors.grey, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  Widget _buildMainImageCard() {
    return Container(
      height: 220.dp,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: _mainImageUrl.isEmpty
          ? CupertinoButton(
          onPressed: () => uploadImage(context, 0, isMainImage: true), // Call uploadImage for index 0
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          child: _buildAddPlaceholder())
          : Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetworkImageLoader(
              imageUrl: _mainImageUrl,
              placeHolder: objConstantAssest.placeholderImage,
              size: 80.dp,
              imageSize: double.infinity,
              isLocal: CodeReusability().isNotValidUrl(_mainImageUrl),
            ),
          ),
          _buildDeleteButton(() {
            setState(() {
              _mainImageUrl = '';
            });
          }),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _imageUrls.length + 1, // Always +1 for the Add button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.dp,
        crossAxisSpacing: 12.dp,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index == _imageUrls.length) {
          // The "Add New" card at the end
          return CupertinoButton(
            onPressed: () => uploadImage(context, index), // Call uploadImage for current cell index
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: _buildAddPlaceholder(),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.dp),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.dp),
                child: NetworkImageLoader(
                  imageUrl: _imageUrls[index],
                  placeHolder: objConstantAssest.placeholderImage,
                  size: 80.dp,
                  imageSize: double.infinity,
                  isLocal: CodeReusability().isNotValidUrl(_imageUrls[index]),
                ),
              ),
            ),
            _buildDeleteButton(() {
              setState(() {
                _imageUrls.removeAt(index);
              });
            }),
          ],
        );
      },
    );
  }

  Widget _buildAddPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: Colors.deepOrange, size: 24.dp),
          SizedBox(height: 8.dp),
          objCommonWidgets.customText(context, "Tap to Upload", 10, Colors.grey.shade600, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback onTap) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.close, color: Colors.red, size: 16),
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    const int maxImagesRequired = 4;

    final int totalImages = filledSetCount;
    final double progress = (totalImages / maxImagesRequired).clamp(0.0, 1.0);

    final String progressText = totalImages <= maxImagesRequired
        ? '$totalImages/$maxImagesRequired'
        : '$totalImages';

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.dp, horizontal: 20.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                context,
                _isDoneEnabled
                    ? "All required images added"
                    : "Add at least $maxImagesRequired images of your product",
                11,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              objCommonWidgets.customText(
                context,
                progressText,
                10,
                _isDoneEnabled ? Colors.green : Colors.black,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),
          SizedBox(height: 5.dp),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor:
                AlwaysStoppedAnimation<Color>(_progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

}