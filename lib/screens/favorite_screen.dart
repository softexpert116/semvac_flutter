import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/badge_provider.dart';
import '../screens/article_screen.dart';
import '../widget/article_item_widget.dart';
import '../service/api.dart';
import '../widget/loading.dart';
import '../model/article_model.dart';
import '../config/color.dart';

import '../widget/appbar.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  Service _service = new Service();
  final LocalStorage storage = new LocalStorage('favorite_articles');
  Future<List<Article>> _getFavoriteArticles;
  String favorString = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    initStorage();
    super.initState();
  }

  void initStorage() async {
    await storage.ready;
    if (storage.getItem("favorIds") == null) {
      favorString = '';
    } else {
      var favorIds = storage.getItem("favorIds");
      favorIds.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
      for (var i = 0; i < favorIds.length; i++) {
        favorString += favorIds[i].toString() + ",";
      }
      print(favorString);
    }
    setState(() {
      _getFavoriteArticles = getFavoriteArticles(context, favorString);
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

  Future<List<Article>> getFavoriteArticles(context, ids) async {
    var result = await _service.getFavoriteArticleList(ids);
    return result;
  }

  Widget body(List<Article> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
          child: Text(
            "Thích",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          indent: 15,
          endIndent: 15,
          thickness: 2,
          height: 20,
          color: Colors.white70,
        ),
        Expanded(
          child: Container(
            child: SmartRefresher(
              enablePullDown: true,
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController,
              onRefresh: () async {
                setState(() {
                  _getFavoriteArticles =
                      getFavoriteArticles(context, favorString);
                });
                print(data);
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
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, top: 2, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                              items: data,
                              itemIndex: index,
                            ),
                          ),
                        );
                        addArticleOpens(data[index].id);
                      },
                      child: ArticleItemWidget(
                        item: data[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return FractionallySizedBox(
            widthFactor: 1.0,
            child: FutureBuilder<List<Article>>(
              future: _getFavoriteArticles,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Article>> snapshot) {
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
