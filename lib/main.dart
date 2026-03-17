import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valuta_exchanger/services/currency_service.dart';

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
  final TextEditingController dkkController = TextEditingController();
  final TextEditingController ronController = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? dkkAmount;
  double? ronAmount;

  void convertDKKToRON(double amount) {
    setState(() {
      dkkAmount = amount;
      ronAmount = CurrencyService.convertDKKToRON(amount);
    });
  }

  void convertRONToDKK(double amount) {
    setState(() {
      ronAmount = amount;
      dkkAmount = CurrencyService.convertRONToDKK(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("DKK: ${dkkAmount?.toStringAsFixed(2) ?? 0} kr."),
                    TextField(
                      controller: widget.dkkController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'-?\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${dkkAmount?.toStringAsFixed(2) ?? 0} kr.",
                        hintText: "Enter amount in DKK...",
                      ),
                      onChanged: (value) {
                        convertDKKToRON(
                          double.tryParse(widget.dkkController.text) ?? 0,
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Text("RON: ${ronAmount?.toStringAsFixed(2) ?? 0} lei."),
                    TextField(
                      controller: widget.ronController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'-?\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${ronAmount?.toStringAsFixed(2) ?? 0} lei.",
                        hintText: "Enter amount in RON...",
                      ),
                      onChanged: (value) {
                        convertRONToDKK(
                          double.tryParse(widget.ronController.text) ?? 0,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Version $appVersion',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
