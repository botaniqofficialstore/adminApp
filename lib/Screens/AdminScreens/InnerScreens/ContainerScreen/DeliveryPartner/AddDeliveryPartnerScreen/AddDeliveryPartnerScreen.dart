import 'dart:io';
import 'dart:ui';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../CommonViews/CommonDropdown.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../../Constants/Constants.dart';
import '../../../../../../Utility/ImageCropScreen.dart';
import '../../../../../../Utility/PreferencesManager.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'AddDeliveryPartnerScreenState.dart';
import 'package:path/path.dart' as p;


class AddDeliveryPartnerScreen extends ConsumerStatefulWidget {
  const AddDeliveryPartnerScreen({super.key});

  @override
  AddDeliveryPartnerScreenState createState() => AddDeliveryPartnerScreenState();
}

class AddDeliveryPartnerScreenState extends ConsumerState<AddDeliveryPartnerScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  List<String> gender = ["Male", "Female"];


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
    var deliveryPartnerScreenState = ref.watch(AddDeliveryPartnerScreenStateProvider);
    var deliveryPartnerScreenNotifier = ref.watch(AddDeliveryPartnerScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 5.dp, top: 15.dp, right: 15.dp),
                  child: Row(
                    children: [
                      CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callNavigation(ScreenName.deliveryPartner);
                          }),
                      objCommonWidgets.customText(
                        context,
                        'Add Delivery Partner',
                        18,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),

                      Spacer(),

                      CupertinoButton(
                          padding: EdgeInsets.zero, child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ), onPressed: () {
                        mainScaffoldKey.currentState?.openDrawer();
                      })


                    ],
                  ),
                ),

                SizedBox(height: 10.dp,),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Personal Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'First Name', 'Enter your first name', deliveryPartnerScreenState.firstNameController),
                                  textFieldCard(context, 'Last Name', 'Enter your last name', deliveryPartnerScreenState.lastNameController),

                                  objCommonWidgets.customText(
                                    context,
                                    'Date of birth',
                                    14,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(7.dp),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.75),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                                        child: objCommonWidgets.customText(
                                        context,
                                          (deliveryPartnerScreenState.dob == null) ? 'Select your date of birth' : '${deliveryPartnerScreenState.dob}',
                                        14, (deliveryPartnerScreenState.dob == null) ? Colors.white70.withOpacity(0.7): Colors.white,
                                        objConstantFonts.montserratSemiBold,
                                                                            ),
                                      ),
                                        Spacer(),
                                         Container(
                                              decoration: BoxDecoration(
                                                color: objConstantColor.yellow,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5.dp),   // your dp value if needed
                                                  bottomRight: Radius.circular(5.dp),
                                                ),
                                              ),
                                              child: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  _openDatePicker();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 11.dp, horizontal: 12.dp),
                                                  child: Image.asset(objConstantAssest.calendarIcon, width: 23.dp,),
                                                ),
                                              ),
                                            ),

                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10.dp),

                                  objCommonWidgets.customText(
                                    context,
                                    'Gender',
                                    14,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold,
                                  ),

                                  CommonDropdown(
                                    placeholder: "Select your gender",
                                    items: gender,
                                    selectedValue: deliveryPartnerScreenState.gender,
                                    isDarkView: true,
                                    onChanged: (gender) {
                                     deliveryPartnerScreenNotifier.updateGender(gender!);
                                    },
                                  ),



                                  textFieldCard(context, 'Email', 'Enter your email', deliveryPartnerScreenState.emailController),
                                  textFieldCard(context, 'Aadhar', 'Enter your aadhar number', deliveryPartnerScreenState.aadharController, isNumber: true),
                                  mobileTextFieldCard(context, 'Mobile Number', deliveryPartnerScreenState.mobileController, 'Enter your mobile number'),

                                  SizedBox(height: 25.dp),
                                Row(
                                  children: [
                                    // Use state to show selected image if exists
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final state = ref.watch(AddDeliveryPartnerScreenStateProvider);
                                        final imgPath = state.profileImagePath;
                                        return CircleAvatar(
                                          radius: 31.dp,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 30.dp,
                                            backgroundImage:
                                            imgPath != null ? FileImage(File(imgPath)) : AssetImage(objConstantAssest.defaultProfileImage) as ImageProvider,
                                            backgroundColor: Colors.transparent,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10.dp),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(20.dp),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                                        child: objCommonWidgets.customText(context, 'Upload Photo', 13, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                      ),
                                      onPressed: () {
                                        _showUploadOptions('Profile');
                                      },
                                    )
                                  ],
                                ),

                                  SizedBox(height: 10.dp),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Address Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Street', 'Enter your street', deliveryPartnerScreenState.streetController),
                                  textFieldCard(context, 'City', 'Enter your city', deliveryPartnerScreenState.cityController),
                                  textFieldCard(context, 'State', 'Enter your state', deliveryPartnerScreenState.stateController),
                                  textFieldCard(context, 'Country', 'Enter your country', deliveryPartnerScreenState.countryController),
                                  textFieldCard(context, 'Pincode', 'Enter your zipcode', deliveryPartnerScreenState.pincodeController, isNumber: true),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Driving Licence Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Licence', 'Enter your valid licence number', deliveryPartnerScreenState.pincodeController, isNumber: true),


                                  Consumer(
                                    builder: (context, ref, _) {
                                      final state = ref.watch(AddDeliveryPartnerScreenStateProvider);
                                      final imgPath = state.licenceFrontImagePath;
                                      return licenceImageCard(context, 'Licence Front Side', 'LicenceFrontPage', imgPath);
                                    },
                                  ),

                                  SizedBox(height: 15.dp),

                                  Consumer(
                                    builder: (context, ref, _) {
                                      final state = ref.watch(AddDeliveryPartnerScreenStateProvider);
                                      final imgPath = state.licenceRearImagePath;
                                      return licenceImageCard(context, 'Licence Rear Side', 'LicenceRearPage', imgPath);
                                    },
                                  ),


                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),


                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Vehicle Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Vehicle Registration', 'Enter your vehicle reg.no', deliveryPartnerScreenState.pincodeController),


                                  Consumer(
                                    builder: (context, ref, _) {
                                      final state = ref.watch(AddDeliveryPartnerScreenStateProvider);
                                      final imgPath = state.licenceFrontImagePath;
                                      return licenceImageCard(context, 'Vehicle Front View', 'VehicleFrontView', imgPath);
                                    },
                                  ),

                                  SizedBox(height: 15.dp),

                                  Consumer(
                                    builder: (context, ref, _) {
                                      final state = ref.watch(AddDeliveryPartnerScreenStateProvider);
                                      final imgPath = state.licenceRearImagePath;
                                      return licenceImageCard(context, 'Vehicle Rear View', 'VehicleRearView', imgPath);
                                    },
                                  ),


                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

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
                                  'Confirm',
                                  18,
                                  objConstantColor.navyBlue,
                                  objConstantFonts.montserratSemiBold,
                                ),
                              ),
                            ),
                          ), onPressed: (){}),
                          SizedBox(height: 35.dp,),

                        ],
                      ),
                    ),
                  ),
                )


              ],
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

  Widget mobileTextFieldCard(BuildContext context, String title, TextEditingController textField, String placeholder){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            title,
            15,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // frosted glass effect
                  borderRadius: BorderRadius.circular(7.dp),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 7.5.dp),
                  child: objCommonWidgets.customText(
                    context,
                    '+91',
                    15,
                    objConstantColor.white,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ),

              SizedBox(width: 5.dp,),

              Expanded(
                child: CommonTextField(
                  controller: textField,
                  placeholder: placeholder,
                  textSize: 15,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.white,
                  isNumber: true, // alphabetic
                  isDarkView: true,
                  onChanged: (value) {

                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget licenceImageCard(BuildContext context, String title, String imageFor, String? imgPath){
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
        SizedBox(height: 2.dp),
        Stack(
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
                  _showUploadOptions(imageFor);
                }))
          ],
        ),
      ],
    );
  }



  void _openDatePicker() async {
    DateTime? selected = await showIOSDatePicker(
      context: context,
      initialDate: DateTime.now(),        // Default DOB
      minDate: DateTime(1900, 1, 1),            // Min DOB
      maxDate: DateTime.now(),                  // Cannot select future DOB
    );
    if (selected != null) {
      var deliveryPartnerScreenNotifier = ref.watch(AddDeliveryPartnerScreenStateProvider.notifier);
      final date = "${selected.day}/${selected.month}/${selected.year}";
      deliveryPartnerScreenNotifier.updateDOB(date);
    }
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
      final notifier = ref.read(AddDeliveryPartnerScreenStateProvider.notifier);
      if (imageFor == 'Profile') {
        notifier.setProfileImagePath(compressedPath);
      } else if (imageFor == 'LicenceFrontPage'){
        notifier.setLicenceFrontImagePath(compressedPath);
      } else if (imageFor == 'LicenceRearPage'){
        notifier.setLicenceRearImagePath(compressedPath);
      } else if (imageFor == 'VehicleFrontView'){
        notifier.setVehicleFrontImagePath(compressedPath);
      } else if (imageFor == 'VehicleRearView'){
        notifier.setVehicleRearImagePath(compressedPath);
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