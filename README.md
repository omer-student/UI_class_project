# BMI Calculator with History Tracking

A functional Flutter application that calculates Body Mass Index (BMI) and preserves a history of previous calculations using local device storage.

## Features
- BMI Calculation: Computes BMI based on height (cm) and weight (kg) inputs.
- Health Categorization: Automatically classifies results into Underweight, Healthy, Overweight, or Obese categories.
- Data Persistence: Uses SharedPreferences to save calculation history locally so data remains available after the app is closed.
- History Management: A dedicated history page allows users to view past records with dates and delete individual entries.
- Centered Navigation: A floating action button provides quick access to history from the main screen.

## Technical Details
- Language: Dart
- Framework: Flutter
- Storage: shared_preferences (JSON serialization)
- Math Formula: Weight (kg) / [Height (m) ^ 2]

## Dependencies
This project requires the following plugin:
- shared_preferences: For local data persistence.

To install dependencies, run:
```bash
flutter pub get



## How to Run
1. Clone the repository:
```bash
   git clone [https://github.com/omer-student/UI_class_project.git](https://github.com/omer-student/UI_class_project.git)