import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StradaWebView extends StatefulWidget {
  final String env;
  final String linkAccessToken;
  final Function onSuccess;
  final Function onReady;
  WebViewController controller = WebViewController();

  StradaWebView(
      {super.key,
      required this.env,
      required this.linkAccessToken,
      required this.onSuccess,
      required this.onReady});

  @override
  _StradaWebViewState createState() => _StradaWebViewState();
}

class _StradaWebViewState extends State<StradaWebView> {
  String kTransparentBackgroundPage = '';

  @override
  void initState() {
    super.initState();

    widget.controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    widget.controller.addJavaScriptChannel('ConsoleLog',
        onMessageReceived: (JavaScriptMessage message) {
      print(message.message);
    });

    widget.controller.addJavaScriptChannel('CallSuccess',
        onMessageReceived: (JavaScriptMessage message) {
      print('Console: ${message.message}');
      widget.onSuccess(message.message);
    });

    widget.controller.addJavaScriptChannel('CallReady',
        onMessageReceived: (JavaScriptMessage message) {
      widget.onReady();
    });

    kTransparentBackgroundPage = '''
      <!DOCTYPE html>
      <html>

      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
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
          <button style="display:none;" id="open-strada-link">Link With Strada</button>
        </div>
        <script src="https://cdn.getstrada.com/link-asset/initialize.js" type="application/javascript" defer></script>


        <script>
        window.onerror = function(...error) {  
          ConsoleLog.postMessage('message =>' + error);
          return true;
        };  
        </script>
        
        <script>
          const config = {
            linkAccessToken: "${widget.linkAccessToken}",
            env: "${widget.env}",
            onSuccess: () => onSuccess(),
            onReady: () => onReady(),
          };

          setTimeout(() => {
            StradaLink.initialize(config);
          }, 200);

          const button = document.getElementById("open-strada-link");

          function onSuccess() {
              CallSuccess.postMessage("success");
          }

          function onReady() {
              StradaLink.openLink(config);
              CallReady.postMessage(true);
          }
        </script>
      </body>
      </html>
    ''';

    widget.controller.loadHtmlString(kTransparentBackgroundPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strada Link')),
      body: WebViewWidget(controller: widget.controller),
    );
  }
}
