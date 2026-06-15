import 'package:flutter/material.dart';
import 'package:api/models/restaurant_response.dart';
import 'package:api/service/service.dart';

enum ApiStatus {
  initial,
  loading,
  success,
  error,
}

class RestaurantViewProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantViewProvider(this.apiService);

  ApiStatus _apiStatus = ApiStatus.initial;
  String? _errorMessage;
  ApiResponse? _restaurantResponse;

  ApiStatus get apiStatus => _apiStatus;
  String? get errorMessage => _errorMessage;
  ApiResponse? get restaurantResponse => _restaurantResponse;

  Future<void> fetchRestaurants() async {
    try {
      _apiStatus = ApiStatus.loading;
      _errorMessage = null;

      notifyListeners();

      _restaurantResponse =
          await apiService.getRestaurants();

      _apiStatus = ApiStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _apiStatus = ApiStatus.error;
    } finally {
      notifyListeners();
    }
  }
}