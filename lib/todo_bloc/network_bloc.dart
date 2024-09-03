
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class CheckNetwork extends NetworkEvent {}

class NetworkChanged extends NetworkEvent {
  final ConnectivityResult result;

  const NetworkChanged(this.result);

  @override
  List<Object> get props => [result];
}

// States
abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {}

class NetworkDisconnected extends NetworkState {}

// Bloc
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _subscription;

  NetworkBloc(this._connectivity) : super(NetworkInitial()) {
    on<CheckNetwork>(_onCheckNetwork);
    on<NetworkChanged>(_onNetworkChanged);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      add(NetworkChanged(result as ConnectivityResult));
    }) as StreamSubscription<ConnectivityResult>;
  }

  void _onCheckNetwork(CheckNetwork event, Emitter<NetworkState> emit) async {
    final result = await _connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }

  void _onNetworkChanged(NetworkChanged event, Emitter<NetworkState> emit) {
    if (event.result != ConnectivityResult.none) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
