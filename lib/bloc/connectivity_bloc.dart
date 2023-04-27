import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityUnknown()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
          add(ConnectivityChanged(result));
        });
    on<ConnectivityChanged>(_onConnectivityChanged);
  }

  void _onConnectivityChanged(ConnectivityChanged event, emit) async {
    final connectivity = event.connectivity;
    if (connectivity == ConnectivityResult.none) {
      emit(ConnectivityNone());
    } else if (connectivity == ConnectivityResult.wifi) {
      emit(ConnectivityWifi());
    } else if (connectivity == ConnectivityResult.mobile) {
      emit(ConnectivityMobile());
    } else {
      emit(ConnectivityNone());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
