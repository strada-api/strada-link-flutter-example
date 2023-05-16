import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:strada_link_flutter_example/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StradaLink extends StatefulWidget {
  @override
  _StradaLinkState createState() => _StradaLinkState();
}

class _StradaLinkState extends State<StradaLink> {
  TextEditingController _textFieldController = TextEditingController();
  String _linkAccessToken = '';

  final controller = WebViewController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _openWebview() {
    setState(() {
      _linkAccessToken = _textFieldController.text;
    });
    if (kDebugMode) {
      print(_linkAccessToken);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StradaWebView(
            linkAccessToken: _linkAccessToken,
            key: GlobalKey(),
            controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 340, // set the desired width of the TextField
            child: TextField(
              controller: _textFieldController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter Link Access Token',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(height: 40), // add a 16 pixel vertical space
          FilledButton(
            onPressed: _openWebview,
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)))),
            child:
                const Text('Connect account', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
