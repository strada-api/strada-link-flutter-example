import 'package:flutter/foundation.dart';
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
        </div>

        <script>
          const config = {
            linkAccessToken: "${widget.linkAccessToken}",
            env: "${widget.env}",
            onSuccess: (id) => onSuccess(id),
            onReady: () => onReady(),
          };

          function onSuccess(id) {
            
          }

          function onReady() {
            StradaLink.openLink(config);
          }

          const initScript = document.createElement('script');
          initScript.src = 'https://cdn.getstrada.com/link-asset/initialize.js';

          initScript.addEventListener('load', () => {
            StradaLink.initialize(config);
          });

          document.body.appendChild(initScript);
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
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
              onConsoleMessage: (controller, consoleMessage) {
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
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                          javaScriptCanOpenWindowsAutomatically: true,
                        ),
                        windowId: createWindowRequest.windowId,
                        onCloseWindow: (controller) async {
                          Navigator.pop(context);
                          widget.onSuccess(_pubToken);
                        });
                  },
                );
                return true;
              }),
        ),
      ),
    );
  }
}
