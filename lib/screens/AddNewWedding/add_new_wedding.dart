import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/navigation.dart';
import 'package:wedding/providers/theme_provider.dart';
import 'package:wedding/screens/HomeScreen/home_screen.dart';

import '../../general/shared_preferences.dart';
import '../../widgets/user_button.dart';
part 'wedding_provider.dart';
class AddNewWedding extends StatefulWidget {
  const AddNewWedding({Key? key}) : super(key: key);

  @override
  State<AddNewWedding> createState() => _AddNewWeddingState();
}

class _AddNewWeddingState extends State<AddNewWedding> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(padding:const EdgeInsets.only(
                     top: 20.0, left: 20, right: 30),
                   child: UserButton(
                     url: sharedPrefs.guestProfileImage,
                     size: 45,
                     pushScreen: () {
                       /*  nextScreen(
                       context, const AddNewWedding());*/
                     },
                   ) ,
                 ),
                 Padding(
                   padding: const EdgeInsets.only(
                       top: 20.0, left: 0, right: 20),
                   child: Container(
                     height: MediaQuery.of(context).size.height *.07,
                     width: MediaQuery.of(context).size.width *.45,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30),
                       color: Colors.white.withOpacity(0.08),
                     ),
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child:Text("+ Add new wedding"),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
