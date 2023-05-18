import 'package:flutter/material.dart';
import 'package:strada_link_flutter_example/webview.dart';

class StradaLink extends StatefulWidget {
  @override
  _StradaLinkState createState() => _StradaLinkState();
}

class _StradaLinkState extends State<StradaLink> {
  TextEditingController _textFieldController = TextEditingController();
  String _linkAccessToken = '';
  late String _linkPublicToken = '';

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _onSuccess(pubToken) {
    print('public connection token: $pubToken');
    setState(() {
      _linkPublicToken = pubToken;
    });
    Navigator.pop(context);
  }

  void _onReady() {
    print('ready');
  }

  void _openWebview() {
    setState(() {
      _linkAccessToken = _textFieldController.text;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StradaWebView(
            env: 'local',
            linkAccessToken: _linkAccessToken,
            key: GlobalKey(),
            onSuccess: _onSuccess,
            onReady: _onReady),
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
          Container(height: 40),
          Container(
            width: 340, // set the desired width of the TextField
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              child: Center(
                child: Text(_linkPublicToken),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
