abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class LoadDeviceLocation extends HomeEvent {
  final String deviceId;

  LoadDeviceLocation(this.deviceId);

  @override
  String toString() => "LoadDeviceLocation(deviceId: $deviceId)";
}
