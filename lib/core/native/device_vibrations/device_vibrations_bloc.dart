import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_vibrations_event.dart';
part 'device_vibrations_state.dart';

class DeviceVibrationsBloc
    extends Bloc<DeviceVibrationsEvent, DeviceVibrationsState> {
  DeviceVibrationsBloc() : super(DeviceVibrationsInitial()) {
    on<DeviceVibrationsEvent>((event, emit) {
      switch (event.runtimeType) {
        case DeviceVibrationSmall:
          emit(DeviceVibrationsSmallState());
          break;
        case DeviceVibrationMedium:
          emit(DeviceVibrationsMediumState());
          break;
        case DeviceVibrationLarge:
          emit(DeviceVibrationsLargeState());
          break;
        case DeviceVibrationFull:
          emit(DeviceVibrationsFullState());
          break;
        default:
      }
    });
  }
}
