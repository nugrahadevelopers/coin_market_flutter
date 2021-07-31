class CoinModel {
  String coinId;
  String base;
  String target;
  String last;
  int isUp;

  CoinModel({
    this.coinId = "noId",
    this.base = "noSymbol",
    this.target = "noName",
    this.last = "noPrice",
    this.isUp = 0,
  });

  factory CoinModel.fromJson(Map<String, dynamic> data) {
    return CoinModel(
      coinId: data['coin_id'],
      base: data['base'],
      target: data['target'],
      last: data['last'].toString(),
      isUp: data['is_up'] ?? 0,
    );
  }

  Map<String, dynamic> toDatabaseJson({int? isUpOpt}) {
    return {
      'coin_id': coinId,
      'base': base,
      'target': target,
      'last': last,
      'is_up': isUpOpt,
    };
  }
}
