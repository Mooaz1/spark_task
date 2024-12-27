import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../app/resources/color_manager.dart';
import '../../app/resources/locale/cubit/locale_cubit.dart';
import '../cubit/chart_cubit.dart';
import '../widgets/chart_widget.dart';
import '../widgets/lang_btn_widget.dart';
import '../widgets/metric_widget.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  void initState() {
    super.initState();
    context.read<ChartCubit>().excute();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChartCubit>();

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Orders's Chart".tr(),
              style: const TextStyle(
                  color: ColorManager.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            actions: const [
              LangBtnWidget(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              children: [
                Lottie.asset('assets/json/chart_animation.json', height: 200),
                const SizedBox(
                  height: 24,
                ),
                BlocBuilder<ChartCubit, ChartState>(
                  buildWhen: (previous, current) => current is GetDateState,
                  builder: (context, state) {
                    return state is GetDateState
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MetricWidget(
                                  label: 'Total Orders'.tr(),
                                  value: cubit.total.toString()),
                              MetricWidget(
                                  label: 'Avg Sales'.tr(),
                                  value:
                                      '\$${cubit.average!.toStringAsFixed(2)}'),
                              MetricWidget(
                                  label: 'Returns'.tr(),
                                  value: cubit.returns.toString()),
                            ],
                          )
                        : const SizedBox();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<ChartCubit, ChartState>(
                  builder: (context, state) {
                    return state is GetDateState
                        ? ChartWidget(
                            data: context.locale.languageCode == 'ar'
                                ? cubit.data.first
                                : cubit.data.last)
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
