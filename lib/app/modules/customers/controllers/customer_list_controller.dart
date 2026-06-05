import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/customer_model.dart';
import '../repository/customer_repository.dart';

class CustomerListController extends BaseController {
  final CustomerRepository repository;

  final customers = <Customer>[].obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  CustomerListController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    debounce(searchQuery, (_) => _onSearch(), time: const Duration(milliseconds: 400));
  }

  void _onSearch() {
    _currentPage = 1;
    _hasMore = true;
    customers.clear();
    fetchCustomers();
  }

  Future<void> fetchCustomers({bool loadMore = false}) async {
    if (loadMore) {
      if (!_hasMore || _isFetchingMore) return;
      _isFetchingMore = true;
      _currentPage++;
    } else {
      showLoading();
    }

    try {
      final response = await repository.getCustomers(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: _currentPage,
      );
      if (response.success && response.data != null) {
        if (loadMore) {
          customers.addAll(response.data!);
        } else {
          customers.assignAll(response.data!);
        }
        _hasMore = response.data!.isNotEmpty;
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      if (loadMore) {
        _isFetchingMore = false;
      } else {
        hideLoading();
      }
    }
  }

  @override
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    await fetchCustomers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
