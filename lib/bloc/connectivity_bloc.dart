import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityUnknown()) {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    on<ConnectivityChanged>(_onConnectivityChanged);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      // } on PlatformException catch (e) {
      //TODO: Log error e.toString()
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    add(ConnectivityChanged(result));
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
