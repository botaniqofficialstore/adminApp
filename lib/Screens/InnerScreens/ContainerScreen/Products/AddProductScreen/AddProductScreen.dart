import 'dart:io';
import 'dart:ui';
import 'package:botaniq_admin/CommonViews/CommonDropdown.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../CommonViews/CommonWidget.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../Utility/ImageCropScreen.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'AddProductScreenState.dart';
import 'package:path/path.dart' as p;

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends ConsumerState<AddProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  final List<String> daysCount = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17'];
  final List<String> productType = [
    'Fresh',
    'Spices & Herbs',
    'Oils & Staples',
    'Health & Wellness',
    'Personal Care',
    'Healthy Snacks'
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var addState = ref.watch(AddProductScreenStateProvider);
    var notifier = ref.watch(AddProductScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 5.dp, top: 15.dp),
                    child: Row(
                      children: [
                        CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                            onPressed: (){
                              userScreenNotifier.callNavigation(ScreenName.products);
                            }),
                        objCommonWidgets.customText(
                          context,
                          'Add Product',
                          23,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.dp,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        textFieldCard(context, 'Product Name', 'Enter product name', addState.productNameController),
                        textFieldCard(context, 'Actual Price', 'Enter product actual price ', addState.productActualPriceController, isNumber: true),
                        textFieldCard(context, 'Selling Price', 'Enter product selling price', addState.productSellingController, isNumber: true),

                        objCommonWidgets.customText(
                          context,
                          'Product Type',
                          14,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                        CommonDropdown(placeholder: 'Select type', items: productType, selectedValue: addState.productType, isDarkView: true, onChanged: (type){
                          notifier.updateProductType(type!);
                        }),

                        objCommonWidgets.customText(
                          context,
                          'Maximum Delivery Taken Days',
                          14,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                        CommonDropdown(placeholder: 'Select days', items: daysCount, selectedValue: addState.maxDeliveryDays, isDarkView: true, onChanged: (days){
                          notifier.updateDeliveryDayCount(days!);
                        }),


                        textViewCard(context, 'Product Description', 'Enter your product description', addState.productDescriptionController),


                        SizedBox(height: 10.dp,),
                        productBenefitCard(context),

                        SizedBox(height: 10.dp,),
                        productMainImage(context),


                        SizedBox(height: 10.dp),
                        productAdditionalImages(context),


                        SizedBox(height: 20.dp,),
                        CupertinoButton(
                            padding: EdgeInsets.zero,child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: objConstantColor.yellow,//.withOpacity(0.15), // frosted glass effect
                            borderRadius: BorderRadius.circular(20.dp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 13.dp),
                            child: Center(
                              child: objCommonWidgets.customText(
                                context,
                                'Add Product',
                                18,
                                objConstantColor.navyBlue,
                                objConstantFonts.montserratSemiBold,
                              ),
                            ),
                          ),
                        ), onPressed: (){

                        }),
                        SizedBox(height: 35.dp,),


                      ],
                    ),
                  ),


                ],
              ),
            )
        ),
      ),
    );
  }

  Widget productMainImage(BuildContext context){
    var addState = ref.watch(AddProductScreenStateProvider);
    final imgPath = addState.productMainImage;

    return Container(
      decoration: BoxDecoration(color: Colors.white12,
          borderRadius: BorderRadius.circular(10.dp)),
      padding: EdgeInsets.only(left: 10.dp, right: 10.dp, top: 15.dp, bottom: 10.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            "Product Image",
            16,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          SizedBox(height: 10.dp),
          Consumer(
            builder: (context, ref, _) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10.dp),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                      child: (imgPath == null ) ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.dp),
                        child: Image.asset(objConstantAssest.placeholderImage,
                          color: objConstantColor.white,
                          height: 130.dp,
                          width: 80.dp,
                          fit: BoxFit.fitHeight,
                        ),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(10.dp),
                        child: Image.file(
                          File(imgPath),
                          height: 130.dp,
                          width: 80.dp,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),

                  Positioned(bottom: 10.dp, right: 10.dp, child: CupertinoButton(padding: EdgeInsets.zero,
                      child: Image.asset(objConstantAssest.plusIcon,
                          width: 20.dp,
                          height: 20.dp,
                          color: objConstantColor.white), onPressed: (){
                        _showUploadOptions('MainImage');
                      }))
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget productAdditionalImages(BuildContext context) {
    var addState = ref.watch(AddProductScreenStateProvider);
    var notifier = ref.watch(AddProductScreenStateProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10.dp),
      ),
      padding: EdgeInsets.all(12.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            "Additional Images",
            16,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          SizedBox(height: 12.dp),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.dp,
              crossAxisSpacing: 12.dp,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final img = addState.extraImages[index];

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.dp),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Center(
                      child: img == null
                          ? Image.asset(
                        objConstantAssest.placeholderImage,
                        width: 70.dp,
                        height: 70.dp,
                        color: objConstantColor.white,
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(12.dp),
                        child: Image.file(
                          File(img),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),

                  // Upload Button
                  if (img == null)
                  Positioned(
                    bottom: 1.dp,
                    right: 5.dp,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.dp)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 5.dp),
                        child: objCommonWidgets.customText(context, 'Upload Photo', 10, objConstantColor.black, objConstantFonts.montserratSemiBold),
                      ),
                      onPressed: () => _showUploadOptions("ExtraImage-$index"),
                    ),
                  ),

                  // Delete Button
                  if (img != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.delete, color: Colors.white, size: 18.dp),
                        ),
                        onPressed: () => notifier.deleteExtraImage(index),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }


  Widget textFieldCard(BuildContext context, String title, String placeHolder, TextEditingController controller, {bool isNumber = false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          14,
          objConstantColor.white,
          objConstantFonts.montserratSemiBold,
        ),
        CommonTextField(
          placeholder: placeHolder,
          controller: controller,
          textSize: 15,
          fontFamily: objConstantFonts.montserratMedium,
          textColor: objConstantColor.white,
          isNumber: isNumber,
          isDarkView: true,
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }

  Widget textViewCard(BuildContext context, String title, String placeHolder, TextEditingController controller, {bool isNumber = false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          14,
          objConstantColor.white,
          objConstantFonts.montserratSemiBold,
        ),
        CommonTextView(placeholder: placeHolder,
            maxLength: 200,
            height: 150.dp,
            controller: controller
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }

  Widget productBenefitCard(BuildContext context){
    var addState = ref.watch(AddProductScreenStateProvider);
    var notifier = ref.watch(AddProductScreenStateProvider.notifier);
    return Container(
      decoration: BoxDecoration(color: Colors.white12,
      borderRadius: BorderRadius.circular(10.dp)),
      padding: EdgeInsets.only(left: 10.dp, right: 10.dp, top: 15.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            "Product Benefit's",
            16,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          SizedBox(height: 10.dp),
          Column(
            children: List.generate(addState.benefitControllers.length, (index) {
              final controller = addState.benefitControllers[index];
              final isLast = index == addState.benefitControllers.length - 1;
              final isNotEmpty = controller.text.trim().isNotEmpty;

              return Padding(
                padding: EdgeInsets.only(bottom: 14.dp),
                child: Row(
                  children: [

                    Expanded(
                      child: CommonTextField(
                        placeholder: 'Add Product Benefit',
                        controller: controller,
                        textSize: 14,
                        fontFamily: objConstantFonts.montserratMedium,
                        textColor: objConstantColor.white,
                        isDarkView: true,
                        onChanged: (v) {
                          setState(() {}); // update plus enable
                        },
                      ),
                    ),

                    SizedBox(width: 10.dp),

                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isLast
                              ? (isNotEmpty
                              ? objConstantColor.yellow
                              : objConstantColor.yellow)
                              : objConstantColor.redd,
                          borderRadius: BorderRadius.circular(7.dp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.dp),
                          child: Image.asset(
                            isLast
                                ? (isNotEmpty
                                ? objConstantAssest.plusIcon
                                : objConstantAssest.plusIcon)
                                : objConstantAssest.minusIcon,
                            width: 20.dp,
                            height: 20.dp,
                            color: objConstantColor.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (isLast) {
                          if (isNotEmpty && addState.benefitControllers.length < 10) {
                            notifier.addBenefitField();
                          }
                        } else {
                          notifier.removeBenefitField(index);
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }




  ///Image Upload methods
  Future<void> _showUploadOptions(String imageFor) async {
    PreferencesManager.getInstance().then((pref) {
      pref.setBooleanValue(PreferenceKeys.isDialogOpened, true);
      showDialog(
        context: context,
        barrierDismissible: false, // tap outside to close
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      // frosted glass effect
                      borderRadius: BorderRadius.circular(25.dp),
                    ),
                    padding: EdgeInsets.all(20.dp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        objCommonWidgets.customText(context,
                            'Upload Photo', 15,
                            objConstantColor.yellow,
                            objConstantFonts.montserratSemiBold),

                        SizedBox(height: 35.dp),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),

                            CupertinoButton(padding: EdgeInsets.zero,
                                child: Container(
                                  padding: EdgeInsets.all(13.dp),
                                  // space around icon
                                  decoration: BoxDecoration(
                                    color: Colors.white70, // background color
                                    shape: BoxShape.circle, // makes it circular
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 25.dp,
                                    color: objConstantColor.black,
                                  ),
                                ),
                                onPressed: () {
                                  pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
                                  Navigator.pop(context);
                                  _handlePick(ImageSource.camera, imageFor);
                                }),

                            const Spacer(),

                            CupertinoButton(padding: EdgeInsets.zero,
                                child: Container(
                                  padding: EdgeInsets.all(13.dp),
                                  // space around icon
                                  decoration: BoxDecoration(
                                    color: Colors.white70, // background color
                                    shape: BoxShape.circle, // makes it circular
                                  ),
                                  child: Icon(
                                    Icons.photo,
                                    size: 25.dp,
                                    color: objConstantColor.black,
                                  ),
                                ),
                                onPressed: () {
                                  pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
                                  Navigator.pop(context);
                                  _handlePick(ImageSource.gallery, imageFor);
                                }),


                            const Spacer(),
                          ],
                        ),

                        SizedBox(height: 20.dp),

                      ],
                    ),
                  ),

                  Positioned(top: 0, right: 0,child: CupertinoButton(child: Icon(
                    Icons.close_outlined,
                    size: 28.dp,
                    color: objConstantColor.white,
                  ), onPressed: () {
                    pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
                    Navigator.pop(context);
                  }))


                ],
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _handlePick(ImageSource source, String imageFor) async {
    try {
      final hasPerm = await _checkAndRequestPermission(source);
      if (!hasPerm) return;

      // pick single image
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 100, // keep full quality for cropping; we'll compress later
      );

      if (picked == null) return; // user cancelled

      // go to crop screen
      final String? croppedPath = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => ImageCropScreen(imagePath: picked.path)),
      );

      if (croppedPath == null) return;

      // compress image without losing visual quality
      final String compressedPath = await _compressImage(croppedPath);

      // update state (Riverpod notifier)
      final notifier = ref.read(AddProductScreenStateProvider.notifier);
      if (imageFor == 'MainImage') {
        notifier.updateMainImage(compressedPath);
      } else {
        // Extra Images - format: ExtraImage-0, ExtraImage-1, etc.
        final index = int.tryParse(imageFor.split('-').last) ?? -1;
        if (index >= 0) {
          notifier.updateExtraImage(index, compressedPath);
        }
      }


    } catch (e, st) {
      debugPrint('Image pick error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to select image.')));
    }
  }

  Future<bool> _checkAndRequestPermission(ImageSource source) async {
    // For camera: camera permission
    // For gallery: photos (iOS) or storage/read_media (Android)
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        await _showOpenSettingsDialog('Camera permission is permanently denied. Please enable it from settings.');
        return false;
      }

      final result = await Permission.camera.request();
      if (result.isGranted) return true;
      if (result.isPermanentlyDenied) {
        await _showOpenSettingsDialog('Camera permission is permanently denied. Please enable it from settings.');
      }
      return false;
    } else {
      // gallery
      if (Platform.isAndroid) {
        // Android: handle READ_MEDIA_IMAGES (Android 13+) and READ_EXTERNAL_STORAGE older
        Permission p = Permission.photos; // fallback
        final sdkInt = (await _getAndroidSdkInt()) ?? 0;
        if (sdkInt >= 33) {
          p = Permission.photos; // permission_handler maps photos to READ_MEDIA_IMAGES
        } else {
          p = Permission.storage;
        }

        var status = await p.status;
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await _showOpenSettingsDialog('Storage permission is permanently denied. Please enable it from settings.');
          return false;
        }
        final res = await p.request();
        if (res.isGranted) return true;
        if (res.isPermanentlyDenied) {
          await _showOpenSettingsDialog('Storage permission is permanently denied. Please enable it from settings.');
        }
        return false;
      } else {
        // iOS
        var status = await Permission.photos.status;
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await _showOpenSettingsDialog('Photos permission is permanently denied. Please enable it from settings.');
          return false;
        }
        final res = await Permission.photos.request();
        if (res.isGranted) return true;
        if (res.isPermanentlyDenied) {
          await _showOpenSettingsDialog('Photos permission is permanently denied. Please enable it from settings.');
        }
        return false;
      }
    }
  }

  Future<int?> _getAndroidSdkInt() async {
    try {
      // permission_handler doesn't expose SDK; a quick way:
      // Use Platform.operatingSystemVersion and parse? Not reliable.
      // We'll return null (defaulting to older behavior). This is optional.
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _showOpenSettingsDialog(String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Permission required'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Open Settings')),
        ],
      ),
    );
  }

  Future<String> _compressImage(String inputPath) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.path, 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg');

    // try compress with quality 85 first, if result larger than desired keep as-is
    final result = await FlutterImageCompress.compressAndGetFile(
      inputPath,
      targetPath,
      quality: 88, // high quality, good compression
      keepExif: true,
    );

    if (result == null) {
      // fallback to original path if compression fails
      return inputPath;
    }

    return result.path;
  }


}