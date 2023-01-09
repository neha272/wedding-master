// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/user_model.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/providers/user_provider.dart';
import 'package:wedding/screens/AuthenticationScreens/registration_screen.dart';
import 'package:wedding/screens/ContactAdminScreen/contact_admin.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';
import 'package:wedding/widgets/rounded_elevatedbutton.dart';

class OTPScreen extends StatefulWidget {
  bool isRegister;
  UserModel? loginData;
  String mobile;

  OTPScreen(
      {Key? key,
      required this.loginData,
      required this.mobile,
      required this.isRegister})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController smsController = TextEditingController();
  bool hasErr = false;
  String msg = "";
  String otp = "1234567";

  @override
  void initState() {
    super.initState();
    sendSMS();
  }

  void sendSMS() async {
    await Provider.of<UserProvider>(context, listen: false)
        .sendOTP({"guest_mobile_number": widget.mobile}).then((value) {
      if (value.success == true) {
        Fluttertoast.showToast(msg: "otp send successfully");
        setState(() {
          otp = value.data!;
        });
        log("otp $otp");
      }
    });
  }

  sharedPrefsData() {
    sharedPrefs.mobileNo = widget.loginData!.guestMobileNumber;
    sharedPrefs.guestId = widget.loginData!.guestId;
    sharedPrefs.guestProfileImage = widget.loginData!.guestProfileImage;
    sharedPrefs.guestIdProof = widget.loginData!.guestIdProof;
    sharedPrefs.guestName = widget.loginData!.guestName;
    nextScreenCloseOthers(context, HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: white, gradient: greyToWhite),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Center(
                  child: Column(
                    children: [
                      AutoSizeText("OTP",
                          style: poppinsLight.copyWith(fontSize: 19)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: AutoSizeText("You will get a One Time Password",
                            style: poppinsLight.copyWith(
                                color: grey.withOpacity(0.8), fontSize: 12)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      PinCodeTextField(
                        maxLength: 6,
                        pinBoxWidth: 40,
                        onTextChanged: (text) {
                          setState(() {
                            hasErr = false;
                          });
                        },
                        errorBorderColor: Colors.redAccent,
                        pinBoxBorderWidth: 1,
                        hasError: hasErr,
                        pinBoxHeight: 40,
                        controller: smsController,
                        highlightPinBoxColor:
                            context.read<ThemeProvider>().darkTheme
                                ? hintText
                                : grey.withOpacity(0.5),
                        highlightColor: hintText,
                        pinBoxColor: context.read<ThemeProvider>().darkTheme
                            ? hintText
                            : Colors.transparent,
                        pinTextStyle: const TextStyle(
                          fontSize: 17,
                          fontFamily: "poppins",
                        ),
                        pinBoxRadius: 10,
                        keyboardType: TextInputType.number,
                      ),
                      Visibility(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(msg,
                                style:
                                    const TextStyle(color: Colors.redAccent)),
                          ),
                          visible: hasErr),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      InkWell(
                        onTap: sendSMS,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: AutoSizeText(
                            "Resend",
                            style: poppinsLight.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                RoundedElevatedButton(
                  onPressed: () {
                    nextScreen(
                        context,
                        RegistrationScreen(
                          mobile: widget.mobile,
                        ));
            /*        if (smsController.text.isEmpty) {
                      setState(() {
                        hasErr = true;
                        msg = "Please enter otp";
                      });
                    } else if (smsController.text.length != 6) {
                      setState(() {
                        hasErr = true;
                        msg = "Enter valid otp";
                      });
                    } else if (smsController.text == otp) {
                      setState(() {
                        hasErr = false;
                        msg = "";
                      });
                      if (!widget.isRegister) {
                        nextScreen(
                            context,
                            RegistrationScreen(
                              mobile: widget.mobile,
                            ));
                      } else {
                        if (widget.loginData!.guestStatus == "Approved") {
                          sharedPrefsData();
                        } else {
                          nextScreenCloseOthers(context, const ContactAdmin());
                        }
                      }
                    } else {
                      setState(() {
                        hasErr = true;
                        msg = "Wrong OTP";
                      });
                    }*/
                  },
                  label: Provider.of<UserProvider>(context, listen: false)
                          .isLoading
                      ? const CircularProgressIndicator()
                      : AutoSizeText(
                          'Verify',
                          style: gilroyLight.copyWith(
                            color: white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
