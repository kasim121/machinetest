import 'package:api/service/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final ApiService apiService;

  RestaurantBloc(this.apiService) : super(RestaurantInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
  }

  Future<void> _onFetchRestaurants(FetchRestaurants event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final resp = await apiService.getRestaurants();
      emit(RestaurantSuccess(resp));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}
