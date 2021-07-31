import 'package:matel_dev2/homepage/dao/coin_dao.dart';

class CoinRepository {
  final coinDao = CoinDao();

  Future fetchCoinFromAPI({bool isUpdate = false}) =>
      coinDao.fetchCoin(isUpdate: isUpdate);
  Future getAllCoin({String? query}) => coinDao.getCoins(query: query);
  Future deleteAllCoin() => coinDao.deleteAllCoin();
}
