import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StradaWebView extends StatefulWidget {
  final String linkAccessToken;
  final WebViewController controller;

  const StradaWebView(
      {super.key, required this.linkAccessToken, required this.controller});

  @override
  _StradaWebViewState createState() => _StradaWebViewState();
}

class _StradaWebViewState extends State<StradaWebView> {
  var loadingPercentage = 0;

  String kTransparentBackgroundPage = '';

  @override
  void initState() {
    super.initState();

    kTransparentBackgroundPage = '''
      <!DOCTYPE html>
      <html>

      <head>
        <title>Strada Link</title>
      </head>
      <style type="text/css">
        body {
          background: transparent;
          margin: 0;
          padding: 0;
        }

        #container {
          position: relative;
          margin: 0;
          padding: 0;
          width: 100vw;
          height: 100vh;
        }

        h1 {
          text-align: center;
        }
      </style>

      <body>
        <div id="container">
          <h1>${widget.linkAccessToken}</h1>
        </div>
        <script type="text/javascript" src="https://cdn.getstrada.com/link-asset/initialize.js" />
        <script>
          window.StradaLink.initialize({
            env: config.env,
            linkAccessToken: config.linkAccessToken,
            onSuccess: config.onSuccess,
            onReady: () => setIsReady(true),
          });
        </script>
      </body>
      </html>
    ''';

    widget.controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    widget.controller.loadHtmlString(kTransparentBackgroundPage);

    // widget.controller.loadUrl(
    //     'https://app.strada.me/link?linkAccessToken=${widget.linkAccessToken}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strada Link'),
      ),
      body: WebViewWidget(
        controller: widget.controller,
      ),
    );
  }
}
