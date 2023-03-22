import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MaterialApp(home: GoogleSlidesApp()));
}

class GoogleSlidesApp extends StatefulWidget {
  const GoogleSlidesApp({super.key});

  @override
  State<GoogleSlidesApp> createState() => _GoogleSlidesAppState();
}

class _GoogleSlidesAppState extends State<GoogleSlidesApp> {
  late InAppWebViewController webView;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 60), (timer) {
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
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              'https://docs.google.com/presentation/d/e/2PACX-1vSgDt_gvOlD5zkB7k66ZEZYtdEuAuHW4TI92_t4-dtgEnsZqOJWvxC3HzrgIvAZhkC7y12fsSiif2nO/pub?start=true&loop=true&delayms=5000')),
      onWebViewCreated: (controller) {
        webView = controller;
      },
    );
  }
}
