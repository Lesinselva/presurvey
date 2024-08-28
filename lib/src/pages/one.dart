import 'package:presurveylist/src/widgets/container.dart';
import 'package:presurveylist/src/widgets/textformfield/text.dart';
import 'package:presurveylist/src/widgets/textformfield/text_numeric.dart';
import 'package:stepper/stepper.dart';
import 'package:flutter/material.dart';

import 'package:grandienticon/grandienticon.dart';

class PageOne extends StatefulWidget {
  final VoidCallback onContinue;
  final ValueChanged<StepperStatus> onStatusChanged;
  const PageOne(
      {super.key, required this.onContinue, required this.onStatusChanged});

  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {
  final Map<String, TextEditingController> controllers = {
    'First Name': TextEditingController(),
    'Second Name': TextEditingController(),
    'Mobile Number': TextEditingController(),
  };

  final Map<String, String?> validationErrors = {};
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _initializeListeners();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _initializeListeners() {
    controllers.forEach((label, controller) {
      controller.addListener(_validateFields);
    });
  }

  void _validateFields() {
    final errors = <String, String?>{};
    bool allValid = true;

    controllers.forEach((label, controller) {
      final error = validateField(label);
      errors[label] = error;
      if (error != null) {
        allValid = false;
      }
    });

    if (_showErrors) {
      setState(() {
        validationErrors.clear();
        validationErrors.addAll(errors);
      });
    }

    _isButtonEnabled.value = allValid;
  }

  String? validateField(String label) {
    if (controllers[label]!.text.isEmpty) {
      return '$label is required';
    } else if (label == 'Mobile Number' &&
        controllers[label]!.text.length != 10) {
      return 'Mobile Number must be 10 digits';
    }
    return null;
  }

  bool isValid() {
    return _isButtonEnabled.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CosContainer(
            child: Column(
              children: [
                _buildFieldWithError(
                  label: 'First Name',
                  inputField: InputField(
                    label: 'First Name',
                    controller: controllers['First Name']!,
                    icon: const GradientIcon(
                      icon: Icons.person,
                      startColor: Colors.blue,
                      endColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldWithError(
                  label: 'Second Name',
                  inputField: InputField(
                    label: 'Second Name',
                    controller: controllers['Second Name']!,
                    icon: const GradientIcon(
                      icon: Icons.person,
                      startColor: Colors.blue,
                      endColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldWithError(
                  label: 'Mobile Number',
                  inputField: NumericInputField(
                    label: 'Mobile Number',
                    controller: controllers['Mobile Number']!,
                    maxLength: 10,
                    icon: const GradientIcon(
                      icon: Icons.local_phone,
                      startColor: Colors.blue,
                      endColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ValueListenableBuilder<bool>(
            valueListenable: _isButtonEnabled,
            builder: (context, isEnabled, child) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _showErrors = true;
                    _validateFields();
                  });
                  if (isEnabled) {
                    widget.onStatusChanged(StepperStatus.complete);
                    widget.onContinue();
                  } else {
                    widget.onStatusChanged(StepperStatus.warning);
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithError({
    required String label,
    required Widget inputField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputField,
        if (_showErrors && validationErrors[label] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Center(
              child: Text(
                validationErrors[label]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
