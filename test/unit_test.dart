import 'package:flutter_test/flutter_test.dart';
import 'package:spark_task/data/model/orders_model.dart';
import 'package:spark_task/presentation/cubit/chart_cubit.dart';

void main() {
  group('Calc functions Test', () {
    late ChartCubit chartCubit;

    // Mock data
    final mockOrders = [
      OrderModel(
        id: '1',
        isActive: true,
        price: 100.0,
        company: 'Company A',
        buyer: 'Buyer A',
        status: 'ORDERED',
        registered: DateTime(2024, 5, 15),
      ),
      OrderModel(
        id: '2',
        isActive: true,
        price: 150.0,
        company: 'Company B',
        buyer: 'Buyer B',
        status: 'RETURNED',
        registered: DateTime(2024, 5, 20),
      ),
      OrderModel(
        id: '3',
        isActive: true,
        price: 200.0,
        company: 'Company C',
        buyer: 'Buyer C',
        status: 'DELIVERED',
        registered: DateTime(2024, 4, 10),
      ),
    ];

    setUp(() {
      chartCubit = ChartCubit();
    });

    tearDown(() {
      chartCubit.close();
    });

    test('Get Total Orders should calculate total correctly', () {
      final total = chartCubit.getTotalOrders(mockOrders);
      expect(total, 3); // 3 orders in total
    });

    test('Get Average Sales should calculate average correctly', () {
      final average = chartCubit.getAverageSales(mockOrders);
      expect(average, closeTo(150.0, 0.01)); // Average is 150.0
    });

    test('Get Return sCount should calculate returns correctly', () {
      final returns = chartCubit.getReturnsCount(mockOrders);
      expect(returns, 1); // 1 returned order
    });
  });
}
