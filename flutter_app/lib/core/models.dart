class ApiUser {
  final String id;
  final String? email;
  final String? phone;
  final String? username;
  final String? sponsorId;
  final String? parentId;
  final int? matrixLevel;
  final int? qualificationLevel;
  final String? activityStatus;
  final bool? isActive;

  ApiUser({
    required this.id,
    this.email,
    this.phone,
    this.username,
    this.sponsorId,
    this.parentId,
    this.matrixLevel,
    this.qualificationLevel,
    this.activityStatus,
    this.isActive,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) => ApiUser(
        id: json['id'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        username: json['username'] as String?,
        sponsorId: json['sponsorId'] as String?,
        parentId: json['parentId'] as String?,
        matrixLevel: (json['matrixLevel'] as num?)?.toInt(),
        qualificationLevel: (json['qualificationLevel'] as num?)?.toInt(),
        activityStatus: json['activityStatus'] as String?,
        isActive: json['isActive'] as bool?,
      );
}

class WalletData {
  final String id;
  final String userId;
  final double mainBalance;
  final double referralBalance;
  final double tokenBalance;
  final String currency;

  WalletData({
    required this.id,
    required this.userId,
    required this.mainBalance,
    required this.referralBalance,
    required this.tokenBalance,
    required this.currency,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        id: json['id'] as String,
        userId: json['userId'] as String,
        mainBalance: (json['mainBalance'] is String)
            ? double.tryParse(json['mainBalance']) ?? 0
            : (json['mainBalance'] as num).toDouble(),
        referralBalance: (json['referralBalance'] is String)
            ? double.tryParse(json['referralBalance']) ?? 0
            : (json['referralBalance'] as num).toDouble(),
        tokenBalance: (json['tokenBalance'] is String)
            ? double.tryParse(json['tokenBalance']) ?? 0
            : (json['tokenBalance'] as num).toDouble(),
        currency: json['currency'] as String,
      );
}

class TransactionItem {
  final String id;
  final String type;
  final String status;
  final double amount;
  final String currency;
  final String? referenceId;
  final String? description;
  final DateTime createdAt;

  TransactionItem({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.referenceId,
    this.description,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        id: json['id'] as String,
        type: json['type'] as String,
        status: json['status'] as String,
        amount: (json['amount'] is String)
            ? double.tryParse(json['amount']) ?? 0
            : (json['amount'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'INR',
        referenceId: json['referenceId'] as String?,
        description: json['description'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class PlanItem {
  final String id;
  final String name;
  final double priceUsd;
  final double tokens;
  final bool active;

  PlanItem({required this.id, required this.name, required this.priceUsd, required this.tokens, required this.active});

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
        id: json['id'] as String,
        name: json['name'] as String,
        priceUsd: (json['priceUsd'] is String)
            ? double.tryParse(json['priceUsd']) ?? 0
            : (json['priceUsd'] as num).toDouble(),
        tokens: (json['tokens'] is String)
            ? double.tryParse(json['tokens']) ?? 0
            : (json['tokens'] as num).toDouble(),
        active: json['active'] as bool? ?? true,
      );
}

class TokenPurchaseItem {
  final String id;
  final String planId;
  final String transactionId;
  final String status;
  final double priceUsd;
  final double priceInr;
  final double tokens;
  final DateTime createdAt;

  TokenPurchaseItem({
    required this.id,
    required this.planId,
    required this.transactionId,
    required this.status,
    required this.priceUsd,
    required this.priceInr,
    required this.tokens,
    required this.createdAt,
  });

  factory TokenPurchaseItem.fromJson(Map<String, dynamic> json) => TokenPurchaseItem(
        id: json['id'] as String,
        planId: json['planId'] as String,
        transactionId: json['transactionId'] as String,
        status: json['status'] as String,
        priceUsd: (json['priceUsd'] is String)
            ? double.tryParse(json['priceUsd']) ?? 0
            : (json['priceUsd'] as num).toDouble(),
        priceInr: (json['priceInr'] is String)
            ? double.tryParse(json['priceInr']) ?? 0
            : (json['priceInr'] as num).toDouble(),
        tokens: (json['tokens'] is String)
            ? double.tryParse(json['tokens']) ?? 0
            : (json['tokens'] as num).toDouble(),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class NotificationItem {
  final String id;
  final String? title;
  final String? message;
  final String? type;
  final bool? read;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    this.title,
    this.message,
    this.type,
    this.read,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String?,
        message: json['message'] as String?,
        type: json['type'] as String?,
        read: json['read'] as bool?,
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      );
}

class DownlineMember {
  final String id;
  final String? sponsorId;
  final String? parentId;
  final int? level;
  final int? matrixLevel;
  final String? username;
  final String? email;
  final String? phone;
  final int? qualificationLevel;
  final String? activityStatus;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? lastPlanRenewalAt;

  DownlineMember({
    required this.id,
    this.sponsorId,
    this.parentId,
    this.level,
    this.matrixLevel,
    this.username,
    this.email,
    this.phone,
    this.qualificationLevel,
    this.activityStatus,
    this.isActive,
    this.createdAt,
    this.lastPlanRenewalAt,
  });

  factory DownlineMember.fromJson(Map<String, dynamic> json) => DownlineMember(
        id: json['id'] as String,
        sponsorId: json['sponsorId'] as String?,
        parentId: json['parentId'] as String?,
        level: (json['level'] as num?)?.toInt(),
        matrixLevel: (json['matrixLevel'] as num?)?.toInt(),
        username: json['username'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        qualificationLevel: (json['qualificationLevel'] as num?)?.toInt(),
        activityStatus: json['activityStatus'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
        lastPlanRenewalAt: json['lastPlanRenewalAt'] != null ? DateTime.tryParse(json['lastPlanRenewalAt']) : null,
      );
}

class CommissionEntry {
  final String id;
  final String? sourceUserId;
  final int level;
  final double amount;
  final String currency;
  final String status;
  final String? reason;
  final String? eventRef;
  final String? walletTransactionId;
  final DateTime createdAt;

  CommissionEntry({
    required this.id,
    required this.level,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.sourceUserId,
    this.reason,
    this.eventRef,
    this.walletTransactionId,
  });

  factory CommissionEntry.fromJson(Map<String, dynamic> json) => CommissionEntry(
        id: json['id'] as String,
        sourceUserId: json['sourceUserId'] as String?,
        level: (json['level'] as num).toInt(),
        amount: (json['amount'] is String)
            ? double.tryParse(json['amount']) ?? 0
            : (json['amount'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'INR',
        status: json['status'] as String,
        reason: json['reason'] as String?,
        eventRef: json['eventRef'] as String?,
        walletTransactionId: json['walletTransactionId'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}
