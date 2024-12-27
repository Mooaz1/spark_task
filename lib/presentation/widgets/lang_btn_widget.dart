import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/resources/locale/cubit/locale_cubit.dart';

class LangBtnWidget extends StatelessWidget {
  const LangBtnWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      position: PopupMenuPosition.under,
      onSelected: (value) {
        context.read<LocaleCubit>().changeLocle(lang: value, context: context);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: context.supportedLocales.first,
          child: const Text('English'),
        ),
        PopupMenuItem(
          value: context.supportedLocales.last,
          child: const Text('العربية'),
        ),
      ],
      icon: const Icon(Icons.language),
    );
  }
}
