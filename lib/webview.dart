import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class StradaWebView extends StatefulWidget {
  final String env;
  final String linkAccessToken;
  final Function onSuccess;
  final Function onReady;

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
  String _pubToken = '';

  late final InAppWebViewController _webViewController;
  late final InAppWebViewController _webViewControllerPopup;

  @override
  void initState() {
    super.initState();

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
          <h1>Strada Link</h1>
        </div>
        <script src="https://cdn.getstrada.com/link-asset/initialize.js" type="application/javascript" defer></script>

        <script>
          const config = {
            linkAccessToken: "${widget.linkAccessToken}",
            env: "${widget.env}",
            onSuccess: (id) => console.log(id),
            onReady: () => onReady(),
          };

          setTimeout(() => {
            StradaLink.initialize(config);
          }, 200);

          function onReady() {
              StradaLink.openLink(config);
          }
        </script>
      
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strada Link')),
      body: SafeArea(
        child: Container(
          child: InAppWebView(
            initialData:
                InAppWebViewInitialData(data: kTransparentBackgroundPage),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    javaScriptCanOpenWindowsAutomatically: true),
                android:
                    AndroidInAppWebViewOptions(supportMultipleWindows: true)),
            onConsoleMessage: (controller, consoleMessage) {
              print(
                  consoleMessage); // For debugging console logs in the webview
              if (consoleMessage.message.contains('pub_')) {
                RegExp exp = RegExp(r"pub_\w{8}-\w{4}-\w{4}-\w{4}-\w{12}");
                _pubToken = exp.firstMatch(consoleMessage.message)!.group(0)!;
              }
            },
            onCreateWindow: (controller, createWindowRequest) async {
              showDialog(
                context: context,
                builder: (context) {
                  return InAppWebView(
                    windowId: createWindowRequest.windowId,
                    initialOptions: InAppWebViewGroupOptions(),
                    onLoadStart: (controller, url) async {},
                    onLoadStop: (controller, url) async {},
                    onCloseWindow: (controller) async {
                      Navigator.pop(context);
                      widget.onSuccess(_pubToken);
                    },
                  );
                },
              );
              return true;
            },
          ),
        ),
      ),
    );
  }
}
