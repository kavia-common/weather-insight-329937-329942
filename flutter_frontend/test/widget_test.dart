import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_frontend/app_config.dart';
import 'package:flutter_frontend/features/weather/state/weather_controller.dart';
import 'package:flutter_frontend/features/weather/ui/weather_home_page.dart';
import 'package:flutter_frontend/storage/local_prefs.dart';
import 'package:flutter_frontend/features/weather/services/weather_api_client.dart';

class _FakePrefs extends LocalPrefs {
  const _FakePrefs();

  @override
  Future<String?> getLastCity() async => 'London';

  @override
  Future<void> setLastCity(String city) async {}

  @override
  Future<String?> getThemeMode() async => 'light';

  @override
  Future<void> setThemeMode(String mode) async {}
}

void main() {
  testWidgets('Renders Weather Insight home with search bar', (WidgetTester tester) async {
    final controller = WeatherController(
      config: AppConfig(backendBaseUrl: Uri.parse('https://example.com'), defaultCity: 'London'),
      apiClient: WeatherApiClient(baseUrl: Uri.parse('https://example.com')),
      prefs: const _FakePrefs(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: WeatherHomePage()),
      ),
    );

    expect(find.text('Weather Insight'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('Theme toggle button exists', (WidgetTester tester) async {
    final controller = WeatherController(
      config: AppConfig(backendBaseUrl: Uri.parse('https://example.com'), defaultCity: 'London'),
      apiClient: WeatherApiClient(baseUrl: Uri.parse('https://example.com')),
      prefs: const _FakePrefs(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: WeatherHomePage()),
      ),
    );

    expect(find.byType(IconButton), findsWidgets);
    expect(find.byIcon(Icons.dark_mode).evaluate().isNotEmpty || find.byIcon(Icons.light_mode).evaluate().isNotEmpty, true);
  });
}
