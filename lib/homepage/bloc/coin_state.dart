part of 'coin_bloc.dart';

abstract class CoinState {}

class CoinInitial extends CoinState {}

class CoinLoaded extends CoinState {
  List<CoinModel>? coins;
  bool? hasReachedMax;

  CoinLoaded({this.coins, this.hasReachedMax});

  // CoinLoaded copyWith({List<CoinModel>? coins, bool? hasReachedMax}) {
  //   return CoinLoaded(
  //     coins: coins ?? this.coins,
  //     hasReachedMax: hasReachedMax ?? this.hasReachedMax,
  //   );
  // }
}

class CoinUpdated extends CoinState {
  List<CoinModel>? coins;

  CoinUpdated({this.coins});
}
