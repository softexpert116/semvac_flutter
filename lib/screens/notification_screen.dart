import 'dart:convert' show json;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:semvac_covid_viet/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/badge_provider.dart';
import '../widget/notification_item_widget.dart';
import '../config/color.dart';
import '../widget/appbar.dart';
import '../screens/article_screen_by_id.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map> notificationList = [];
  String currentIndexId;
  Service _service = new Service();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prevListStr = prefs.getString('nfList');

    if (prevListStr != null) {
      var prevList = json.decode(prevListStr);
      prevList
          .sort((a, b) => int.parse(b["time"]).compareTo(int.parse(a["time"])));
      setState(() {
        notificationList = List<Map>.from(prevList);
      });
    }
  }

  void removeNotificationbyIndex(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentIndexId = notificationList[index]['article_id'];
      notificationList.removeAt(index);
      prefs.setString("nfList", json.encode(notificationList));
    });
  }

  void removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationList.clear();
      prefs.setString("nfList", json.encode(notificationList));
    });
  }

  void addArticleOpens(String id) async {
    var result = await _service.addArticleOpens(id);
    if (result == true) {
      print("Aritlce Opens Counts ++");
    } else {
      print("Aritlce Opns Counts Error!");
    }
  }

  Widget body() {
    final badgeData = Provider.of<BadgeCounter>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                      child: Text(
                        "Thông báo bài mới",
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 8, 0),
                      child: ElevatedButton(
                        child: Text('Xóa mọi thông báo'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                        ),
                        onPressed: () {
                          removeAll();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                  height: 20,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: SmartRefresher(
              enablePullDown: true,
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController,
              onRefresh: () async {
                setState(() {
                  getNotifications();
                  badgeData.initalizeCount();
                  setBadgeInitialize();
                });
                await Future.delayed(Duration(milliseconds: 1000));
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(Duration(milliseconds: 1000));
                // if failed,use loadFailed(),if no data return,use LoadNodata()
                if (mounted) setState(() async {});
                _refreshController.loadComplete();
              },
              child: ListView.builder(
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, top: 2, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleScreenById(
                              id: currentIndexId,
                            ),
                          ),
                        );
                        badgeData.initalizeCount();
                        removeNotificationbyIndex(index);
                        addArticleOpens(currentIndexId);
                      },
                      child: NotificationWidget(
                        item: notificationList[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: body(),
    );
  }
}
