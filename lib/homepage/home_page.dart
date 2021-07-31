import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matel_dev2/homepage/bloc/coin_bloc.dart';
import 'package:matel_dev2/homepage/widget/app_bar_ui_widget.dart';
import 'package:matel_dev2/homepage/widget/coin_item_widget.dart';
import 'package:matel_dev2/homepage/widget/search_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  late CoinBloc coinBloc;

  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      coinBloc.add(FetchCoin());
    }
  }

  @override
  Widget build(BuildContext context) {
    coinBloc = context.read<CoinBloc>();
    // controller.addListener(onScroll);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          coinBloc.add(UpdateCoin());
        },
        child: Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          AppBarUIWidget(),
          SearchBarWidget(
            onTextChange: (value) {
              coinBloc.add(
                FilterCoin(query: value),
              );
            },
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: BlocBuilder<CoinBloc, CoinState>(
                builder: (context, state) {
                  if (state is CoinInitial) {
                    return Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is CoinUpdated) {
                    return Text('Event is CoinUpdated');
                  } else {
                    CoinLoaded coinLoaded = state as CoinLoaded;
                    return ListView.builder(
                      controller: controller,
                      itemCount: coinLoaded.coins!.length,
                      // (coinLoaded.hasReachedMax!)
                      //     /? coinLoaded.coins!.length
                      //     : coinLoaded.coins!.length + 1,
                      itemBuilder: (context, index) {
                        return CoinItem(
                          coin: coinLoaded.coins![index],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
