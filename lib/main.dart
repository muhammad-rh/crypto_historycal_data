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
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primary),
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
          ..add(
            ConnectHistorycalWebSocket(),
          ),
        child: Builder(builder: (context) {
          return const HistorycalPage();
        }),
      ),
    ),
  );
}
