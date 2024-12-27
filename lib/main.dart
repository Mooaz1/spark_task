import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/resources/bloc_observer.dart';
import 'app/resources/color_manager.dart';
import 'app/resources/locale/cubit/locale_cubit.dart';
import 'presentation/cubit/chart_cubit.dart';
import 'presentation/view/chart_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(EasyLocalization(
      path: "lib/l10n/lang",
      supportedLocales: const [
        Locale(
          'en',
        ),
        Locale('ar')
      ],
      fallbackLocale: const Locale('en', 'US'),
      saveLocale: true,
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChartCubit(),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Spark Task',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              color: ColorManager.mainColor,
              surfaceTintColor: ColorManager.mainColor,
            ),
            scaffoldBackgroundColor: ColorManager.mainColor,
            popupMenuTheme: const PopupMenuThemeData(
                color: ColorManager.mainColor,
                surfaceTintColor: ColorManager.mainColor)),
        home: const ChartView(),
      ),
    );
  }
}
