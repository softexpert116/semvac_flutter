import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:localstorage/localstorage.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:share/share.dart';

import '../config/color.dart';
import '../service/api.dart';
import '../model/article_model.dart';
import '../config/config.dart';
import '../widget/appbar.dart';

class ArticleScreen extends StatefulWidget {
  final List<Article> items;
  final int itemIndex;
  ArticleScreen({Key key, @required this.items, @required this.itemIndex})
      : super(key: key);
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  int currentIndex = 0;
  Article currentItem;
  bool isFavorite = false;
  List<dynamic> favorIds = [];
  Service _service = new Service();
  final LocalStorage storage = new LocalStorage('favorite_articles');
  String text = '';
  String subject = 'Thông tin từ SEMVAC: ';
  List<String> imagePaths = [];

  @override
  void initState() {
    itemByIndex();
    initStorage();
    super.initState();
  }

  void itemByIndex() {
    setState(() {
      currentIndex = widget.itemIndex;
      currentItem = widget.items[currentIndex];
    });
  }

  void initStorage() async {
    await storage.ready;
    // storage.clear();
    if (storage.getItem("favorIds") == null) {
      favorIds = [];
      setState(() {
        isFavorite = false;
      });
    } else {
      favorIds = storage.getItem("favorIds");
      for (var i = 0; i < favorIds.length; i++) {
        if (widget.items[currentIndex].id == favorIds[i]) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    }
  }

  void addFavor(context, id) async {
    favorIds =
        storage.getItem("favorIds") == null ? [] : storage.getItem("favorIds");
    if (isFavorite || favorIds.isEmpty) {
      bool isalready = false;
      for (var i = 0; i < favorIds.length; i++) {
        if (id == favorIds[i]) isalready = true;
      }
      if (isalready) return;
      setState(() {
        favorIds.add(id);
      });
      storage.setItem("favorIds", favorIds);
      print(storage.getItem("favorIds"));
      Flushbar flush;
      var result = await _service.addFvorites(id);
      if (result == true) {
        flush = Flushbar<bool>(
            message: "SEMVAC cám ơn bạn thích thông tin này!",
            margin: EdgeInsets.all(8),
            duration: Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () {
                flush.dismiss(true); // result = true
              },
              child: Text(
                "đóng",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Noto_Sans_JP',
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ) //
            )
          ..show(context);
      }
    } else {
      for (var i = 0; i < favorIds.length; i++) {
        if (id == favorIds[i]) {
          setState(() {
            favorIds.removeAt(i);
          });
          var result = await _service.removeFvorites(id);
          print(result);
          break;
        }
      }
      storage.setItem("favorIds", favorIds);
      print(storage.getItem("favorIds"));
    }
  }

  void addShares(String id) async {
    var result = await _service.addShares(id);
    if (result == true) {
      print("Aritlce Shares Counts ++");
    } else {
      print("Aritlce Shares Counts Error!");
    }
  }

  _addSharingText() {
    setState(() {
      for (var i = 0; i < widget.items[widget.itemIndex].images.length; i++) {
        // var path = imageBaseUrl + widget.items[widget.itemIndex].images[i];
        // imagePaths.add(path);
        var body = widget.items[widget.itemIndex].articleDescription
            .replaceRange(
                100,
                widget.items[widget.itemIndex].articleDescription.length,
                "...");
        text = body +
            "\n" +
            "\n" +
            "\n" +
            "ANDROID: play.google.com/store/apps/details?id=com.semvac.semvac&hl=en" +
            "\n" +
            "\n" +
            "IPHONE: apps.apple.com/vnm/app/semvac/id937067093";

        print(text);
      }
    });
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(text,
        subject: subject + widget.items[widget.itemIndex].articleDescription,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    Icon iconData = isFavorite
        ? Icon(
            Icons.favorite_outlined,
            color: Colors.white70,
            size: 25,
          )
        : Icon(
            Icons.favorite_border_outlined,
            color: Colors.white70,
            size: 25,
          );
    Widget favoriteIcon = FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return iconData;
      },
    );
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: Stack(
        children: [
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 16),
            color: articleBackground,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          // color: cardBorderColor,
                          ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: ImageSlideshow(
                      width: double.infinity,
                      // height: 200,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      children: [
                        for (var i = 0; i < currentItem.images.length; i++)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageBaseUrl + currentItem.images[i],
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                      ],
                      onPageChanged: (value) {
                        // print('Page changed: $value');
                      },
                      // autoPlayInterval: 4000,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SwipeDetector(
                    onSwipeLeft: () {
                      if (currentIndex < widget.items.length - 1)
                        setState(() {
                          currentIndex++;
                          currentItem = widget.items[currentIndex];
                          print("SwipeRight: $currentIndex");
                        });
                    },
                    onSwipeRight: () {
                      if (currentIndex > 0)
                        setState(() {
                          currentIndex--;
                          currentItem = widget.items[currentIndex];
                          print("SwipeLeft: $currentIndex");
                        });
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 10),
                              child: Text(
                                currentItem.articleTitle,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: titleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // height: mq.height * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 10, bottom: 10),
                              child: Linkify(
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(
                                      link.url,
                                      forceSafariVC: true,
                                    );
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                                text: currentItem.articleDescription,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: mq.width * 0.07,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                border: Border.all(
                  color: appBackground,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      addFavor(context, widget.items[currentIndex].id);
                    },
                    child: favoriteIcon,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      _addSharingText();
                      _onShare(context);
                      addShares(widget.items[widget.itemIndex].id);
                    },
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.white70,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
