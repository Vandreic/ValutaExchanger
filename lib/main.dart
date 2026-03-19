import 'package:flutter/material.dart';
import 'package:valuta_exchanger/services/currency_service.dart';
import 'package:valuta_exchanger/widgets/currency_input_field.dart';

const String appName = 'Valuta Exchanger';
const String appVersion = '1.0.0';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  // Each input field has its own controller - we need one per TextField
  final TextEditingController eurController = TextEditingController();
  final TextEditingController dkkController = TextEditingController();
  final TextEditingController usdController = TextEditingController();
  final TextEditingController ronController = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Store the last converted amounts - used for label text display
  double? eurAmount;
  double? dkkAmount;
  double? ronAmount;
  double? usdAmount;

  /// IMPORTANT: When we update a controller's text programmatically (e.g. after
  /// converting), the TextField's onChanged fires. That would call
  /// handleCurrencyChanged again, which would try to convert and update again,
  /// causing an infinite loop. This flag tells us to ignore those programmatic
  /// updates - we only want to react when the USER types something.
  bool _isProgrammaticUpdate = false;

  /// Called whenever the user types in any currency field.
  /// Flow: parse value -> convert to EUR -> convert EUR to all others ->
  /// update the OTHER three fields (not the one being edited) -> setState.
  void handleCurrencyChanged(Currency currency, String value) {
    // Skip if this was triggered by us updating a controller, not by user input
    if (_isProgrammaticUpdate) return;

    try {
      // Step 1: Get all converted amounts using our two-step conversion
      // (user's currency -> EUR -> all other currencies)
      final amounts = CurrencyService.convertAllFrom(currency, value);

      // Step 2: Update our state so the labels show the right values
      setState(() {
        eurAmount = amounts.eurAmount;
        dkkAmount = amounts.dkkAmount;
        ronAmount = amounts.ronAmount;
        usdAmount = amounts.usdAmount;
      });

      // Step 3: Update the OTHER text fields with their converted values
      // We must not update the field the user is typing in - that would
      // mess up their input. Setting controller.text triggers onChanged,
      // so we set the flag first to ignore those callbacks.
      _isProgrammaticUpdate = true;

      if (currency != Currency.eur) {
        widget.eurController.text = (amounts.eurAmount ?? 0).toStringAsFixed(2);
      }
      if (currency != Currency.dkk) {
        widget.dkkController.text = (amounts.dkkAmount ?? 0).toStringAsFixed(2);
      }
      if (currency != Currency.ron) {
        widget.ronController.text = (amounts.ronAmount ?? 0).toStringAsFixed(2);
      }
      if (currency != Currency.usd) {
        widget.usdController.text = (amounts.usdAmount ?? 0).toStringAsFixed(2);
      }
    } finally {
      // Always reset the flag, even if something threw - prevents us from
      // getting stuck and never reacting to user input again
      _isProgrammaticUpdate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // DKK input field
                    CurrencyInputField(
                      currency: Currency.dkk,
                      controller: widget.dkkController,
                      onChanged: (currency, value) =>
                          handleCurrencyChanged(currency, value),
                      labelText:
                          "DKK: ${dkkAmount?.toStringAsFixed(2) ?? '0.00'} kr.",
                    ),
                    // EUR input field
                    CurrencyInputField(
                      currency: Currency.eur,
                      controller: widget.eurController,
                      onChanged: (currency, value) =>
                          handleCurrencyChanged(currency, value),
                      labelText:
                          "EUR: ${eurAmount?.toStringAsFixed(2) ?? '0.00'} €.",
                    ),
                    // USD input field
                    CurrencyInputField(
                      currency: Currency.usd,
                      controller: widget.usdController,
                      onChanged: (currency, value) =>
                          handleCurrencyChanged(currency, value),
                      labelText:
                          "USD: ${usdAmount?.toStringAsFixed(2) ?? '0.00'} \$.",
                    ),
                    // RON input field
                    CurrencyInputField(
                      currency: Currency.ron,
                      controller: widget.ronController,
                      onChanged: (currency, value) =>
                          handleCurrencyChanged(currency, value),
                      labelText:
                          "RON: ${ronAmount?.toStringAsFixed(2) ?? '0.00'} lei.",
                    ),
                    SizedBox(height: 16),
                    // Rates as of 19/03/2026
                    Text(
                      'Rates as of 19/03/2026',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Version $appVersion',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
