import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:listening_quran/main.dart';

void main() {
  testWidgets('shows the splash route first', (WidgetTester tester) async {
    await tester.pumpWidget(const ListeningQuranApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/icons/listeniquran_splash.png',
      ),
      findsOneWidget,
    );
  });
}
