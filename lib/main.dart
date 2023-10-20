import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inductus Job',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }

  double progressBar = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();

          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    allowFileAccessFromFileURLs: true,
                    allowUniversalAccessFromFileURLs: true,
                    javaScriptEnabled: true,
                    supportZoom: false,
                    clearCache: true,
                    preferredContentMode: UserPreferredContentMode.MOBILE),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: false,
                  allowFileAccess: true,
                  builtInZoomControls: false,
                  allowContentAccess: true,
                  saveFormData: true,
                  cacheMode: AndroidCacheMode.LOAD_NO_CACHE,
                  displayZoomControls: false,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://inductusjobs.com/"),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progressbar) {
                setState(() {
                  progressBar = progressbar / 100;
                });
              },
            ),
            progressBar < 1
                ? Container(
                    child: LinearProgressIndicator(
                      value: progressBar,
                    ),
                  )
                : const SizedBox()
          ],
        )),
      ),
    );
  }
}
