part of 'chart_cubit.dart';

@immutable
sealed class ChartState {}

final class ChartInitial extends ChartState {}

class GetDateState extends ChartState {}

class ClacUpperDataState extends ChartState {}
