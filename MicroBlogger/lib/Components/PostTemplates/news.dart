import 'package:flutter/material.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print("NEWS CLICKED");
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            constraints: new BoxConstraints.expand(
              height: 250.0,
            ),
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: NetworkImage(
                      'https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg'),
                  fit: BoxFit.cover),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  left: 0.0,
                  bottom: 20.0,
                  child: Container(
                    width: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("News Article",
                            style: new TextStyle(
                              fontSize: 40.0,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            "US declares 'most' of China's maritime claims in South China Sea illegal",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
