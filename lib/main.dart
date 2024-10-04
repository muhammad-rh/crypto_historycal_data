import 'package:code_challenge/bloc/historycal_bloc.dart';
import 'package:code_challenge/config/app_colors.dart';
import 'package:code_challenge/datasources/historycal_datasource.dart';
import 'package:code_challenge/pages/historycal_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary300,
        scaffoldBackgroundColor: AppColors.black900,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary300,
          secondary: AppColors.primary1000,
        ),
        textTheme: GoogleFonts.latoTextTheme().apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primary300),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      home: BlocProvider(
        create: (_) => HistorycalBloc(HistorycalDatasource())
          ..add(ConnectHistorycalWebSocket())
          ..add(SubscribeToHistorycalWebSocket()),
        child: Builder(builder: (context) {
          return const HistorycalPage();
        }),
      ),
    ),
  );
}
