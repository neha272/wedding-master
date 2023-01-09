import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/models/notification_model.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/providers/theme_provider.dart';

class NotificationComponent extends StatelessWidget {
  final NotificationModel notification;

  const NotificationComponent({required this.notification, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    return Container(
      // height: 178,
      decoration: BoxDecoration(
          color: grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.only(
        left: 27,
        right: 27,
        top: 19,
        bottom: 19,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: context
                            .read<DashboardProvider>()
                            .dashboardModel!
                            .marriageLogo
                            .isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: StringConstants.apiUrl +
                                context
                                    .read<DashboardProvider>()
                                    .dashboardModel!
                                    .marriageLogo,
                            placeholder: (_, __) => Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Image.asset("assets/WeWed.png"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Text(
                      notification.notificationTitle,
                      style: poppinsBold.copyWith(fontSize: 12, height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 2, right: 2),
            child: Text(
              notification.notificationBody,
              style: poppinsLight.copyWith(
                  height: 1.6,
                  fontSize: 10,
                  color: theme ? grey.withOpacity(0.9) : eventGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              thickness: 0.4,
              color: grey.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 2, right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  DateFormat('hh:mm a').format(notification.createdDateTime),
                  minFontSize: 1,
                  style: poppinsItalic.copyWith(
                      fontSize: 10,
                      color: theme ? grey.withOpacity(0.7) : eventGrey),
                ),
                AutoSizeText(
                  DateFormat('d/MM/yyyy').format(notification.createdDateTime),
                  minFontSize: 1,
                  style: poppinsItalic.copyWith(
                      fontSize: 10,
                      color: theme ? grey.withOpacity(0.7) : eventGrey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
