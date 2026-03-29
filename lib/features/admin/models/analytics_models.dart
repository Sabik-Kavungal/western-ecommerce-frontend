import 'package:freezed_annotation/freezed_annotation.dart';

part 'gen/analytics_models.freezed.dart';
part 'gen/analytics_models.g.dart';

@freezed
class TopSellingProduct with _$TopSellingProduct {
  const factory TopSellingProduct({
    required String productId,
    required String productName,
    required int totalSold,
    required double revenue,
  }) = _TopSellingProduct;

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) =>
      _$TopSellingProductFromJson(json);
}

@freezed
class AnalyticsDashboard with _$AnalyticsDashboard {
  const factory AnalyticsDashboard({
    @Default(0) int totalOrders,
    @Default(0) int confirmedOrders,
    @Default(0) int pendingOrders,
    @Default(0) double totalSales,
    @Default(0) double totalWebsiteProfit,
    @Default(0) double totalShopShare,
    @Default(0) double todayRevenue,
    @Default(0) int todayOrders,
    @Default(0) double thisMonthRevenue,
    @Default(0) int thisMonthOrders,
    // Add old fields as defaults mapping or keep them if UI uses them
    @Default(0) double totalRevenue,
    @Default(0) double netProfit,
    @Default(0) double totalCommission,
    @Default([]) List<TopSellingProduct> topSellingProducts,
  }) = _AnalyticsDashboard;

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardFromJson(json);
}

@freezed
class ByDateRow with _$ByDateRow {
  const factory ByDateRow({
    required String date,
    required int orders,
    required double revenue,
  }) = _ByDateRow;

  factory ByDateRow.fromJson(Map<String, dynamic> json) =>
      _$ByDateRowFromJson(json);
}

@freezed
class AnalyticsOrders with _$AnalyticsOrders {
  const factory AnalyticsOrders({
    @Default({}) Map<String, int> byStatus,
    @Default([]) List<ByDateRow> byDate,
  }) = _AnalyticsOrders;

  factory AnalyticsOrders.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOrdersFromJson(json);
}

@freezed
class PopularProductRow with _$PopularProductRow {
  const factory PopularProductRow({
    required String productId,
    required String productName,
    required int totalSold,
    required double revenue,
  }) = _PopularProductRow;

  factory PopularProductRow.fromJson(Map<String, dynamic> json) =>
      _$PopularProductRowFromJson(json);
}

@freezed
class LowStockProduct with _$LowStockProduct {
  const factory LowStockProduct({
    required String productId,
    required String productName,
    required int quantity,
    @Default(true) bool isAvailable,
  }) = _LowStockProduct;

  factory LowStockProduct.fromJson(Map<String, dynamic> json) =>
      _$LowStockProductFromJson(json);
}

@freezed
class AnalyticsProducts with _$AnalyticsProducts {
  const factory AnalyticsProducts({
    @Default([]) List<PopularProductRow> popularProducts,
    @Default([]) List<LowStockProduct> lowStockProducts,
  }) = _AnalyticsProducts;

  factory AnalyticsProducts.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsProductsFromJson(json);
}
