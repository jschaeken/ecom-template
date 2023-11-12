part of 'device_vibrations_bloc.dart';

sealed class DeviceVibrationsEvent extends Equatable {
  const DeviceVibrationsEvent();

  @override
  List<Object> get props => [];
}

final class DeviceVibrationSmall extends DeviceVibrationsEvent {}

final class DeviceVibrationMedium extends DeviceVibrationsEvent {}

final class DeviceVibrationLarge extends DeviceVibrationsEvent {}

final class DeviceVibrationFull extends DeviceVibrationsEvent {}
