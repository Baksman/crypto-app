import 'dart:convert';

import 'package:crypto_app/model/coin_model.dart';
import 'package:crypto_app/repository/base_crypro_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepository {
  static const baseUrl = "https://min-api.cryptocompare.com";
  static const int perPage = 20;

  final http.Client _httpClient;

  var data;
  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins(int page) async {
    List<Coin> coins = [];
    String requestUrl =
        "$baseUrl/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page";

    try {
      http.Response response = await _httpClient.get(requestUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> coinList = data["Data"];
        coinList.forEach((json) {
          coins.add(Coin.fromJson(json));
        });
      }
      return coins;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
