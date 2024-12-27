import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../data/model/orders_model.dart';
import '../model/months_model.dart';
part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(ChartInitial());
  List<List<OrdinalData>> data = [];

  int? total;
  double? average;
  int? returns;

  // compute all functions
  excute() async {
    final orders = await loadOrders();
    clacUpperData(orders);
    clacChartData(orders);
    emit(GetDateState());
  }

  // Load Orders from the json file
  Future<List<OrderModel>> loadOrders() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/json/orders-json.json');
      final jsonData = jsonDecode(jsonString);

      final orderData = OrderDataModel.fromJson(jsonData);

      return orderData.orders;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// Calculate the chart part of the screen
  clacChartData(List<OrderModel> orders) {
    final groupedOrders = groupOrdersByMonth(orders);
    debugPrint(groupedOrders.toString());
    data.clear();
    List<OrdinalData> arData = [];
    List.generate(
        groupedOrders.length,
        (index) => arData.add(OrdinalData(
            domain: groupedOrders[index].arMonth,
            measure: groupedOrders[index].nOfOrders)));
    List<OrdinalData> enData = [];
    List.generate(
        groupedOrders.length,
        (index) => enData.add(OrdinalData(
            domain: groupedOrders[index].enMonth,
            measure: groupedOrders[index].nOfOrders)));
    data = [arData, enData];
    for (var element in arData) {
      debugPrint("key: ${element.domain} - value ${element.measure}");
    }
  }

  // Group orders by month
  List<MonthsModel> groupOrdersByMonth(List<OrderModel> orders) {
    Map<String, int> groupedData = {};
    for (var order in orders) {
      String month = DateFormat('MMM', 'en')
          .format(order.registered); // Always use English for grouping
      groupedData[month] = (groupedData[month] ?? 0) + 1;
    }

    List<MonthsModel> monthsList = groupedData.entries.map((entry) {
      String enMonth = entry.key;
      String arMonth = DateFormat('MMM', 'ar')
          .format(DateFormat('MMM', 'en').parse(enMonth));
      return MonthsModel(arMonth, enMonth, entry.value);
    }).toList();

    monthsList.sort((a, b) {
      int monthA = DateFormat('MMM', 'en').parse(a.enMonth).month;
      int monthB = DateFormat('MMM', 'en').parse(b.enMonth).month;
      return monthA.compareTo(monthB);
    });

    return monthsList;
  }

// Calculate the upper data part of the screen
  clacUpperData(List<OrderModel> orders) {
    total = getTotalOrders(orders);
    average = getAverageSales(orders);
    returns = getReturnsCount(orders);
    emit(ClacUpperDataState());
  }

  // Calculate total count of orders
  int getTotalOrders(List<OrderModel> orders) {
    return orders.length;
  }

  // Calculate average sales
  double getAverageSales(List<OrderModel> orders) {
    final nonReturnedOrders =
        orders.where((order) => order.status != 'RETURNED').toList();

    if (nonReturnedOrders.isEmpty) return 0.0;

    double totalSales =
        nonReturnedOrders.fold(0.0, (sum, order) => sum + order.price);

    return totalSales / nonReturnedOrders.length;
  }

  // Calculate number of returns
  int getReturnsCount(List<OrderModel> orders) {
    return orders.where((order) => order.status == 'RETURNED').length;
  }
}
