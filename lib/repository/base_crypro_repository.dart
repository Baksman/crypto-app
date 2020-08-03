import "package:crypto_app/model/coin_model.dart";

abstract class BaseCryptoRepository {
  Future<List<Coin>> getTopCoins(int page);

  void dispose();
}
