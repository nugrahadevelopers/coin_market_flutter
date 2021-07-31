import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matel_dev2/homepage/models/coin_model.dart';
import 'package:matel_dev2/homepage/tradingiew_page.dart';

class CoinItem extends StatelessWidget {
  final CoinModel? coin;
  final double? oldPrice;
  const CoinItem({Key? key, this.coin, this.oldPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(coin!.isUp);
    return GestureDetector(
      child: Container(
        // margin: EdgeInsets.only(
        //   bottom: 8,
        // ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: (coin!.isUp == 1)
                        ? Colors.green
                        : (coin!.isUp == 0)
                            ? Colors.red
                            : Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) * 7 / 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                coin!.base + "/",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  coin!.target,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                            ).format(
                              double.parse(coin!.last),
                            ),
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradingViewPage()),
        );
      },
    );
  }
}
