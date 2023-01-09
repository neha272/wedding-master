import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/network_provider.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget child;

  const NetworkAwareWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.online) {
      // _showToastMessage('Online');
    } else {
      _showToastMessage('Offline');
    }
    return child;
  }

  showDialog(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return AutoSizeText(
          "You are Offline",
          style: gilroyBold.copyWith(fontSize: 20),
        );
      },
    );
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }
}
