import 'package:grandienticon/grandienticon.dart';
import 'package:presurveylist/src/widgets/container.dart';
import 'package:presurveylist/src/widgets/countrypic/country_picker.dart';
import 'package:presurveylist/src/widgets/textformfield/numeric_icon.dart';
import 'package:presurveylist/src/widgets/textformfield/text.dart';
import 'package:presurveylist/src/widgets/textformfield/text_numeric.dart';
import 'package:stepper/stepper.dart';

import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';

class PageTwo extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final ValueChanged<StepperStatus> onStatusChanged;

  const PageTwo({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  PageTwoState createState() => PageTwoState();
}

class PageTwoState extends State<PageTwo> {
  final Map<String, TextEditingController> controllers = {
    'GPS Number': TextEditingController(),
    'Village(Optional)': TextEditingController(),
    'District(Optional)': TextEditingController(),
    'State': TextEditingController(),
    'Pincode': TextEditingController(),
    'Country': TextEditingController(),
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

    // if (allValid) {
    //   widget.onStatusChanged(StepperStatus.complete);
    // } else {
    //   widget.onStatusChanged(StepperStatus.warning);
    // }
  }

  String? validateField(String label) {
    if (controllers[label]!.text.isEmpty && !label.contains("(Optional)")) {
      return '$label is required';
    } else if (label == 'Pincode' && controllers[label]!.text.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }

  bool isValid() {
    return _isButtonEnabled.value;
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          controllers['Country']!.text = country.name;
        });
        _updateCountrySelection(true);
      },
    );
  }

  void _updateCountrySelection(bool isSelected) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CosContainer(
              child: Column(
                children: [
                  buildField(
                    label: 'GPS Number',
                    inputField: NumericInputFieldWithIcon(
                      label: 'GPS Number',
                      controller: controllers['GPS Number']!,
                      icon: const GradientIcon(
                        icon: Icons.gps_fixed,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      icons: Icons.gps_fixed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    label: 'Village(Optional)',
                    inputField: InputField(
                      label: 'Village',
                      controller: controllers['Village(Optional)']!,
                      icon: const GradientIcon(
                        icon: Icons.location_city,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    label: 'District(Optional)',
                    inputField: InputField(
                      label: 'District',
                      controller: controllers['District(Optional)']!,
                      icon: const GradientIcon(
                        icon: Icons.map_rounded,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    label: 'State',
                    inputField: InputField(
                      label: 'State',
                      controller: controllers['State']!,
                      icon: const GradientIcon(
                        icon: Icons.map,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    label: 'Pincode',
                    inputField: NumericInputField(
                      label: 'Pincode',
                      controller: controllers['Pincode']!,
                      maxLength: 6,
                      icon: const GradientIcon(
                        icon: Icons.pin_drop,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildField(
                    label: 'Country',
                    inputField: CountryPickerField(
                      controller: controllers['Country']!,
                      icon: const GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      showCountryPicker: _showCountryPicker,
                      onCountrySelected: _updateCountrySelection,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,
                      ),
                      child: const Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isButtonEnabled,
                    builder: (context, isButtonEnabled, child) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _showErrors = true;
                          });

                          if (_isButtonEnabled.value) {
                            widget.onStatusChanged(StepperStatus.complete);
                          } else {
                            widget.onStatusChanged(StepperStatus.warning);
                          }

                          widget.onContinue();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget inputField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputField,
        if (validationErrors[label] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              validationErrors[label] ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
