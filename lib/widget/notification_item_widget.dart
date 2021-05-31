import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/config.dart';
import '../model/article_model.dart';
import '../widget/loading.dart';
import '../service/api.dart';
import '../config/color.dart';

class NotificationWidget extends StatefulWidget {
  final Map item;
  NotificationWidget({Key key, @required this.item}) : super(key: key);
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  Service _service = new Service();
  Future<Article> _getArticle;
  String timeago = '';
  bool isDataNull = false;

  @override
  void initState() {
    _getArticle = getArticleById(widget.item['article_id']);
    setState(() {
      timeago = readTimestamp();
    });

    super.initState();
  }

  Future<Article> getArticleById(id) async {
    var result = await _service.getArticleById(id);
    if (result == null) {
      setState(() {
        isDataNull = true;
      });
    } else {
      setState(() {
        isDataNull = false;
      });
    }
    return result;
  }

  String readTimestamp() {
    String result = '';
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    var sentTime = int.parse(widget.item['time']);
    var ago = (now - sentTime).abs();
    if (ago < 60 && ago > 0) {
      var s = ago.floor();
      result = s.toString() + 's ago';
    } else if (ago >= 60 && ago < 3600) {
      var m = (ago / 60).floor();
      var s = (ago - m * 60).floor();
      result = m.toString() + 'm ' + s.toString() + 's ago';
    } else if (ago >= 3600) {
      var h = (ago / 3600).floor();
      var m = ((ago - h * 3600) / 60).floor();
      var s = (ago - h * 3600 - m * 60).floor();
      result = h.toString() + 'h ' + m.toString() + 'm ago';
    }
    print(result);
    return result;
  }

  Widget body(data) {
    var mq = MediaQuery.of(context).size;
    return Card(
      color: articleBackground,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 1,
          color: cardBorderColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text(
                      timeago,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                width: mq.width * 0.3,
                height: mq.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                      // color: cardBorderColor,
                      ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Container(
                  // margin: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageBaseUrl + data.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: mq.width * 0.6,
                height: mq.width * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 25.0),
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 19.0,
                            color: titleColor,
                            fontWeight: FontWeight.normal,
                          ),
                          text: data.articleTitle,
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      child: RichText(
                        maxLines: 4,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white70,
                          ),
                          text: widget.item['text'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return isDataNull
        ? Container()
        : LayoutBuilder(
            builder: (context, constraint) {
              return FractionallySizedBox(
                widthFactor: 1.0,
                child: FutureBuilder<Article>(
                  future: _getArticle,
                  builder:
                      (BuildContext context, AsyncSnapshot<Article> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        bool _visible = true;
                        // Timer.periodic(const Duration(milliseconds: 100),
                        //     (timer) {
                        //   setState(() {
                        //     _visible = !_visible;
                        //   });
                        // });
                        return AnimatedOpacity(
                          // If the widget is visible, animate to 0.0 (invisible).
                          // If the widget is hidden, animate to 1.0 (fully visible).
                          opacity: _visible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          // The green box must be a child of the AnimatedOpacity widget.
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cardBorderColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              width: mq.width * 0.9,
                              height: mq.height * 0.25,
                              // color: articleBackground,
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
          );
  }
}
