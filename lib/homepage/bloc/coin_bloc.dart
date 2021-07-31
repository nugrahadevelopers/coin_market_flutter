import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matel_dev2/homepage/models/coin_model.dart';
import 'package:matel_dev2/homepage/repository/coin_repository.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc() : super(CoinInitial());

  @override
  Stream<CoinState> mapEventToState(
    CoinEvent event,
  ) async* {
    final _coinRepository = CoinRepository();
    List<CoinModel> coins;

    if (event is FetchCoin) {
      await _coinRepository.deleteAllCoin();
      await _coinRepository.fetchCoinFromAPI();
      coins = await _coinRepository.getAllCoin();
      yield CoinLoaded(coins: coins, hasReachedMax: false);
    } else if (event is LoadCoin) {
      coins = await _coinRepository.getAllCoin();
      yield CoinLoaded(coins: coins, hasReachedMax: false);
    } else if (event is UpdateCoin) {
      await _coinRepository.fetchCoinFromAPI(isUpdate: true);
      coins = await _coinRepository.getAllCoin();
      yield CoinLoaded(coins: coins, hasReachedMax: false);
    } else if (event is FilterCoin) {
      final query = event.query;
      if (query!.isNotEmpty) {
        coins = await _coinRepository.getAllCoin(query: query);
        yield CoinLoaded(coins: coins, hasReachedMax: false);
      } else {
        coins = await _coinRepository.getAllCoin();
        yield CoinLoaded(coins: coins, hasReachedMax: false);
      }
    }
  }
}
