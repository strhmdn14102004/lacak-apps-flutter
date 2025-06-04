import "package:flutter_bloc/flutter_bloc.dart";
import "package:lacak_by_sasat/api/api_manager.dart";
import "package:lacak_by_sasat/api/endpoint/home/home_response.dart";
import "package:lacak_by_sasat/api/endpoint/location/location_response.dart";
import "package:lacak_by_sasat/module/home/home_event.dart";
import "package:lacak_by_sasat/module/home/home_state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());

      try {
        final response = await ApiManager.getHomeData();

        if (response.statusCode == 200) {
          final homeResponse = HomeResponse.fromJson(response.data);
          emit(HomeLoaded(homeResponse));
        } else {
          emit(HomeError("Failed to load data. Code: ${response.statusCode}"));
        }
      } catch (e) {
        emit(HomeError("Error: $e"));
      }
    });

    on<LoadDeviceLocation>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;

        try {
          final response = await ApiManager.getDeviceLocation(event.deviceId);

          if (response.statusCode == 200) {
            if (response.data is List && response.data.isNotEmpty) {
              // Parse all location data
              final List<LocationResponse> allLocations = (response.data as List)
                  .map((locData) => LocationResponse.fromJson(locData))
                  .toList();

              // Most recent location is first in list
              final LocationResponse mostRecent = allLocations.first;

              // If there are previous locations, add them (excluding first element)
              if (allLocations.length > 1) {
                mostRecent.previousLocations = allLocations.sublist(1);
              }

              final updatedLocations = Map<String, LocationResponse>.from(
                currentState.deviceLocations ?? {},
              )..[event.deviceId] = mostRecent;

              emit(HomeLoaded(currentState.data, updatedLocations));
            } else {
              // No location data available
              final updatedLocations = Map<String, LocationResponse>.from(
                currentState.deviceLocations ?? {},
              )..remove(event.deviceId);

              emit(HomeLoaded(currentState.data, updatedLocations));
            }
          } else {
            emit(HomeError(
                "Failed to load location data. Code: ${response.statusCode}",),);
          }
        } catch (e) {
          emit(HomeError("Error loading location: $e"));
        }
      }
    });
  }
}
