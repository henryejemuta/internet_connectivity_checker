import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connectivity_checker/bloc/connectivity_bloc.dart';
import 'package:internet_connectivity_checker/bloc/counter_bloc.dart';
import 'package:internet_connectivity_checker/screens/no_connectivity_screen.dart';
import 'package:internet_connectivity_checker/views/app_view.dart';

import 'bloc/connectivity_state.dart';
import 'cubits/theme_cubit.dart';


/// {@template app}
/// A [StatelessWidget] that:
/// * uses [bloc](https://pub.dev/packages/bloc) and
/// [flutter_bloc](https://pub.dev/packages/flutter_bloc)
/// to manage the state of a counter and the app theme.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (BuildContext context) => CounterBloc(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (BuildContext context) => ConnectivityBloc(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is ConnectivityNone) {
              return const NoConnectivityScreen();
            }
            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, state) {
                return const AppView();
              },
            );
          }),
    );
  }
}