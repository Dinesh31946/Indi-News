import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:indi_news/models/news_query_model.dart';
import 'package:http/http.dart';
import 'package:indi_news/newsDetailsScreen.dart';

class Category extends StatefulWidget {
  Category({required this.query});
  final String query;
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;

  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url = "";
    if (query == "TOP NEWS" || query == "INDIA") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=a4e54aea8878457cbf8bc36dbaacfd0e";
    } else {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=$query&apiKey=a4e54aea8878457cbf8bc36dbaacfd0e";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body) as Map;
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Indi News"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        widget.query.toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        try {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetails(
                                        url: newsModelList[index].newsUrl),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                            newsModelList[index].newsImg,
                                            fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(12, 15, 10, 7),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Text(
                                              newsModelList[index]
                                                          .newsDes!
                                                          .length >
                                                      50
                                                  ? "${newsModelList[index].newsDes!.substring(0, 55)}..."
                                                  : newsModelList[index]
                                                      .newsDes!,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          print(e);
                          return Container();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
