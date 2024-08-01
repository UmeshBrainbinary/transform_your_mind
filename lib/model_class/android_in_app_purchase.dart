class AndroidSubscriptionData {
  String? orderId;
  String? packageName;
  String? productId;
  int? purchaseTime;
  int? purchaseState;
  String? purchaseToken;
  String? obfuscatedAccountId;
  int? quantity;
  bool? autoRenewing;
  bool? acknowledged;

  AndroidSubscriptionData(
      {this.orderId,
        this.packageName,
        this.productId,
        this.purchaseTime,
        this.purchaseState,
        this.purchaseToken,
        this.obfuscatedAccountId,
        this.quantity,
        this.autoRenewing,
        this.acknowledged});

  AndroidSubscriptionData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    packageName = json['packageName'];
    productId = json['productId'];
    purchaseTime = json['purchaseTime'];
    purchaseState = json['purchaseState'];
    purchaseToken = json['purchaseToken'];
    obfuscatedAccountId = json['obfuscatedAccountId'];
    quantity = json['quantity'];
    autoRenewing = json['autoRenewing'];
    acknowledged = json['acknowledged'];
  }
}
