import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:localstorage/localstorage.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/api.dart';
import '../widget/loading.dart';
import '../config/color.dart';
import '../model/article_model.dart';
import '../config/config.dart';
import '../widget/appbar.dart';

class ArticleScreenById extends StatefulWidget {
  final String id;
  ArticleScreenById({Key key, @required this.id}) : super(key: key);
  @override
  _ArticleScreenByIdState createState() => _ArticleScreenByIdState();
}

class _ArticleScreenByIdState extends State<ArticleScreenById> {
  Service _service = new Service();
  Future<Article> _getArticleById;
  Article item;
  String text = '';
  String subject = 'Thông tin từ SEMVAC: ';
  List<String> imagePaths = [];
  final LocalStorage storage = new LocalStorage('favorite_articles');
  bool isFavorite = false;
  List<dynamic> favorIds = [];

  @override
  void initState() {
    _getArticleById = getArticleById(widget.id);
    initStorage();
    super.initState();
  }

  Future<Article> getArticleById(id) async {
    var result = await _service.getArticleById(id);
    item = result;
    return result;
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
        if (widget.id == favorIds[i]) {
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
      for (var i = 0; i < item.images.length; i++) {
        // var path = imageBaseUrl + item.images[i];
        // imagePaths.add(path);
        var body = item.articleDescription
            .replaceRange(100, item.articleDescription.length, "...");
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
        subject: subject + item.articleTitle,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget body(data) {
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
    var mq = MediaQuery.of(context).size;
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.all(8),
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
                      for (var i = 0; i < data.images.length; i++)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageBaseUrl + data.images[i],
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 10),
                          child: Text(
                            data.articleTitle,
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
                            text: data.articleDescription,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          right: mq.width * 0.07,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  addFavor(context, widget.id);
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
                  addShares(widget.id);
                },
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.white70,
                  size: 30,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return FractionallySizedBox(
            widthFactor: 1.0,
            child: FutureBuilder<Article>(
              future: _getArticleById,
              builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                      color: articleBackground,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: mq.height * 0.1,
                            ),
                            kLoadingWidget(context),
                          ],
                        ),
                      ),
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError || snapshot.data == null) {
                      return Container();
                    } else {
                      return body(snapshot.data);
                    }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
