//import 'dart:html';
// ignore_for_file: avoid_print

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
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  WebViewController? _webViewController;
  bool pageloading = true;
  double visiblity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: const Text('Rua Tekstil'),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: null,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ]),
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

  void choiceAction(String choice) {
    if (choice == Constants.SignOut) {
      print('SignOut');
    }
  }

  int get bottomnavbar => 0;
}

class Constants {
  static const String fund = 'Fund';
//  static const String Settings = 'Settings';
  // ignore: constant_identifier_names
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    fund,
    'enter code here',
    SignOut
  ];
}

// ignore: use_key_in_widget_constructors
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
