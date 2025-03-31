import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for input formatters

// TODO: Define these enums based on your actual database types or create helper functions
enum Gender { male, female, other }

enum HeightUnit { cm, ft }

enum WeightUnit { kg, lbs }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum Goal { loseWeight, maintainWeight, gainWeight }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ]; // One key per step form

  // Form data
  int? _age;
  Gender? _gender;
  double? _heightValue;
  HeightUnit _heightUnit = HeightUnit.cm;
  double? _heightInches; // Only used if heightUnit is ft
  double? _weightValue;
  WeightUnit _weightUnit = WeightUnit.kg;
  ActivityLevel? _activityLevel;
  Goal? _goal;

  List<Step> _steps() => [
    Step(
      title: const Text('About You'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _formKeys[0],
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Please enter a valid age';
                }
                return null;
              },
              onSaved: (value) => _age = int.parse(value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Gender>(
              decoration: const InputDecoration(labelText: 'Gender'),
              value: _gender,
              items:
                  Gender.values
                      .map(
                        (Gender gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(
                            gender.toString().split('.').last,
                          ), // Simple display name
                        ),
                      )
                      .toList(),
              onChanged: (Gender? newValue) {
                setState(() {
                  _gender = newValue;
                });
              },
              validator:
                  (value) => value == null ? 'Please select your gender' : null,
            ),
          ],
        ),
      ),
    ),
    Step(
      title: const Text('Measurements'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _formKeys[1],
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          'Height (${_heightUnit.toString().split('.').last})',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter height';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Invalid height';
                      }
                      return null;
                    },
                    onSaved: (value) => _heightValue = double.parse(value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<HeightUnit>(
                    decoration: const InputDecoration(labelText: 'Unit'),
                    value: _heightUnit,
                    items:
                        HeightUnit.values
                            .map(
                              (HeightUnit unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit.toString().split('.').last),
                              ),
                            )
                            .toList(),
                    onChanged: (HeightUnit? newValue) {
                      setState(() {
                        _heightUnit = newValue!;
                        _heightInches = null; // Reset inches if unit changes
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_heightUnit == HeightUnit.ft) // Conditional field for inches
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Height (inches)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ), // Allow 1 decimal for inches
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter inches';
                    }
                    final inches = double.tryParse(value);
                    if (inches == null || inches < 0 || inches >= 12) {
                      return 'Invalid inches (0-11.9)';
                    }
                    return null;
                  },
                  onSaved: (value) => _heightInches = double.parse(value!),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          'Weight (${_weightUnit.toString().split('.').last})',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter weight';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Invalid weight';
                      }
                      return null;
                    },
                    onSaved: (value) => _weightValue = double.parse(value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<WeightUnit>(
                    decoration: const InputDecoration(labelText: 'Unit'),
                    value: _weightUnit,
                    items:
                        WeightUnit.values
                            .map(
                              (WeightUnit unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit.toString().split('.').last),
                              ),
                            )
                            .toList(),
                    onChanged: (WeightUnit? newValue) {
                      setState(() {
                        _weightUnit = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    Step(
      title: const Text('Goals & Activity'),
      isActive: _currentStep >= 2,
      state:
          _currentStep > 2
              ? StepState.complete
              : StepState.indexed, // Check if it should be complete
      content: Form(
        key: _formKeys[2],
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            DropdownButtonFormField<ActivityLevel>(
              decoration: const InputDecoration(labelText: 'Activity Level'),
              value: _activityLevel,
              isExpanded: true, // Allow text wrapping
              items:
                  ActivityLevel.values
                      .map(
                        (ActivityLevel level) => DropdownMenuItem(
                          value: level,
                          // Simple display name, consider mapping to user-friendly strings
                          child: Text(_activityLevelToString(level)),
                        ),
                      )
                      .toList(),
              onChanged: (ActivityLevel? newValue) {
                setState(() {
                  _activityLevel = newValue;
                });
              },
              validator:
                  (value) =>
                      value == null
                          ? 'Please select your activity level'
                          : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Goal>(
              decoration: const InputDecoration(labelText: 'Primary Goal'),
              value: _goal,
              isExpanded: true,
              items:
                  Goal.values
                      .map(
                        (Goal goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(
                            _goalToString(goal),
                          ), // Map to user-friendly strings
                        ),
                      )
                      .toList(),
              onChanged: (Goal? newValue) {
                setState(() {
                  _goal = newValue;
                });
              },
              validator:
                  (value) => value == null ? 'Please select your goal' : null,
            ),
          ],
        ),
      ),
    ),
  ];

  // Helper to convert enum to display string (customize as needed)
  String _activityLevelToString(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary (little to no exercise)';
      case ActivityLevel.light:
        return 'Lightly Active (light exercise/sports 1-3 days/week)';
      case ActivityLevel.moderate:
        return 'Moderately Active (moderate exercise/sports 3-5 days/week)';
      case ActivityLevel.active:
        return 'Very Active (hard exercise/sports 6-7 days a week)';
      case ActivityLevel.veryActive:
        return 'Extra Active (very hard exercise/sports & physical job)';
    }
  }

  // Helper to convert enum to display string (customize as needed)
  String _goalToString(Goal goal) {
    switch (goal) {
      case Goal.loseWeight:
        return 'Lose Weight';
      case Goal.maintainWeight:
        return 'Maintain Weight';
      case Goal.gainWeight:
        return 'Gain Weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Your Profile')),
      body: Stepper(
        type: StepperType.vertical, // Or StepperType.horizontal
        currentStep: _currentStep,
        onStepContinue: () {
          // Validate the current step's form
          if (_formKeys[_currentStep].currentState!.validate()) {
            _formKeys[_currentStep].currentState!.save(); // Save the form data
            if (_currentStep < _steps().length - 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              // Last step - Process data (e.g., send to backend)
              _submitOnboardingData();
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            // Optionally navigate back if on the first step
            // Navigator.of(context).pop();
          }
        },
        onStepTapped:
            (step) =>
                setState(() => _currentStep = step), // Allow jumping steps
        steps: _steps(),
        // Customize controls
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_currentStep >
                    0) // Show Cancel/Back only if not on the first step
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('BACK'),
                  ),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    _currentStep == _steps().length - 1 ? 'FINISH' : 'NEXT',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitOnboardingData() {
    // TODO: Implement the logic to save the collected data
    // This usually involves sending it to your backend API
    print('Submitting Onboarding Data:');
    print('Age: $_age');
    print('Gender: $_gender');
    print(
      'Height: $_heightValue ${_heightUnit.toString().split('.').last}' +
          (_heightUnit == HeightUnit.ft && _heightInches != null
              ? ' $_heightInches inches'
              : ''),
    );
    print('Weight: $_weightValue ${_weightUnit.toString().split('.').last}');
    print('Activity Level: $_activityLevel');
    print('Goal: $_goal');

    // Example: Show a success message and navigate away
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile setup complete!')));
    // TODO: Navigate to the main app screen (e.g., Dashboard)
    // Navigator.of(context).pushReplacementNamed('/dashboard'); // Example navigation
  }
}
