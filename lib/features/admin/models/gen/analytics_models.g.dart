// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopSellingProductImpl _$$TopSellingProductImplFromJson(
  Map<String, dynamic> json,
) => _$TopSellingProductImpl(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  totalSold: (json['totalSold'] as num).toInt(),
  revenue: (json['revenue'] as num).toDouble(),
);

Map<String, dynamic> _$$TopSellingProductImplToJson(
  _$TopSellingProductImpl instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productName': instance.productName,
  'totalSold': instance.totalSold,
  'revenue': instance.revenue,
};

_$AnalyticsDashboardImpl _$$AnalyticsDashboardImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsDashboardImpl(
  totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
  confirmedOrders: (json['confirmedOrders'] as num?)?.toInt() ?? 0,
  pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
  totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
  totalWebsiteProfit: (json['totalWebsiteProfit'] as num?)?.toDouble() ?? 0,
  totalShopShare: (json['totalShopShare'] as num?)?.toDouble() ?? 0,
  todayRevenue: (json['todayRevenue'] as num?)?.toDouble() ?? 0,
  todayOrders: (json['todayOrders'] as num?)?.toInt() ?? 0,
  thisMonthRevenue: (json['thisMonthRevenue'] as num?)?.toDouble() ?? 0,
  thisMonthOrders: (json['thisMonthOrders'] as num?)?.toInt() ?? 0,
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
  netProfit: (json['netProfit'] as num?)?.toDouble() ?? 0,
  totalCommission: (json['totalCommission'] as num?)?.toDouble() ?? 0,
  topSellingProducts:
      (json['topSellingProducts'] as List<dynamic>?)
          ?.map((e) => TopSellingProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AnalyticsDashboardImplToJson(
  _$AnalyticsDashboardImpl instance,
) => <String, dynamic>{
  'totalOrders': instance.totalOrders,
  'confirmedOrders': instance.confirmedOrders,
  'pendingOrders': instance.pendingOrders,
  'totalSales': instance.totalSales,
  'totalWebsiteProfit': instance.totalWebsiteProfit,
  'totalShopShare': instance.totalShopShare,
  'todayRevenue': instance.todayRevenue,
  'todayOrders': instance.todayOrders,
  'thisMonthRevenue': instance.thisMonthRevenue,
  'thisMonthOrders': instance.thisMonthOrders,
  'totalRevenue': instance.totalRevenue,
  'netProfit': instance.netProfit,
  'totalCommission': instance.totalCommission,
  'topSellingProducts': instance.topSellingProducts,
};

_$ByDateRowImpl _$$ByDateRowImplFromJson(Map<String, dynamic> json) =>
    _$ByDateRowImpl(
      date: json['date'] as String,
      orders: (json['orders'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$ByDateRowImplToJson(_$ByDateRowImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'orders': instance.orders,
      'revenue': instance.revenue,
    };

_$AnalyticsOrdersImpl _$$AnalyticsOrdersImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsOrdersImpl(
  byStatus:
      (json['byStatus'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  byDate:
      (json['byDate'] as List<dynamic>?)
          ?.map((e) => ByDateRow.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AnalyticsOrdersImplToJson(
  _$AnalyticsOrdersImpl instance,
) => <String, dynamic>{
  'byStatus': instance.byStatus,
  'byDate': instance.byDate,
};

_$PopularProductRowImpl _$$PopularProductRowImplFromJson(
  Map<String, dynamic> json,
) => _$PopularProductRowImpl(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  totalSold: (json['totalSold'] as num).toInt(),
  revenue: (json['revenue'] as num).toDouble(),
);

Map<String, dynamic> _$$PopularProductRowImplToJson(
  _$PopularProductRowImpl instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productName': instance.productName,
  'totalSold': instance.totalSold,
  'revenue': instance.revenue,
};

_$LowStockProductImpl _$$LowStockProductImplFromJson(
  Map<String, dynamic> json,
) => _$LowStockProductImpl(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  quantity: (json['quantity'] as num).toInt(),
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$$LowStockProductImplToJson(
  _$LowStockProductImpl instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productName': instance.productName,
  'quantity': instance.quantity,
  'isAvailable': instance.isAvailable,
};

_$AnalyticsProductsImpl _$$AnalyticsProductsImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsProductsImpl(
  popularProducts:
      (json['popularProducts'] as List<dynamic>?)
          ?.map((e) => PopularProductRow.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lowStockProducts:
      (json['lowStockProducts'] as List<dynamic>?)
          ?.map((e) => LowStockProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AnalyticsProductsImplToJson(
  _$AnalyticsProductsImpl instance,
) => <String, dynamic>{
  'popularProducts': instance.popularProducts,
  'lowStockProducts': instance.lowStockProducts,
};
