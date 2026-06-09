import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/main.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (tester) async {
    await tester.pumpWidget(const AluConnectApp());
    expect(find.byType(AluConnectApp), findsOneWidget);
  });
}
