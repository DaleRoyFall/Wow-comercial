import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_comercial/bloc_list/list_cubit.dart';
import 'package:wow_comercial/bloc_list/simple_bloc_observer.dart';
import 'package:wow_comercial/page/home_page.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(WowApp());
}

class WowApp extends MaterialApp {
  WowApp()
      : super(
          home: Scaffold(
            body: BlocProvider(
              create: (_) => ListCubit()..fetchList(),
              child: HomePage(),
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
}
