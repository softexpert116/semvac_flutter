class Article {
  String id;
  String articleTitle;
  String articleDescription;
  List<String> images;
  String date;
  String favourites;
  String shares;
  String opens;
  String created;
  String deleted;

  Article(
    this.id,
    this.articleTitle,
    this.articleDescription,
    this.images,
    this.date,
    this.favourites,
    this.opens,
    this.shares,
    this.created,
    this.deleted,
  );

  Article.fromJSON(Map<String, dynamic> jsonMap) {
    List<String> imageList = [];
    id = jsonMap['id'];
    articleTitle = jsonMap['title'];
    articleDescription = jsonMap['description'];
    for (var i = 0; i < jsonMap['img_arr'].length; i++)
      imageList.add(jsonMap['img_arr'][i]);
    images = imageList;
    date = jsonMap['date'];
    favourites = jsonMap['favors'];
    opens = jsonMap['opens'];
    shares = jsonMap['shares'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = articleTitle;
    map['description'] = articleDescription;
    map['img_arr'] = images;
    map['date'] = date;
    return map;
  }
}
