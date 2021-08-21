class NewsQueryModel {
  late String newsHead;
  late String? newsDes;
  late String newsImg;
  late String newsUrl;
  NewsQueryModel({
    this.newsHead = "Some URL",
    this.newsDes = "Some URL",
    this.newsImg = "Some URL",
    this.newsUrl = "Some URL",
  });

  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsHead: news["title"],
      newsDes: news["description"],
      newsImg: news["urlToImage"],
      newsUrl: news["url"],
    );
  }
}
