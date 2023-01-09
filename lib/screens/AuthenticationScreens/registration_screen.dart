import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/providers/user_provider.dart';
import 'package:wedding/screens/AuthenticationScreens/login_screen.dart';
import 'package:wedding/screens/ContactAdminScreen/contact_admin.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';
import 'package:wedding/widgets/mytextformfield.dart';
import 'package:wedding/widgets/rounded_elevatedbutton.dart';

import '../../main.dart';

class RegistrationScreen extends StatefulWidget {
  final String? mobile;

  const RegistrationScreen({Key? key, this.mobile}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isIdRequire = true;

  TextEditingController name = TextEditingController();

  File? pickedImageFirst;
  File? pickedImageSecond;
  File? pickedPdf;

  final _formKey = GlobalKey<FormState>();

  _registerUser() async {
    if (_formKey.currentState!.validate()) {
      FormData data = FormData.fromMap({
        "marriage_id": marriageId,
        "guest_mobile_number": widget.mobile,
        "guest_name": name.text,
      });
      if (isIdRequire) {
        if (pickedImageFirst == null &&
            pickedImageSecond == null &&
            pickedPdf == null) {
          Fluttertoast.showToast(msg: "Please attach an Id");
          return;
        }
      }
      if (pickedImageFirst != null) {
        data.files.add(
          MapEntry(
            "guest_id_proof",
            await MultipartFile.fromFile(pickedImageFirst!.path),
          ),
        );
      }
      if (pickedImageSecond != null) {
        data.files.add(
          MapEntry(
            "guest_id_proof",
            await MultipartFile.fromFile(pickedImageSecond!.path),
          ),
        );
      }
      if (pickedPdf != null) {
        data.files.add(
          MapEntry(
            "guest_id_proof",
            await MultipartFile.fromFile(pickedPdf!.path),
          ),
        );
      }
      Provider.of<UserProvider>(context, listen: false)
          .registerUser(formData: data)
          .then((value) {
        if (value.success == true) {
          if (value.data != null) {
            if (value.data!.guestStatus.toLowerCase() == "approved") {
              sharedPrefs.mobileNo = value.data!.guestMobileNumber;
              sharedPrefs.guestId = value.data!.guestId;
              sharedPrefs.guestProfileImage = value.data!.guestProfileImage;
              sharedPrefs.guestIdProof = value.data!.guestIdProof;
              sharedPrefs.guestName = value.data!.guestName;
              nextScreenCloseOthers(context, HomeScreen());
            } else {
              nextScreenCloseOthers(context, const ContactAdmin());
            }
          } else {
            Fluttertoast.showToast(msg: "Something went wrong");
          }
        }
      });
    }
  }

  Future<void> _cropImage(bool isFirst) async {
    if (isFirst) {
      if (pickedImageFirst == null) {
        return;
      }
    } else {
      if (pickedImageSecond == null) {
        return;
      }
    }
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: isFirst ? pickedImageFirst!.path : pickedImageSecond!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.ratio3x2,
              ]
            : [
                CropAspectRatioPreset.ratio3x2,
              ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          backgroundColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: const IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      setState(() {
        isFirst
            ? pickedImageFirst = croppedFile
            : pickedImageSecond = croppedFile;
      });
    }
  }

  Future<File?> getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void _firstImagePick() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickedImageFirst = await getFromCamera();
                      _cropImage(true);

                      if (pickedImageFirst == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        pickedPdf = null;
                      }
                      setState(() {});

                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                      title: Text(
                        "Take Photo",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickedImageFirst = await getFromGallery();
                      _cropImage(true);

                      if (pickedImageFirst == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        pickedPdf = null;
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.image),
                      ),
                      title: Text(
                        "Choose from Gallery",
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _secondImagePick() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickedImageSecond = await getFromCamera();
                      _cropImage(false);

                      if (pickedImageSecond == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        pickedPdf = null;
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                      title: Text(
                        "Take Photo",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickedImageSecond = await getFromGallery();
                      _cropImage(false);
                      if (pickedImageSecond == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        pickedPdf = null;
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.image),
                      ),
                      title: Text(
                        "Choose from Gallery",
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _selectPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 2097152) {
        Fluttertoast.showToast(msg: "flie size should be less than 2 mb");
        return;
      }

      setState(() {
        pickedPdf = File(result.files.first.path!);
        pickedImageFirst = null;
        pickedImageSecond = null;
      });
    } else {
      setState(() {
        pickedPdf = null;
      });
      Fluttertoast.showToast(msg: "No Files were selected");
    }
  }

  @override
  void initState() {
    super.initState();
    if (context.read<DashboardProvider>().dashboardModel != null) {
      isIdRequire =
          context.read<DashboardProvider>().dashboardModel!.isGuestsIdProof;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Column(
                      children: [
                        AutoSizeText("Create new account",
                            style: poppinsLight.copyWith(fontSize: 19)),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: AutoSizeText(
                              "Please fill in the form to continue",
                              style: poppinsLight.copyWith(
                                  color: grey.withOpacity(0.6), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyTextFormField(
                      hintText: "Enter full name",
                      lable: "Name",
                      controller: name,
                      maxLength: 25,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 18,
                  ),
                  MyTextFormField(
                    lable: "Phone Number",
                    hintText: widget.mobile,
                    isEnable: false,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  // const SizedBox(
                  //   height: 18,
                  // ),
                  // MyTextFormField(
                  //   hintText: "Password",
                  //   controller: password,
                  //   isPassword: true,
                  //   showEye: true,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter some text';
                  //     }
                  //     if (value.length < 8) {
                  //       return 'Must be more than 8 characters';
                  //     }
                  //   },
                  // ),
                  if (isIdRequire)
                    const SizedBox(
                      height: 24,
                    ),
                  if (isIdRequire)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                _firstImagePick();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    (MediaQuery.of(context).size.width * 0.4) /
                                        1.5,
                                decoration: BoxDecoration(
                                    //  color: grey.withOpacity(0.2),
                                    border: RDottedLineBorder.all(
                                        width: 1, color: hintText),
                                    borderRadius: BorderRadius.circular(12)),
                                child: pickedImageFirst != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(pickedImageFirst!.path),
                                          height: 75,
                                          width: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: grey.withOpacity(0.2),
                                          ),
                                          AutoSizeText(
                                            "Attach ID proof Front",
                                            style: poppinsLight.copyWith(
                                                color: theme
                                                    ? grey.withOpacity(0.6)
                                                    : hintLightText,
                                                fontSize: 11),

                                            /*  poppinsLight.copyWith(
                                                  color: theme
                                                      ? hintText
                                                      : hintLightText,
                                                  fontSize: 12)*/
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _secondImagePick();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    (MediaQuery.of(context).size.width * 0.4) /
                                        1.5,
                                decoration: BoxDecoration(
                                    //  color: grey.withOpacity(0.2),
                                    border: RDottedLineBorder.all(
                                        width: 1, color: hintText),
                                    borderRadius: BorderRadius.circular(12)),
                                child: pickedImageSecond != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(pickedImageSecond!.path),
                                          height: 75,
                                          width: 75,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: grey.withOpacity(0.2),
                                          ),
                                          AutoSizeText("Attach ID proof back",
                                              style: poppinsLight.copyWith(
                                                  color: theme
                                                      ? grey.withOpacity(0.6)
                                                      : hintLightText,
                                                  fontSize: 11)),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                        if (isIdRequire)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15, top: 12),
                            child: AutoSizeText("or"),
                          ),
                        if (isIdRequire)
                          InkWell(
                            onTap: () {
                              _selectPdf();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  //  color: grey.withOpacity(0.2),
                                  border: RDottedLineBorder.all(
                                      width: 1, color: hintText),
                                  borderRadius: BorderRadius.circular(12)),
                              child: pickedPdf != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: AutoSizeText(
                                        pickedPdf!.path.split("/").last,
                                        style:
                                            poppinsLight.copyWith(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : AutoSizeText("Attach Id Proof Pdf",
                                      style: poppinsLight.copyWith(
                                          color: theme
                                              ? grey.withOpacity(0.6)
                                              : hintLightText,
                                          fontSize: 11)),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  context.watch<UserProvider>().isLoading
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        )
                      : RoundedElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const OTPScreen()));
                          },
                          label: AutoSizeText(
                            'Sign Up',
                            style: gilroyLight.copyWith(
                              color: white,
                            ),
                            /* Text(label,
            style: poppinsNormal.copyWith(
                color: textColor ?? Colors.white, fontSize: 13)),*/
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        nextScreenCloseOthers(context, const LoginScreen());
                      },
                      child: AutoSizeText.rich(
                        TextSpan(
                          text: "Have an Account? ",
                          style: poppinsLight.copyWith(fontSize: 12),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: poppinsLight.copyWith(
                                  color: Colors.blueAccent.shade700,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
