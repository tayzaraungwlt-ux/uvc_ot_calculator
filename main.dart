import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UV-C Calculator',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final watts = TextEditingController();
  final lamps = TextEditingController();
  final distance = TextEditingController();
  final customDose = TextEditingController();

  String selectedDose = '15000';
  String result = '';

  double getDose() {
    if (selectedDose == 'custom') {
      return double.tryParse(customDose.text) ?? 0;
    }
    return double.parse(selectedDose);
  }

  void calculate() {
    final W = double.tryParse(watts.text);
    final N = double.tryParse(lamps.text);
    final d = double.tryParse(distance.text);
    final dose = getDose();

    if (W == null || N == null || d == null || dose == 0) {
      setState(() => result = 'Fill all fields correctly');
      return;
    }

    final intensity = (W * N * 0.3 * 1000000) /
        (4 * 3.1416 * d * d);

    final finalIntensity = intensity * 0.8;

    final totalSeconds = dose / finalIntensity;

    final min = totalSeconds ~/ 60;
    final sec = (totalSeconds % 60).round();

    setState(() {
      result = "$min min $sec sec";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UV-C OT Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            input("Lamp Watts (W)", watts),
            input("Number of Lamps", lamps),
            input("Distance (cm)", distance),

            DropdownButtonFormField(
              value: selectedDose,
              items: const [
                DropdownMenuItem(value: '15000', child: Text("Level-1")),
                DropdownMenuItem(value: '30000', child: Text("Level-2")),
                DropdownMenuItem(value: '50000', child: Text("Spores")),
                DropdownMenuItem(value: '45000', child: Text("C. difficile")),
                DropdownMenuItem(value: '132000', child: Text("Aspergillus")),
                DropdownMenuItem(value: '6600', child: Text("S. aureus")),
                DropdownMenuItem(value: '7000', child: Text("MRSA / E.coli")),
                DropdownMenuItem(value: '12000', child: Text("SARS-CoV-2")),
                DropdownMenuItem(value: 'custom', child: Text("Custom Dose")),
              ],
              onChanged: (v) => setState(() => selectedDose = v.toString()),
              decoration: const InputDecoration(labelText: "Select Pathogen"),
            ),

            if (selectedDose == 'custom')
              input("Custom Dose (µJ/cm²)", customDose),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculate,
              child: const Text("CALCULATE"),
            ),

            const SizedBox(height: 20),

            Text(result,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            const Text(
              "FINAL FORMULA:\n"
              "t = Dose / [((W × N × 0.3 × 10^6)/(4π d²)) × 0.8]",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            const Text(
              "Protocol:\n"
              "1. Measure furthest distance\n"
              "2. Avoid shadows\n"
              "3. Humidity < 60%\n"
              "4. No humans\n"
              "5. Warm-up 3–5 min",
            ),
          ],
        ),
      ),
    );
  }

  Widget input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
