import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EcoplastWebsite extends StatefulWidget {
  const EcoplastWebsite({Key? key}) : super(key: key);

  @override
  State<EcoplastWebsite> createState() => _EcoplastWebsiteState();
}

class _EcoplastWebsiteState extends State<EcoplastWebsite> {
  late final WebViewController _controller;
  bool loading = true;
  bool firstTime = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              loading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loading = false;
              firstTime = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://ecoplast.kg/%D1%81%D0%B2%D1%8F%D0%B6%D0%B8%D1%82%D0%B5%D1%81%D1%8C-%D1%81-%D0%BD%D0%B0%D0%BC%D0%B8/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://ecoplast.kg/%D1%81%D0%B2%D1%8F%D0%B6%D0%B8%D1%82%D0%B5%D1%81%D1%8C-%D1%81-%D0%BD%D0%B0%D0%BC%D0%B8/'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: loading && firstTime
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
