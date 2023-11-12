part of 'device_vibrations_bloc.dart';

sealed class DeviceVibrationsState extends Equatable {
  const DeviceVibrationsState();

  @override
  List<Object> get props => [];
}

final class DeviceVibrationsInitial extends DeviceVibrationsState {}

final class DeviceVibrationsSmallState extends DeviceVibrationsState {}

final class DeviceVibrationsMediumState extends DeviceVibrationsState {}

final class DeviceVibrationsLargeState extends DeviceVibrationsState {}

final class DeviceVibrationsFullState extends DeviceVibrationsState {}
