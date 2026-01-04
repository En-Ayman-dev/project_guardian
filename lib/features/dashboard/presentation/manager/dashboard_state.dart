import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(true) bool isLoading,
    @Default(0.0) double totalSales,      // إجمالي المبيعات
    @Default(0) int lowStockCount,        // عدد المنتجات التي وصلت للحد الأدنى
    @Default(0) int clientsCount,         // عدد العملاء
    @Default(0) int invoiceCount,         // عدد الفواتير
    String? errorMessage,
  }) = _DashboardState;
}