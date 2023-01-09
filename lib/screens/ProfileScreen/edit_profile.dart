import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/providers/user_provider.dart';

editProfileDialog(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    context: context,
    builder: (ctx) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const EditProfileDialogue());
    },
  );
}

class EditProfileDialogue extends StatefulWidget {
  const EditProfileDialogue({Key? key}) : super(key: key);

  @override
  State<EditProfileDialogue> createState() => _EditProfileDialogueState();
}

class _EditProfileDialogueState extends State<EditProfileDialogue> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = sharedPrefs.guestName;
  }

  _updateUser() {
    Provider.of<UserProvider>(context, listen: false)
        .updateUser(
            formData:
                FormData.fromMap({"guest_name": textEditingController.text}))
        .then((value) {
      if (value.success) {
        Provider.of<UserProvider>(context, listen: false)
            .getUserData(mobileNo: sharedPrefs.mobileNo);
        Fluttertoast.showToast(msg: "User Update Success");
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(msg: "Fail to Update Details");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Padding(
      padding: EdgeInsets.only(
          top: 30,
          right: 25,
          left: 25,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 4),
            child: AutoSizeText(
              "Your Profile",
              style: theme
                  ? gilroyBold.copyWith(fontSize: 22)
                  : gilroyBold.copyWith(
                      fontSize: 22,
                      color: eventGrey,
                    ),
            ),
          ),
          AutoSizeText(
            " Name",
            style: gilroyLight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 25),
            child: TextFormField(
              cursorColor: grey,
              controller: textEditingController,
              // initialValue: Provider.of<UserProvider>(context).user?.guestName,
              textInputAction: TextInputAction.next,
              style: gilroyNormal.copyWith(fontSize: 14),
              maxLength: 25,
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                //hintStyle: gilroyBold.copyWith(fontSize: 15),
                hintText: "Enter your Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0,
                    color: theme ? white : black,
                    style: BorderStyle.solid,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          AutoSizeText(
            " Phone Number",
            style: gilroyLight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 45),
            child: TextFormField(
              style: gilroyNormal.copyWith(fontSize: 14),
              cursorColor: grey,
              initialValue:
                  Provider.of<UserProvider>(context).user?.guestMobileNumber,
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
              enabled: false,
              maxLength: 10,
              readOnly: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                border: InputBorder.none,
                hintText: "Enter your Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0,
                    color: theme ? white : black,
                    style: BorderStyle.solid,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _updateUser();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: context.watch<ThemeProvider>().gradient,
              ),
              height: 55,
              child: AutoSizeText(
                "Save",
                style: gilroyBold.copyWith(fontSize: 18, color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
