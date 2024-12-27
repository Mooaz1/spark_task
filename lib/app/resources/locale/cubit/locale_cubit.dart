import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial());
  Locale? locale;
  getLocale({required BuildContext context}) {
    locale = context.locale;
    debugPrint(locale.toString());

    emit(GetLocaleState());
  }

  Future changeLocle(
      {required Locale lang, required BuildContext context}) async {
    locale = lang;
    await context.setLocale(locale!);
    emit(ChangeLocaleState());
  }
}
