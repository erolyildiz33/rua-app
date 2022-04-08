import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rua Tekstil',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const YoutubeChannel());
  }
}

class YoutubeChannel extends StatefulWidget {
  const YoutubeChannel({Key? key}) : super(key: key);
  @override
  YoutubeChannelState createState() => YoutubeChannelState();
}

class YoutubeChannelState extends State<YoutubeChannel> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  WebViewController? _webViewController;
  bool pageloading = true;
  double visiblity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Rua Tekstil'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Ana Sayfa",
            ),
            /*          BottomNavigationBarItem(
              icon: Icon(Icons.hot_tub),
              label: "Seite 1",
            ),
    */
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined),
              label: "Sepet",
            ),
          ],
          currentIndex: bottomnavbar,
          onTap: null,
        ),
        body: Center(
          child: Opacity(
            opacity: visiblity,
            child: WebView(
              initialUrl: "https://store.ruatex.com.tr/",
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (int progress) {
                debugPrint('WebView is loading (progress : $progress%)');
              },
              onWebViewCreated: (WebViewController webViewController) async {
                setState(() {
                  _webViewController = webViewController;
                });
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
              },
              navigationDelegate: (NavigationRequest request) {
                debugPrint('blocking navigation to ' + request.url);
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                debugPrint('Page finished loading: $url');
                _webViewController?.runJavascript(
                    "document.getElementsByTagName('nav')[0].style.display='none'");
                _webViewController?.runJavascript(
                    "document.getElementsByTagName('footer')[0].style.display='none'");

                setState(() {
                  visiblity = 1.0;
                  pageloading = false;
                });
              },
            ),
          ),
        ));
  }

  int get bottomnavbar => 0;
}
