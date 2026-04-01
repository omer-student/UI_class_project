import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Required for json encoding/decoding

void main() => runApp(
  MaterialApp(home: BMICalculator(), debugShowCheckedModeBanner: false),
);

class BmiRecord {
  final double bmi;
  final String category;
  final DateTime date;

  BmiRecord({required this.bmi, required this.category, required this.date});

  // Convert Object to Map (for JSON)
  Map<String, dynamic> toMap() => {
    'bmi': bmi,
    'category': category,
    'date': date.toIso8601String(),
  };

  // Convert Map back to Object
  factory BmiRecord.fromMap(Map<String, dynamic> map) => BmiRecord(
    bmi: map['bmi'],
    category: map['category'],
    date: DateTime.parse(map['date']),
  );
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _result;
  String _message = "";
  List<BmiRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Load data as soon as the app starts
  }

  // SAVE to Device
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert list of objects to a JSON string
    String encodedData = jsonEncode(
      _history.map((item) => item.toMap()).toList(),
    );
    await prefs.setString('bmi_history', encodedData);
  }

  // LOAD from Device
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('bmi_history');
    if (savedData != null) {
      setState(() {
        Iterable list = jsonDecode(savedData);
        _history = list.map((item) => BmiRecord.fromMap(item)).toList();
      });
    }
  }

  void calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty)
      return;

    double height = double.parse(_heightController.text) / 100;
    double weight = double.parse(_weightController.text);
    double bmi = weight / (height * height);

    setState(() {
      _result = bmi;
      _message = _result! < 18.5
          ? "Underweight"
          : _result! < 25
          ? "Healthy weight"
          : _result! < 30
          ? "Overweight"
          : "Obese";

      _history.insert(
        0,
        BmiRecord(bmi: _result!, category: _message, date: DateTime.now()),
      );
      _saveHistory(); // Save every time we add a record
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text("Calculate", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            if (_result != null) ...[
              SizedBox(height: 20),
              Text(
                "Your BMI: ${_result!.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                _message,
                style: TextStyle(fontSize: 22, color: Colors.green),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HistoryPage(history: _history, onUpdate: _saveHistory),
            ),
          ).then((_) => setState(() {}));
        },
        label: Text("History"),
        icon: Icon(Icons.history),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class HistoryPage extends StatefulWidget {
  final List<BmiRecord> history;
  final VoidCallback onUpdate; // Callback to trigger a save when deleting

  HistoryPage({required this.history, required this.onUpdate});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History"), backgroundColor: Colors.teal),
      body: widget.history.isEmpty
          ? Center(child: Text("No records found"))
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                final item = widget.history[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    title: Text(
                      "BMI: ${item.bmi.toStringAsFixed(1)} (${item.category})",
                    ),
                    subtitle: Text(
                      "${item.date.day}/${item.date.month}/${item.date.year}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.history.removeAt(index);
                          widget.onUpdate(); // Save the new list to the device
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
