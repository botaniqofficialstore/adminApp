import 'dart:io';
import 'dart:ui';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../Utility/ImageCropScreen.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../MainScreen/MainScreen.dart';
import 'AdvertisementScreenState.dart';
import 'package:path/path.dart' as p;
import '../../../../../Utility/ImageCropScreen.dart';

class AdvertisementScreen extends ConsumerStatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  AdvertisementScreenState createState() => AdvertisementScreenState();
}

class AdvertisementScreenState extends ConsumerState<AdvertisementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();


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
    var advertisementScreenState = ref.watch(AdvertisementScreenStateProvider);
    var advertisementScreenNotifier = ref.watch(AdvertisementScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
              child: Column(
                children: [
                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'Advertisement',
                        25,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      Spacer(),

                      CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ), onPressed: (){
                        mainScaffoldKey.currentState?.openDrawer();
                      })


                    ],
                  ),

                  SizedBox(height: 10.dp,),

                  Expanded(child:
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textFieldCard(context, 'Advertisement Title', 'Enter advertisement title', advertisementScreenState.titleController),
                          textViewCard(context, 'Description', 'Enter advertisement description', advertisementScreenState.descriptionController),
                          SizedBox(height: 10.dp),
                          Row(
                            children: [
                              objCommonWidgets.customText(
                                context,
                                'Add Poster',
                                14,
                                objConstantColor.white,
                                objConstantFonts.montserratSemiBold,
                              ),
                              SizedBox(width: 10.dp),
                              CommonSwitch(
                                initialValue: true,
                                onChanged: (val) {
                                  advertisementScreenNotifier.updateAdPosterState(val);
                                },
                              ),

                            ],
                          ),

                          if (advertisementScreenState.addPoster == true)...{
                            SizedBox(height: 15.dp),
                            licenceImageCard(
                                context, advertisementScreenState.advImagePath),
                          },

                          SizedBox(height: 25.dp),

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
                                  'Send Advertisement',
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
                  ))



                ],
              ),
            )

        ),
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
            maxLength: 50,
            height: 150.dp,
            controller: controller
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }


  Widget licenceImageCard(BuildContext context, String? imgPath){
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
            child: (imgPath == null ) ? Image.asset(objConstantAssest.placeholderImage,
              color: objConstantColor.white,
              height: 130.dp,
              width: 80.dp,
              fit: BoxFit.fitHeight,
            ) : ClipRRect(
              borderRadius: BorderRadius.circular(10.dp),
              child: Image.file(
                File(imgPath),
                height: 150.dp,
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
               _showUploadOptions();
            }))
      ],
    );
  }

  ///Image Upload methods
  Future<void> _showUploadOptions() async {
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
                                  _handlePick(ImageSource.camera);
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
                                  _handlePick(ImageSource.gallery);
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


  Future<void> _handlePick(ImageSource source,) async {
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
      final notifier = ref.read(AdvertisementScreenStateProvider.notifier);
        notifier.setProfileImagePath(compressedPath);


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