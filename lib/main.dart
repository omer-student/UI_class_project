import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: BMICalculator()));

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _result;
  String _message = "";

  void calculateBMI() {
    double height = double.parse(_heightController.text) / 100; // cm to meters
    double weight = double.parse(_weightController.text);

    double bmi = weight / (height * height);

    setState(() {
      _result = bmi;
      if (_result! < 18.5)
        _message = "Underweight";
      else if (_result! < 25)
        _message = "Healthy weight";
      else if (_result! < 30)
        _message = "Overweight";
      else
        _message = "Obese";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        backgroundColor: const Color.fromARGB(255, 42, 157, 56),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                icon: Icon(Icons.height),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                icon: Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text("Calculate"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 42, 157, 56),
              ),
            ),
            SizedBox(height: 20),
            if (_result != null) ...[
              Text(
                "Your BMI: ${_result!.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 42, 157, 56),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
