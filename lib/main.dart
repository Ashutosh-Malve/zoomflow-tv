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
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        /// If you want to toggle some widgets based on connection state
        body: ConnectionNotifierToggler(
      onConnectionStatusChanged: (connected) {
        /// that means it is still in the initialization phase.
        if (connected == null) return;
      },
      connected: Center(key: UniqueKey(), child: const GoogleSlidesApp()),
      disconnected: Center(
        key: UniqueKey(),
        child: TextButton(onPressed: () {}, child: const NoWifi()),
      ),
    ));
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

class NoWifi extends StatelessWidget {
  const NoWifi({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Text(
              style: TextStyle(color: Colors.red),
              'No Internet : ERR_INTERNET_DISCONNECTED '),
        ),
        CircularProgressIndicator(
          color: Colors.black,
        ),
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Text(
              style: TextStyle(color: Colors.black), 'Waiting for network'),
        ),
      ],
    );
  }
}
