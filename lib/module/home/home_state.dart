import "package:lacak_by_sasat/api/endpoint/home/home_response.dart";
import "package:lacak_by_sasat/api/endpoint/location/location_response.dart";

abstract class HomeState {
  @override
  String toString() => runtimeType.toString();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeResponse data;
  final Map<String, LocationResponse>? deviceLocations;

  HomeLoaded(this.data, [this.deviceLocations]);

  @override
  String toString() => "HomeLoaded(data: $data, locations: $deviceLocations)";
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  String toString() => "HomeError(message: $message)";
}
