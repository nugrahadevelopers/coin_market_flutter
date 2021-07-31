import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matel_dev2/homepage/database/database.dart';
import 'package:matel_dev2/homepage/models/coin_model.dart';
import 'package:sqflite/sql.dart';

class CoinDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> fetchCoin({bool isUpdate = false}) async {
    int result = 0;
    int start = 2;
    // int limit = 250;
    for (int i = 1; i <= start; i++) {
      print(i);
      var apiURL = Uri.parse(
          "https://api.coingecko.com/api/v3/exchanges/indodax/tickers?page=" +
              i.toString() +
              "&order=volume_desc");

      try {
        var apiResult = await http.get(apiURL);

        if (apiResult.statusCode == 200) {
          List jsonObject = json.decode(apiResult.body)['tickers'];
          if (isUpdate == true) {
            print('update coin');
            result = await updateCoin(
                jsonObject.map((item) => CoinModel.fromJson(item)).toList());
          }

          result = await createCoin(
              jsonObject.map((item) => CoinModel.fromJson(item)).toList());
        } else {
          print('Cek Internet');
        }
      } catch (e) {
        print('error fetchCoin : $e');
      }
    }
    return result;
  }

  Future<int> createCoin(List<CoinModel> coins) async {
    int result = 0;
    final db = await dbProvider.database;
    for (var coin in coins) {
      try {
        if (coin.target != 'USDT') {
          result = await db!.insert(
            coinTable,
            coin.toDatabaseJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (error) {
        print('Error insert db: $error');
      }
    }

    return result;
  }

  Future<List<CoinModel>> getCoins(
      {List<String>? columns, String? query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>>? result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db!.query(
          coinTable,
          columns: columns,
          where: 'base LIKE ?',
          whereArgs: ["%$query%"],
        );
      }
    } else {
      result = await db!.query(
        coinTable,
        columns: columns,
      );
    }

    List<CoinModel> coins;
    if (result!.isNotEmpty) {
      coins = result.map((item) => CoinModel.fromJson(item)).toList();
    } else {
      coins = [];
    }

    return coins;
  }

  getOldCoins() async {
    final db = await dbProvider.database;

    try {
      List<Map<String, dynamic>>? result;
      result = await db!.query(
        coinTable,
      );

      List<CoinModel> coins;
      if (result.isNotEmpty) {
        coins = result.map((item) => CoinModel.fromJson(item)).toList();
      } else {
        coins = [];
      }

      return coins;
    } catch (e) {
      print('getOldCoin error : $e');
    }
  }

  Future<int> updateCoin(List<CoinModel> coins) async {
    int result = 0;
    final db = await dbProvider.database;
    // List<CoinModel> oldCoins = await getOldCoins();

    for (var coin in coins) {
      int? coinup = 1;
      if (coin.target != 'USDT') {
        result = await db!.update(
          coinTable,
          coin.toDatabaseJson(
            isUpOpt: coinup,
          ),
          where: "coin_id = ?",
          whereArgs: [coin.coinId],
        );
      }

      // for (var oldCoin in oldCoins) {
      //   try {
      //     if (coin.target != 'USDT') {
      //       if (double.parse(oldCoin.last) < double.parse(coin.last)) {
      //         int? coinup = 1;
      //         result = await db!.update(
      //           coinTable,
      //           coin.toDatabaseJson(
      //             isUpOpt: coinup,
      //           ),
      //           where: "coin_id = ?",
      //           whereArgs: [coin.coinId],
      //         );
      //       } else if (double.parse(oldCoin.last) > double.parse(coin.last)) {
      //         int? coinup = 0;
      //         result = await db!.update(
      //           coinTable,
      //           coin.toDatabaseJson(
      //             isUpOpt: coinup,
      //           ),
      //           where: "coin_id = ?",
      //           whereArgs: [coin.coinId],
      //         );
      //       } else if (double.parse(oldCoin.last) == double.parse(coin.last)) {
      //         int? coinup = 2;
      //         result = await db!.update(
      //           coinTable,
      //           coin.toDatabaseJson(
      //             isUpOpt: coinup,
      //           ),
      //           where: "coin_id = ?",
      //           whereArgs: [coin.coinId],
      //         );
      //       }
      //     }
      //   } catch (error) {
      //     print('Error update db: $error');
      //   }
      // }
    }

    return result;
  }

  Future deleteAllCoin() async {
    final db = await dbProvider.database;

    var result = await db!.delete(coinTable);

    return result;
  }
}
