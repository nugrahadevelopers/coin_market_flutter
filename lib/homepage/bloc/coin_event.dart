part of 'coin_bloc.dart';

class CoinEvent {}

class FetchCoin extends CoinEvent {}

class LoadCoin extends CoinEvent {}

class UpdateCoin extends CoinEvent {}

class FilterCoin extends CoinEvent {
  FilterCoin({this.query});

  final String? query;
}
