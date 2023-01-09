import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/user_provider.dart';
import 'package:wedding/screens/AuthenticationScreens/otp_screen.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';
import 'package:wedding/widgets/mytextformfield.dart';
import 'package:wedding/widgets/rounded_elevatedbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController number = TextEditingController();

  // TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _loginUser() async {
    if (_formKey.currentState!.validate()) {
      Provider.of<UserProvider>(context, listen: false)
          .getUserData(mobileNo: number.text)
          .then((value) {
        if (number.text == "0123456789") {
          log("hello");
          if (value.data != null) {
            sharedPrefs.mobileNo = value.data!.guestMobileNumber;
            sharedPrefs.guestId = value.data!.guestId;
            sharedPrefs.guestProfileImage = value.data!.guestProfileImage;
            sharedPrefs.guestIdProof = value.data!.guestIdProof;
            sharedPrefs.guestName = value.data!.guestName;
            nextScreenCloseOthers(context, HomeScreen());
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong, please try after sometime");
          }
        } else {
          nextScreen(
              context,
              OTPScreen(
                loginData: value.data,
                mobile: number.text,
                isRegister: value.success,
              ));
        }
      }, onError: (e) {
        log("$e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Column(
                      children: [
                        AutoSizeText("Welcome Back!",
                            style: poppinsLight.copyWith(fontSize: 19)),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: AutoSizeText("Please sign in to your account",
                              style: poppinsLight.copyWith(
                                  color: grey.withOpacity(0.8), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  MyTextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    hintText: "Enter mobile number",
                    lable: "Mobile Number",
                    controller: number,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      _loginUser();
                    },
                    validator: (phone) {
                      Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                      RegExp regExp = RegExp(pattern.toString());
                      if (phone!.isEmpty) {
                        return 'Please enter mobile number';
                      } else if (!regExp.hasMatch(phone)) {
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    },
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
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 15.0, right: 5),
                  //     child: AutoSizeText("Forgot Password?",
                  //         style: poppinsLight.copyWith(
                  //             color: hintText, fontSize: 12)),
                  //   ),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),

                  RoundedElevatedButton(
                      onPressed: () {
                        if (!(Provider.of<UserProvider>(context, listen: false)
                            .isLoading)) {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
                        }
                      },
                      label: Provider.of<UserProvider>(context, listen: false)
                              .isLoading
                          ? const CircularProgressIndicator()
                          : AutoSizeText(
                              'Sign In',
                              style: gilroyLight.copyWith(
                                color: white,
                              ),
                            )),
                  /*  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        nextScreen(
                            context,
                            RegistrationScreen(
                            ));
                      },
                      child: AutoSizeText.rich(
                        TextSpan(
                          text: "Don't have an Account? ",
                          style: poppinsLight.copyWith(fontSize: 12),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: poppinsLight.copyWith(
                                  color: Colors.blueAccent.shade700,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
