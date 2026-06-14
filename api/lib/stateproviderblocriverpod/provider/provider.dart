import 'package:api/models/restaurant_response.dart';
import 'package:api/service/service.dart';
import 'package:flutter/material.dart';

enum ApiStatus {
  initial,
  loading,
  success,
  error,
}

class RestaurantViewProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantViewProvider(this.apiService);

  ApiStatus apiStatus = ApiStatus.initial;

  String? errorMessage;

  ApiResponse? restaurantResponse;

  Future<void> fetchRestaurants() async {
    try {
      apiStatus = ApiStatus.loading;
      notifyListeners();

      restaurantResponse = await apiService.getRestaurants();

      apiStatus = ApiStatus.success;
    } catch (e) {
      errorMessage = e.toString();

      apiStatus = ApiStatus.error;
    }

    notifyListeners();
  }
}