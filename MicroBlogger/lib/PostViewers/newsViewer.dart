import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class NewsViewer extends StatelessWidget {
  final link;
  const NewsViewer({Key key, this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: Text("News Viewer"),
        ),
        body: (!Platform.isWindows)
            ? WebView(
                initialUrl: link,
                javascriptMode: JavascriptMode.unrestricted,
              )
            : Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://cdn.vox-cdn.com/thumbor/eHhAQHDvAi3sjMeylWgzqnqJP2w=/0x0:1800x1200/1200x0/filters:focal(0x0:1800x1200):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/13272825/The_Verge_Hysteresis_Wallpaper_Small.0.jpg"),
                        fit: BoxFit.cover)),
                child: AlertDialog(
                  title: Text("Feature not Supported"),
                  content: Text(
                      "As your target platform is Windows, this build of MicroBlogger does not support WebViewFunctionality. Please install or wait for a compatible build!"),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Close"))
                  ],
                ),
              ));
  }
}
