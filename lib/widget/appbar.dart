import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';
import 'package:semvac_covid_viet/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';
import '../config/color.dart';
import '../screens/aboutus_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/notification_screen.dart';
import '../provider/badge_provider.dart';
import '../provider/app_name_provider.dart';

void setBadgeInitialize() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('badgeCounts');
}

void getAppName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  appName = prefs.get('appName');
}

Widget appBar(context) {
  final badgeData = Provider.of<BadgeCounter>(context);
  int badgeCounts = Provider.of<BadgeCounter>(context).count;
  String _appName = Provider.of<AppNameProvider>(context).getName;

  return PreferredSize(
    preferredSize: const Size(double.infinity, kToolbarHeight),
    child: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: appbarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: Container(
              height: kToolbarHeight,
              padding: EdgeInsets.all(2),
              child: Image.asset(
                "assets/images/SEMVAC_Logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
            child: Center(
              child: Text(
                _appName,
                style: TextStyle(
                  fontSize: 22,
                  color: appLogoColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavouriteScreen(),
              ),
            );
          },
          child: Icon(
            Icons.favorite_outline,
            color: appLogoColor,
            size: 30,
          ),
        ),
        IconBadge(
          icon: Icon(
            Icons.notifications_none,
            color: appLogoColor,
            size: 30,
          ),
          itemCount: badgeCounts,
          badgeColor: Colors.red,
          itemColor: Colors.white,
          hideZero: true,
          onTap: () {
            badgeData.initalizeCount();
            setBadgeInitialize();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
            );
          },
        ),
        SizedBox(
          width: 8,
        ),
      ],
    ),
  );
}
