import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewPage extends StatelessWidget {
  const TradingViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: Container(
              child: WebView(
                initialUrl: 'https://indodax.com/chart/BTCIDR',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
