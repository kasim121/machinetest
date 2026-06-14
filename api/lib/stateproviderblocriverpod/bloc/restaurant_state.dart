import 'package:api/models/restaurant_response.dart';

abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}
class RestaurantLoading extends RestaurantState {}
class RestaurantSuccess extends RestaurantState {
  final ApiResponse response;
  RestaurantSuccess(this.response);
}
class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}
