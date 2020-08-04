import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crypto_app/model/coin_model.dart';
import 'package:crypto_app/repository/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  // CryptoBloc() : super(CryptoEmpty());

  final CryptoRepository _cryptoRespository;

  CryptoBloc({@required final cryptoRespository})
      : assert(cryptoRespository != null, "crypto repo is null"),
        _cryptoRespository = cryptoRespository,
        super(CryptoEmpty());

  @override
  Stream<CryptoState> mapEventToState(
    CryptoEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* _getCoins(coins: []);
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinsToState(event);
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield CryptoLoading();
    yield* _getCoins(coins: []);
  }

  Stream<CryptoState> _mapLoadMoreCoinsToState(LoadMoreCoins event) async* {
    final int nextPage = event.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(coins: event.coins, page: nextPage);
  }

  Stream<CryptoState> _getCoins({List coins, int page = 0}) async* {
    try {
      List<Coin> newCoinsList =
          coins + await _cryptoRespository.getTopCoins(page);
      yield CryptoLoaded(newCoinsList);
    } catch (e) {
      yield CryptoError();
    }
  }
}
