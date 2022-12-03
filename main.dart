
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromRGBO(254, 144, 99, 0.1), // navigation bar color
    statusBarColor: Color.fromRGBO(254, 144, 99, 10), // status bar color
  ));

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Splashscreen(),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> BrokerApp()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 144, 99, 10),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // Image.asset('assets/images/land_agent.png', height: 150,),
              // Image(image: AssetImage('assets/images/land_agent.png')),
              Text("Land Agent",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),),

              SizedBox(height: 30),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          )
      ),
    );
  }
}


class BrokerApp extends StatefulWidget {

  @override
  State<BrokerApp> createState() => _BrokerAppState();
}

class _BrokerAppState extends State<BrokerApp> {

  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                if(await _webViewController.canGoBack()){
                  _webViewController.goBack();
                  return false;
                }else{
                  return false;
                }
              },
              child : StreamBuilder(
                stream : Connectivity().onConnectivityChanged,
                builder: (BuildContext context,
                    AsyncSnapshot<ConnectivityResult> snapshot){
                  if(
                  snapshot != null &&
                      snapshot.hasData &&
                      snapshot.data != ConnectivityResult.none){
                    return WebView(
                      initialUrl: 'xxxxxx',
                      javascriptMode: JavascriptMode.unrestricted,

                      onWebViewCreated: (WebViewController controller){
                        _webViewController = controller;
                      },

                      navigationDelegate: (NavigationRequest request) {
                        if(request.url.contains("mailto:")) {
                          launch(request.url);
                          return NavigationDecision.prevent;
                        }
                        else if (request.url.contains("tel:")) {
                          launch(request.url);
                          return NavigationDecision.prevent;
                        }
                        else{
                          return NavigationDecision.navigate;
                        }
                      },
                      onPageStarted: (String url) {
                        print('Page started loading: $url');
                      },
                      onPageFinished: (String url) {
                        print('Page finished loading: $url');
                      },
                      gestureNavigationEnabled: true,
                      geolocationEnabled: false,
                      //support geolocation or not
                    );

                  }
                  else{
                    return Stack(
                        alignment: Alignment.center,
                        children: const [
                          Positioned(
                            top:200,
                            child: Icon(Icons.wifi_off, size: 70,),
                          ),

                          Positioned(
                            top:280,
                            child:
                            Text('No Internet\n Please Check Your Internet Connection!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,

                            ),
                          ),

                        ]

                    );
                  }
                },
              )
          ),
        )
    );
  }
}
