import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/base/base_controller.dart';
import '../repository/sales_repository.dart';
import '../../../data/models/sale_model.dart';

class SalesController extends BaseController {
  final SalesRepository repository;

  final sales = <Sale>[].obs;
  
  // Filtering State
  final selectedPeriod = 'Today'.obs;
  final selectedStatus = 'all'.obs; // all, paid, due
  final searchText = ''.obs;
  
  final fromDate = RxnString();
  final toDate = RxnString();

  // Pagination State
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final isMoreLoading = false.obs;
  
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  Timer? _debounce;

  SalesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _setInitialDates();
    fetchSales(reset: true);
    
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && !isMoreLoading.value && hasMore.value) {
          loadMore();
        }
      }
    });
  }

  void _setInitialDates() {
    final now = DateTime.now();
    final fmt = DateFormat('yyyy-MM-dd');
    fromDate.value = fmt.format(now);
    toDate.value = fmt.format(now);
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchText.value = query;
      fetchSales(reset: true);
    });
  }

  Future<void> fetchSales({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      hasMore.value = true;
      showLoading();
    } else {
      isMoreLoading.value = true;
    }

    try {
      final response = await repository.getSales(
        today: selectedPeriod.value == 'Today' ? true : null,
        from: fromDate.value,
        to: toDate.value,
        hasDue: selectedStatus.value == 'due' ? true : (selectedStatus.value == 'paid' ? false : null),
        search: searchText.value.isEmpty ? null : searchText.value,
        page: currentPage.value,
      );

      if (response.success && response.data != null) {
        if (reset) {
          sales.assignAll(response.data!);
        } else {
          sales.addAll(response.data!);
        }

        final meta = response.meta;
        if (meta != null) {
          hasMore.value = meta.currentPage < meta.lastPage;
        } else {
          hasMore.value = false;
        }
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      if (reset) {
        hideLoading();
      } else {
        isMoreLoading.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    currentPage.value++;
    await fetchSales();
  }

  void changeStatus(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    fetchSales(reset: true);
  }

  void setPeriod(String period, {DateTimeRange? customRange}) {
    selectedPeriod.value = period;
    final now = DateTime.now();
    final fmt = DateFormat('yyyy-MM-dd');

    switch (period) {
      case 'Today':
        fromDate.value = fmt.format(now);
        toDate.value = fmt.format(now);
        break;
      case 'Week':
        final monday = now.subtract(Duration(days: now.weekday - 1));
        fromDate.value = fmt.format(monday);
        toDate.value = fmt.format(now);
        break;
      case 'Month':
        fromDate.value = fmt.format(DateTime(now.year, now.month, 1));
        toDate.value = fmt.format(now);
        break;
      case 'Year':
        fromDate.value = fmt.format(DateTime(now.year, 1, 1));
        toDate.value = fmt.format(now);
        break;
      case 'Custom':
        if (customRange != null) {
          fromDate.value = fmt.format(customRange.start);
          toDate.value = fmt.format(customRange.end);
        }
        break;
    }
    fetchSales(reset: true);
  }

  void resetFilters() {
    selectedPeriod.value = 'Today';
    selectedStatus.value = 'all';
    searchText.value = '';
    searchController.clear();
    _setInitialDates();
    fetchSales(reset: true);
  }

  bool get isFilterApplied {
    return selectedPeriod.value != 'Today' || 
           selectedStatus.value != 'all' || 
           searchText.value.isNotEmpty;
  }

  String get dateRangeDisplay {
    if (fromDate.value == null || toDate.value == null) return '';
    if (fromDate.value == toDate.value) return fromDate.value!;
    return '${fromDate.value} to ${toDate.value}';
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
