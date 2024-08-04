import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Wrap [MaterialApp] with [ConnectionNotifier], and that is it!
    return const ConnectionNotifier(
      alignment: AlignmentDirectional.bottomCenter,
      height: 50,
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool showError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConnectionNotifierToggler(
        onConnectionStatusChanged: (connected) {
          if (connected == true) {
            // Connected to the internet, trigger file download if showError is true
            //   _downloadFile();

          }
        },
        connected: Center(
          key: UniqueKey(),
          child: const GoogleSlidesApp(),
        ),
        disconnected: Center(
          key: UniqueKey(),
          child: TextButton(onPressed: () {}, child: const NoWifi()),
        ),
        loading: Image.asset("assets/images/internet_off_image.png"),
      ),
    );
  }
}

class GoogleSlidesApp extends StatefulWidget {
  const GoogleSlidesApp({super.key});

  @override
  State<GoogleSlidesApp> createState() => _GoogleSlidesAppState();
}

class _GoogleSlidesAppState extends State<GoogleSlidesApp> {
  late InAppWebViewController webView;
  late Timer timer;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      webView.reload();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !showError
        ? InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse(
            'https://docs.google.com/presentation/d/e/2PACX-1vRUeFL_F9WbfZHpchPNQYjaRaKsLC_khfyxdlpL4OVuRFwhYjokBLL_On2O7Hw48mEsW_h63isv8ZVu/pub?start=true&loop=true&delayms=5000'),
      ),
      onWebViewCreated: (controller) {
        webView = controller;
      },
      onLoadError: (controller, url, code, message) {
        setState(() {
          showError = true;
        });
      },
    )
        : Image.asset("assets/images/internet_off_image.png");
  }
}

class NoWifi extends StatelessWidget {
  const NoWifi({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/internet_off_image.png");
  }
}
