// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../analytics_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TopSellingProduct _$TopSellingProductFromJson(Map<String, dynamic> json) {
  return _TopSellingProduct.fromJson(json);
}

/// @nodoc
mixin _$TopSellingProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get totalSold => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this TopSellingProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopSellingProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopSellingProductCopyWith<TopSellingProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopSellingProductCopyWith<$Res> {
  factory $TopSellingProductCopyWith(
    TopSellingProduct value,
    $Res Function(TopSellingProduct) then,
  ) = _$TopSellingProductCopyWithImpl<$Res, TopSellingProduct>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalSold,
    double revenue,
  });
}

/// @nodoc
class _$TopSellingProductCopyWithImpl<$Res, $Val extends TopSellingProduct>
    implements $TopSellingProductCopyWith<$Res> {
  _$TopSellingProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopSellingProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
    Object? revenue = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalSold: null == totalSold
                ? _value.totalSold
                : totalSold // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopSellingProductImplCopyWith<$Res>
    implements $TopSellingProductCopyWith<$Res> {
  factory _$$TopSellingProductImplCopyWith(
    _$TopSellingProductImpl value,
    $Res Function(_$TopSellingProductImpl) then,
  ) = __$$TopSellingProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalSold,
    double revenue,
  });
}

/// @nodoc
class __$$TopSellingProductImplCopyWithImpl<$Res>
    extends _$TopSellingProductCopyWithImpl<$Res, _$TopSellingProductImpl>
    implements _$$TopSellingProductImplCopyWith<$Res> {
  __$$TopSellingProductImplCopyWithImpl(
    _$TopSellingProductImpl _value,
    $Res Function(_$TopSellingProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopSellingProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
    Object? revenue = null,
  }) {
    return _then(
      _$TopSellingProductImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalSold: null == totalSold
            ? _value.totalSold
            : totalSold // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopSellingProductImpl implements _TopSellingProduct {
  const _$TopSellingProductImpl({
    required this.productId,
    required this.productName,
    required this.totalSold,
    required this.revenue,
  });

  factory _$TopSellingProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopSellingProductImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int totalSold;
  @override
  final double revenue;

  @override
  String toString() {
    return 'TopSellingProduct(productId: $productId, productName: $productName, totalSold: $totalSold, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopSellingProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.totalSold, totalSold) ||
                other.totalSold == totalSold) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, totalSold, revenue);

  /// Create a copy of TopSellingProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopSellingProductImplCopyWith<_$TopSellingProductImpl> get copyWith =>
      __$$TopSellingProductImplCopyWithImpl<_$TopSellingProductImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopSellingProductImplToJson(this);
  }
}

abstract class _TopSellingProduct implements TopSellingProduct {
  const factory _TopSellingProduct({
    required final String productId,
    required final String productName,
    required final int totalSold,
    required final double revenue,
  }) = _$TopSellingProductImpl;

  factory _TopSellingProduct.fromJson(Map<String, dynamic> json) =
      _$TopSellingProductImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get totalSold;
  @override
  double get revenue;

  /// Create a copy of TopSellingProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopSellingProductImplCopyWith<_$TopSellingProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsDashboard _$AnalyticsDashboardFromJson(Map<String, dynamic> json) {
  return _AnalyticsDashboard.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsDashboard {
  int get totalOrders => throw _privateConstructorUsedError;
  int get confirmedOrders => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;
  double get totalSales => throw _privateConstructorUsedError;
  double get totalWebsiteProfit => throw _privateConstructorUsedError;
  double get totalShopShare => throw _privateConstructorUsedError;
  double get todayRevenue => throw _privateConstructorUsedError;
  int get todayOrders => throw _privateConstructorUsedError;
  double get thisMonthRevenue => throw _privateConstructorUsedError;
  int get thisMonthOrders =>
      throw _privateConstructorUsedError; // Add old fields as defaults mapping or keep them if UI uses them
  double get totalRevenue => throw _privateConstructorUsedError;
  double get netProfit => throw _privateConstructorUsedError;
  double get totalCommission => throw _privateConstructorUsedError;
  List<TopSellingProduct> get topSellingProducts =>
      throw _privateConstructorUsedError;

  /// Serializes this AnalyticsDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDashboardCopyWith<AnalyticsDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDashboardCopyWith<$Res> {
  factory $AnalyticsDashboardCopyWith(
    AnalyticsDashboard value,
    $Res Function(AnalyticsDashboard) then,
  ) = _$AnalyticsDashboardCopyWithImpl<$Res, AnalyticsDashboard>;
  @useResult
  $Res call({
    int totalOrders,
    int confirmedOrders,
    int pendingOrders,
    double totalSales,
    double totalWebsiteProfit,
    double totalShopShare,
    double todayRevenue,
    int todayOrders,
    double thisMonthRevenue,
    int thisMonthOrders,
    double totalRevenue,
    double netProfit,
    double totalCommission,
    List<TopSellingProduct> topSellingProducts,
  });
}

/// @nodoc
class _$AnalyticsDashboardCopyWithImpl<$Res, $Val extends AnalyticsDashboard>
    implements $AnalyticsDashboardCopyWith<$Res> {
  _$AnalyticsDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? confirmedOrders = null,
    Object? pendingOrders = null,
    Object? totalSales = null,
    Object? totalWebsiteProfit = null,
    Object? totalShopShare = null,
    Object? todayRevenue = null,
    Object? todayOrders = null,
    Object? thisMonthRevenue = null,
    Object? thisMonthOrders = null,
    Object? totalRevenue = null,
    Object? netProfit = null,
    Object? totalCommission = null,
    Object? topSellingProducts = null,
  }) {
    return _then(
      _value.copyWith(
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            confirmedOrders: null == confirmedOrders
                ? _value.confirmedOrders
                : confirmedOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingOrders: null == pendingOrders
                ? _value.pendingOrders
                : pendingOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as double,
            totalWebsiteProfit: null == totalWebsiteProfit
                ? _value.totalWebsiteProfit
                : totalWebsiteProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            totalShopShare: null == totalShopShare
                ? _value.totalShopShare
                : totalShopShare // ignore: cast_nullable_to_non_nullable
                      as double,
            todayRevenue: null == todayRevenue
                ? _value.todayRevenue
                : todayRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            todayOrders: null == todayOrders
                ? _value.todayOrders
                : todayOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            thisMonthRevenue: null == thisMonthRevenue
                ? _value.thisMonthRevenue
                : thisMonthRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            thisMonthOrders: null == thisMonthOrders
                ? _value.thisMonthOrders
                : thisMonthOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            netProfit: null == netProfit
                ? _value.netProfit
                : netProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            totalCommission: null == totalCommission
                ? _value.totalCommission
                : totalCommission // ignore: cast_nullable_to_non_nullable
                      as double,
            topSellingProducts: null == topSellingProducts
                ? _value.topSellingProducts
                : topSellingProducts // ignore: cast_nullable_to_non_nullable
                      as List<TopSellingProduct>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsDashboardImplCopyWith<$Res>
    implements $AnalyticsDashboardCopyWith<$Res> {
  factory _$$AnalyticsDashboardImplCopyWith(
    _$AnalyticsDashboardImpl value,
    $Res Function(_$AnalyticsDashboardImpl) then,
  ) = __$$AnalyticsDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalOrders,
    int confirmedOrders,
    int pendingOrders,
    double totalSales,
    double totalWebsiteProfit,
    double totalShopShare,
    double todayRevenue,
    int todayOrders,
    double thisMonthRevenue,
    int thisMonthOrders,
    double totalRevenue,
    double netProfit,
    double totalCommission,
    List<TopSellingProduct> topSellingProducts,
  });
}

/// @nodoc
class __$$AnalyticsDashboardImplCopyWithImpl<$Res>
    extends _$AnalyticsDashboardCopyWithImpl<$Res, _$AnalyticsDashboardImpl>
    implements _$$AnalyticsDashboardImplCopyWith<$Res> {
  __$$AnalyticsDashboardImplCopyWithImpl(
    _$AnalyticsDashboardImpl _value,
    $Res Function(_$AnalyticsDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? confirmedOrders = null,
    Object? pendingOrders = null,
    Object? totalSales = null,
    Object? totalWebsiteProfit = null,
    Object? totalShopShare = null,
    Object? todayRevenue = null,
    Object? todayOrders = null,
    Object? thisMonthRevenue = null,
    Object? thisMonthOrders = null,
    Object? totalRevenue = null,
    Object? netProfit = null,
    Object? totalCommission = null,
    Object? topSellingProducts = null,
  }) {
    return _then(
      _$AnalyticsDashboardImpl(
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        confirmedOrders: null == confirmedOrders
            ? _value.confirmedOrders
            : confirmedOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingOrders: null == pendingOrders
            ? _value.pendingOrders
            : pendingOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as double,
        totalWebsiteProfit: null == totalWebsiteProfit
            ? _value.totalWebsiteProfit
            : totalWebsiteProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        totalShopShare: null == totalShopShare
            ? _value.totalShopShare
            : totalShopShare // ignore: cast_nullable_to_non_nullable
                  as double,
        todayRevenue: null == todayRevenue
            ? _value.todayRevenue
            : todayRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        todayOrders: null == todayOrders
            ? _value.todayOrders
            : todayOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        thisMonthRevenue: null == thisMonthRevenue
            ? _value.thisMonthRevenue
            : thisMonthRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        thisMonthOrders: null == thisMonthOrders
            ? _value.thisMonthOrders
            : thisMonthOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        netProfit: null == netProfit
            ? _value.netProfit
            : netProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        totalCommission: null == totalCommission
            ? _value.totalCommission
            : totalCommission // ignore: cast_nullable_to_non_nullable
                  as double,
        topSellingProducts: null == topSellingProducts
            ? _value._topSellingProducts
            : topSellingProducts // ignore: cast_nullable_to_non_nullable
                  as List<TopSellingProduct>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDashboardImpl implements _AnalyticsDashboard {
  const _$AnalyticsDashboardImpl({
    this.totalOrders = 0,
    this.confirmedOrders = 0,
    this.pendingOrders = 0,
    this.totalSales = 0,
    this.totalWebsiteProfit = 0,
    this.totalShopShare = 0,
    this.todayRevenue = 0,
    this.todayOrders = 0,
    this.thisMonthRevenue = 0,
    this.thisMonthOrders = 0,
    this.totalRevenue = 0,
    this.netProfit = 0,
    this.totalCommission = 0,
    final List<TopSellingProduct> topSellingProducts = const [],
  }) : _topSellingProducts = topSellingProducts;

  factory _$AnalyticsDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDashboardImplFromJson(json);

  @override
  @JsonKey()
  final int totalOrders;
  @override
  @JsonKey()
  final int confirmedOrders;
  @override
  @JsonKey()
  final int pendingOrders;
  @override
  @JsonKey()
  final double totalSales;
  @override
  @JsonKey()
  final double totalWebsiteProfit;
  @override
  @JsonKey()
  final double totalShopShare;
  @override
  @JsonKey()
  final double todayRevenue;
  @override
  @JsonKey()
  final int todayOrders;
  @override
  @JsonKey()
  final double thisMonthRevenue;
  @override
  @JsonKey()
  final int thisMonthOrders;
  // Add old fields as defaults mapping or keep them if UI uses them
  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final double netProfit;
  @override
  @JsonKey()
  final double totalCommission;
  final List<TopSellingProduct> _topSellingProducts;
  @override
  @JsonKey()
  List<TopSellingProduct> get topSellingProducts {
    if (_topSellingProducts is EqualUnmodifiableListView)
      return _topSellingProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSellingProducts);
  }

  @override
  String toString() {
    return 'AnalyticsDashboard(totalOrders: $totalOrders, confirmedOrders: $confirmedOrders, pendingOrders: $pendingOrders, totalSales: $totalSales, totalWebsiteProfit: $totalWebsiteProfit, totalShopShare: $totalShopShare, todayRevenue: $todayRevenue, todayOrders: $todayOrders, thisMonthRevenue: $thisMonthRevenue, thisMonthOrders: $thisMonthOrders, totalRevenue: $totalRevenue, netProfit: $netProfit, totalCommission: $totalCommission, topSellingProducts: $topSellingProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDashboardImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.confirmedOrders, confirmedOrders) ||
                other.confirmedOrders == confirmedOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalWebsiteProfit, totalWebsiteProfit) ||
                other.totalWebsiteProfit == totalWebsiteProfit) &&
            (identical(other.totalShopShare, totalShopShare) ||
                other.totalShopShare == totalShopShare) &&
            (identical(other.todayRevenue, todayRevenue) ||
                other.todayRevenue == todayRevenue) &&
            (identical(other.todayOrders, todayOrders) ||
                other.todayOrders == todayOrders) &&
            (identical(other.thisMonthRevenue, thisMonthRevenue) ||
                other.thisMonthRevenue == thisMonthRevenue) &&
            (identical(other.thisMonthOrders, thisMonthOrders) ||
                other.thisMonthOrders == thisMonthOrders) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.totalCommission, totalCommission) ||
                other.totalCommission == totalCommission) &&
            const DeepCollectionEquality().equals(
              other._topSellingProducts,
              _topSellingProducts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalOrders,
    confirmedOrders,
    pendingOrders,
    totalSales,
    totalWebsiteProfit,
    totalShopShare,
    todayRevenue,
    todayOrders,
    thisMonthRevenue,
    thisMonthOrders,
    totalRevenue,
    netProfit,
    totalCommission,
    const DeepCollectionEquality().hash(_topSellingProducts),
  );

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      __$$AnalyticsDashboardImplCopyWithImpl<_$AnalyticsDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDashboardImplToJson(this);
  }
}

abstract class _AnalyticsDashboard implements AnalyticsDashboard {
  const factory _AnalyticsDashboard({
    final int totalOrders,
    final int confirmedOrders,
    final int pendingOrders,
    final double totalSales,
    final double totalWebsiteProfit,
    final double totalShopShare,
    final double todayRevenue,
    final int todayOrders,
    final double thisMonthRevenue,
    final int thisMonthOrders,
    final double totalRevenue,
    final double netProfit,
    final double totalCommission,
    final List<TopSellingProduct> topSellingProducts,
  }) = _$AnalyticsDashboardImpl;

  factory _AnalyticsDashboard.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDashboardImpl.fromJson;

  @override
  int get totalOrders;
  @override
  int get confirmedOrders;
  @override
  int get pendingOrders;
  @override
  double get totalSales;
  @override
  double get totalWebsiteProfit;
  @override
  double get totalShopShare;
  @override
  double get todayRevenue;
  @override
  int get todayOrders;
  @override
  double get thisMonthRevenue;
  @override
  int get thisMonthOrders; // Add old fields as defaults mapping or keep them if UI uses them
  @override
  double get totalRevenue;
  @override
  double get netProfit;
  @override
  double get totalCommission;
  @override
  List<TopSellingProduct> get topSellingProducts;

  /// Create a copy of AnalyticsDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDashboardImplCopyWith<_$AnalyticsDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ByDateRow _$ByDateRowFromJson(Map<String, dynamic> json) {
  return _ByDateRow.fromJson(json);
}

/// @nodoc
mixin _$ByDateRow {
  String get date => throw _privateConstructorUsedError;
  int get orders => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this ByDateRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ByDateRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ByDateRowCopyWith<ByDateRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ByDateRowCopyWith<$Res> {
  factory $ByDateRowCopyWith(ByDateRow value, $Res Function(ByDateRow) then) =
      _$ByDateRowCopyWithImpl<$Res, ByDateRow>;
  @useResult
  $Res call({String date, int orders, double revenue});
}

/// @nodoc
class _$ByDateRowCopyWithImpl<$Res, $Val extends ByDateRow>
    implements $ByDateRowCopyWith<$Res> {
  _$ByDateRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ByDateRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? orders = null,
    Object? revenue = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            orders: null == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ByDateRowImplCopyWith<$Res>
    implements $ByDateRowCopyWith<$Res> {
  factory _$$ByDateRowImplCopyWith(
    _$ByDateRowImpl value,
    $Res Function(_$ByDateRowImpl) then,
  ) = __$$ByDateRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, int orders, double revenue});
}

/// @nodoc
class __$$ByDateRowImplCopyWithImpl<$Res>
    extends _$ByDateRowCopyWithImpl<$Res, _$ByDateRowImpl>
    implements _$$ByDateRowImplCopyWith<$Res> {
  __$$ByDateRowImplCopyWithImpl(
    _$ByDateRowImpl _value,
    $Res Function(_$ByDateRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ByDateRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? orders = null,
    Object? revenue = null,
  }) {
    return _then(
      _$ByDateRowImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        orders: null == orders
            ? _value.orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ByDateRowImpl implements _ByDateRow {
  const _$ByDateRowImpl({
    required this.date,
    required this.orders,
    required this.revenue,
  });

  factory _$ByDateRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$ByDateRowImplFromJson(json);

  @override
  final String date;
  @override
  final int orders;
  @override
  final double revenue;

  @override
  String toString() {
    return 'ByDateRow(date: $date, orders: $orders, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ByDateRowImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.orders, orders) || other.orders == orders) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, orders, revenue);

  /// Create a copy of ByDateRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ByDateRowImplCopyWith<_$ByDateRowImpl> get copyWith =>
      __$$ByDateRowImplCopyWithImpl<_$ByDateRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ByDateRowImplToJson(this);
  }
}

abstract class _ByDateRow implements ByDateRow {
  const factory _ByDateRow({
    required final String date,
    required final int orders,
    required final double revenue,
  }) = _$ByDateRowImpl;

  factory _ByDateRow.fromJson(Map<String, dynamic> json) =
      _$ByDateRowImpl.fromJson;

  @override
  String get date;
  @override
  int get orders;
  @override
  double get revenue;

  /// Create a copy of ByDateRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ByDateRowImplCopyWith<_$ByDateRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsOrders _$AnalyticsOrdersFromJson(Map<String, dynamic> json) {
  return _AnalyticsOrders.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsOrders {
  Map<String, int> get byStatus => throw _privateConstructorUsedError;
  List<ByDateRow> get byDate => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsOrders to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsOrders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsOrdersCopyWith<AnalyticsOrders> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsOrdersCopyWith<$Res> {
  factory $AnalyticsOrdersCopyWith(
    AnalyticsOrders value,
    $Res Function(AnalyticsOrders) then,
  ) = _$AnalyticsOrdersCopyWithImpl<$Res, AnalyticsOrders>;
  @useResult
  $Res call({Map<String, int> byStatus, List<ByDateRow> byDate});
}

/// @nodoc
class _$AnalyticsOrdersCopyWithImpl<$Res, $Val extends AnalyticsOrders>
    implements $AnalyticsOrdersCopyWith<$Res> {
  _$AnalyticsOrdersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsOrders
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byStatus = null, Object? byDate = null}) {
    return _then(
      _value.copyWith(
            byStatus: null == byStatus
                ? _value.byStatus
                : byStatus // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            byDate: null == byDate
                ? _value.byDate
                : byDate // ignore: cast_nullable_to_non_nullable
                      as List<ByDateRow>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsOrdersImplCopyWith<$Res>
    implements $AnalyticsOrdersCopyWith<$Res> {
  factory _$$AnalyticsOrdersImplCopyWith(
    _$AnalyticsOrdersImpl value,
    $Res Function(_$AnalyticsOrdersImpl) then,
  ) = __$$AnalyticsOrdersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, int> byStatus, List<ByDateRow> byDate});
}

/// @nodoc
class __$$AnalyticsOrdersImplCopyWithImpl<$Res>
    extends _$AnalyticsOrdersCopyWithImpl<$Res, _$AnalyticsOrdersImpl>
    implements _$$AnalyticsOrdersImplCopyWith<$Res> {
  __$$AnalyticsOrdersImplCopyWithImpl(
    _$AnalyticsOrdersImpl _value,
    $Res Function(_$AnalyticsOrdersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsOrders
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byStatus = null, Object? byDate = null}) {
    return _then(
      _$AnalyticsOrdersImpl(
        byStatus: null == byStatus
            ? _value._byStatus
            : byStatus // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        byDate: null == byDate
            ? _value._byDate
            : byDate // ignore: cast_nullable_to_non_nullable
                  as List<ByDateRow>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsOrdersImpl implements _AnalyticsOrders {
  const _$AnalyticsOrdersImpl({
    final Map<String, int> byStatus = const {},
    final List<ByDateRow> byDate = const [],
  }) : _byStatus = byStatus,
       _byDate = byDate;

  factory _$AnalyticsOrdersImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsOrdersImplFromJson(json);

  final Map<String, int> _byStatus;
  @override
  @JsonKey()
  Map<String, int> get byStatus {
    if (_byStatus is EqualUnmodifiableMapView) return _byStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byStatus);
  }

  final List<ByDateRow> _byDate;
  @override
  @JsonKey()
  List<ByDateRow> get byDate {
    if (_byDate is EqualUnmodifiableListView) return _byDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byDate);
  }

  @override
  String toString() {
    return 'AnalyticsOrders(byStatus: $byStatus, byDate: $byDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsOrdersImpl &&
            const DeepCollectionEquality().equals(other._byStatus, _byStatus) &&
            const DeepCollectionEquality().equals(other._byDate, _byDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_byStatus),
    const DeepCollectionEquality().hash(_byDate),
  );

  /// Create a copy of AnalyticsOrders
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsOrdersImplCopyWith<_$AnalyticsOrdersImpl> get copyWith =>
      __$$AnalyticsOrdersImplCopyWithImpl<_$AnalyticsOrdersImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsOrdersImplToJson(this);
  }
}

abstract class _AnalyticsOrders implements AnalyticsOrders {
  const factory _AnalyticsOrders({
    final Map<String, int> byStatus,
    final List<ByDateRow> byDate,
  }) = _$AnalyticsOrdersImpl;

  factory _AnalyticsOrders.fromJson(Map<String, dynamic> json) =
      _$AnalyticsOrdersImpl.fromJson;

  @override
  Map<String, int> get byStatus;
  @override
  List<ByDateRow> get byDate;

  /// Create a copy of AnalyticsOrders
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsOrdersImplCopyWith<_$AnalyticsOrdersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PopularProductRow _$PopularProductRowFromJson(Map<String, dynamic> json) {
  return _PopularProductRow.fromJson(json);
}

/// @nodoc
mixin _$PopularProductRow {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get totalSold => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this PopularProductRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularProductRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularProductRowCopyWith<PopularProductRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularProductRowCopyWith<$Res> {
  factory $PopularProductRowCopyWith(
    PopularProductRow value,
    $Res Function(PopularProductRow) then,
  ) = _$PopularProductRowCopyWithImpl<$Res, PopularProductRow>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalSold,
    double revenue,
  });
}

/// @nodoc
class _$PopularProductRowCopyWithImpl<$Res, $Val extends PopularProductRow>
    implements $PopularProductRowCopyWith<$Res> {
  _$PopularProductRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularProductRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
    Object? revenue = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalSold: null == totalSold
                ? _value.totalSold
                : totalSold // ignore: cast_nullable_to_non_nullable
                      as int,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PopularProductRowImplCopyWith<$Res>
    implements $PopularProductRowCopyWith<$Res> {
  factory _$$PopularProductRowImplCopyWith(
    _$PopularProductRowImpl value,
    $Res Function(_$PopularProductRowImpl) then,
  ) = __$$PopularProductRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalSold,
    double revenue,
  });
}

/// @nodoc
class __$$PopularProductRowImplCopyWithImpl<$Res>
    extends _$PopularProductRowCopyWithImpl<$Res, _$PopularProductRowImpl>
    implements _$$PopularProductRowImplCopyWith<$Res> {
  __$$PopularProductRowImplCopyWithImpl(
    _$PopularProductRowImpl _value,
    $Res Function(_$PopularProductRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopularProductRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
    Object? revenue = null,
  }) {
    return _then(
      _$PopularProductRowImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalSold: null == totalSold
            ? _value.totalSold
            : totalSold // ignore: cast_nullable_to_non_nullable
                  as int,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PopularProductRowImpl implements _PopularProductRow {
  const _$PopularProductRowImpl({
    required this.productId,
    required this.productName,
    required this.totalSold,
    required this.revenue,
  });

  factory _$PopularProductRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularProductRowImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int totalSold;
  @override
  final double revenue;

  @override
  String toString() {
    return 'PopularProductRow(productId: $productId, productName: $productName, totalSold: $totalSold, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularProductRowImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.totalSold, totalSold) ||
                other.totalSold == totalSold) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, totalSold, revenue);

  /// Create a copy of PopularProductRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularProductRowImplCopyWith<_$PopularProductRowImpl> get copyWith =>
      __$$PopularProductRowImplCopyWithImpl<_$PopularProductRowImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularProductRowImplToJson(this);
  }
}

abstract class _PopularProductRow implements PopularProductRow {
  const factory _PopularProductRow({
    required final String productId,
    required final String productName,
    required final int totalSold,
    required final double revenue,
  }) = _$PopularProductRowImpl;

  factory _PopularProductRow.fromJson(Map<String, dynamic> json) =
      _$PopularProductRowImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get totalSold;
  @override
  double get revenue;

  /// Create a copy of PopularProductRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularProductRowImplCopyWith<_$PopularProductRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LowStockProduct _$LowStockProductFromJson(Map<String, dynamic> json) {
  return _LowStockProduct.fromJson(json);
}

/// @nodoc
mixin _$LowStockProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this LowStockProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LowStockProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LowStockProductCopyWith<LowStockProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LowStockProductCopyWith<$Res> {
  factory $LowStockProductCopyWith(
    LowStockProduct value,
    $Res Function(LowStockProduct) then,
  ) = _$LowStockProductCopyWithImpl<$Res, LowStockProduct>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantity,
    bool isAvailable,
  });
}

/// @nodoc
class _$LowStockProductCopyWithImpl<$Res, $Val extends LowStockProduct>
    implements $LowStockProductCopyWith<$Res> {
  _$LowStockProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LowStockProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LowStockProductImplCopyWith<$Res>
    implements $LowStockProductCopyWith<$Res> {
  factory _$$LowStockProductImplCopyWith(
    _$LowStockProductImpl value,
    $Res Function(_$LowStockProductImpl) then,
  ) = __$$LowStockProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantity,
    bool isAvailable,
  });
}

/// @nodoc
class __$$LowStockProductImplCopyWithImpl<$Res>
    extends _$LowStockProductCopyWithImpl<$Res, _$LowStockProductImpl>
    implements _$$LowStockProductImplCopyWith<$Res> {
  __$$LowStockProductImplCopyWithImpl(
    _$LowStockProductImpl _value,
    $Res Function(_$LowStockProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LowStockProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _$LowStockProductImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LowStockProductImpl implements _LowStockProduct {
  const _$LowStockProductImpl({
    required this.productId,
    required this.productName,
    required this.quantity,
    this.isAvailable = true,
  });

  factory _$LowStockProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$LowStockProductImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int quantity;
  @override
  @JsonKey()
  final bool isAvailable;

  @override
  String toString() {
    return 'LowStockProduct(productId: $productId, productName: $productName, quantity: $quantity, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LowStockProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, quantity, isAvailable);

  /// Create a copy of LowStockProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LowStockProductImplCopyWith<_$LowStockProductImpl> get copyWith =>
      __$$LowStockProductImplCopyWithImpl<_$LowStockProductImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LowStockProductImplToJson(this);
  }
}

abstract class _LowStockProduct implements LowStockProduct {
  const factory _LowStockProduct({
    required final String productId,
    required final String productName,
    required final int quantity,
    final bool isAvailable,
  }) = _$LowStockProductImpl;

  factory _LowStockProduct.fromJson(Map<String, dynamic> json) =
      _$LowStockProductImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get quantity;
  @override
  bool get isAvailable;

  /// Create a copy of LowStockProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LowStockProductImplCopyWith<_$LowStockProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsProducts _$AnalyticsProductsFromJson(Map<String, dynamic> json) {
  return _AnalyticsProducts.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsProducts {
  List<PopularProductRow> get popularProducts =>
      throw _privateConstructorUsedError;
  List<LowStockProduct> get lowStockProducts =>
      throw _privateConstructorUsedError;

  /// Serializes this AnalyticsProducts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsProducts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsProductsCopyWith<AnalyticsProducts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsProductsCopyWith<$Res> {
  factory $AnalyticsProductsCopyWith(
    AnalyticsProducts value,
    $Res Function(AnalyticsProducts) then,
  ) = _$AnalyticsProductsCopyWithImpl<$Res, AnalyticsProducts>;
  @useResult
  $Res call({
    List<PopularProductRow> popularProducts,
    List<LowStockProduct> lowStockProducts,
  });
}

/// @nodoc
class _$AnalyticsProductsCopyWithImpl<$Res, $Val extends AnalyticsProducts>
    implements $AnalyticsProductsCopyWith<$Res> {
  _$AnalyticsProductsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsProducts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? popularProducts = null, Object? lowStockProducts = null}) {
    return _then(
      _value.copyWith(
            popularProducts: null == popularProducts
                ? _value.popularProducts
                : popularProducts // ignore: cast_nullable_to_non_nullable
                      as List<PopularProductRow>,
            lowStockProducts: null == lowStockProducts
                ? _value.lowStockProducts
                : lowStockProducts // ignore: cast_nullable_to_non_nullable
                      as List<LowStockProduct>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsProductsImplCopyWith<$Res>
    implements $AnalyticsProductsCopyWith<$Res> {
  factory _$$AnalyticsProductsImplCopyWith(
    _$AnalyticsProductsImpl value,
    $Res Function(_$AnalyticsProductsImpl) then,
  ) = __$$AnalyticsProductsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PopularProductRow> popularProducts,
    List<LowStockProduct> lowStockProducts,
  });
}

/// @nodoc
class __$$AnalyticsProductsImplCopyWithImpl<$Res>
    extends _$AnalyticsProductsCopyWithImpl<$Res, _$AnalyticsProductsImpl>
    implements _$$AnalyticsProductsImplCopyWith<$Res> {
  __$$AnalyticsProductsImplCopyWithImpl(
    _$AnalyticsProductsImpl _value,
    $Res Function(_$AnalyticsProductsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsProducts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? popularProducts = null, Object? lowStockProducts = null}) {
    return _then(
      _$AnalyticsProductsImpl(
        popularProducts: null == popularProducts
            ? _value._popularProducts
            : popularProducts // ignore: cast_nullable_to_non_nullable
                  as List<PopularProductRow>,
        lowStockProducts: null == lowStockProducts
            ? _value._lowStockProducts
            : lowStockProducts // ignore: cast_nullable_to_non_nullable
                  as List<LowStockProduct>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsProductsImpl implements _AnalyticsProducts {
  const _$AnalyticsProductsImpl({
    final List<PopularProductRow> popularProducts = const [],
    final List<LowStockProduct> lowStockProducts = const [],
  }) : _popularProducts = popularProducts,
       _lowStockProducts = lowStockProducts;

  factory _$AnalyticsProductsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsProductsImplFromJson(json);

  final List<PopularProductRow> _popularProducts;
  @override
  @JsonKey()
  List<PopularProductRow> get popularProducts {
    if (_popularProducts is EqualUnmodifiableListView) return _popularProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularProducts);
  }

  final List<LowStockProduct> _lowStockProducts;
  @override
  @JsonKey()
  List<LowStockProduct> get lowStockProducts {
    if (_lowStockProducts is EqualUnmodifiableListView)
      return _lowStockProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lowStockProducts);
  }

  @override
  String toString() {
    return 'AnalyticsProducts(popularProducts: $popularProducts, lowStockProducts: $lowStockProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsProductsImpl &&
            const DeepCollectionEquality().equals(
              other._popularProducts,
              _popularProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._lowStockProducts,
              _lowStockProducts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_popularProducts),
    const DeepCollectionEquality().hash(_lowStockProducts),
  );

  /// Create a copy of AnalyticsProducts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsProductsImplCopyWith<_$AnalyticsProductsImpl> get copyWith =>
      __$$AnalyticsProductsImplCopyWithImpl<_$AnalyticsProductsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsProductsImplToJson(this);
  }
}

abstract class _AnalyticsProducts implements AnalyticsProducts {
  const factory _AnalyticsProducts({
    final List<PopularProductRow> popularProducts,
    final List<LowStockProduct> lowStockProducts,
  }) = _$AnalyticsProductsImpl;

  factory _AnalyticsProducts.fromJson(Map<String, dynamic> json) =
      _$AnalyticsProductsImpl.fromJson;

  @override
  List<PopularProductRow> get popularProducts;
  @override
  List<LowStockProduct> get lowStockProducts;

  /// Create a copy of AnalyticsProducts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsProductsImplCopyWith<_$AnalyticsProductsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
