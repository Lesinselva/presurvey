import 'package:grandienticon/grandienticon.dart';
import 'package:presurveylist/src/widgets/container.dart';
import 'package:stepper/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaterSourcePage extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final ValueChanged<StepperStatus> onStatusChanged;

  const WaterSourcePage({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  _WaterSourcePageState createState() => _WaterSourcePageState();
}

class _WaterSourcePageState extends State<WaterSourcePage> {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  final Map<String, String?> validationErrors = {};
  bool _showErrors = false;

  String? selectedWaterSource;

  @override
  void initState() {
    super.initState();

    controllers['The volume of the water source (Liter)'] =
        TextEditingController();
    controllers['Height of the water source to land'] = TextEditingController();
    controllers['Distance between water source and farmland'] =
        TextEditingController();

    focusNodes['The volume of the water source (Liter)'] = FocusNode();
    focusNodes['Height of the water source to land'] = FocusNode();
    focusNodes['Distance between water source and farmland'] = FocusNode();

    _initializeListeners();
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
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

    if (selectedWaterSource == null) {
      errors['Surface water source'] = 'Surface water source is required';
      allValid = false;
    }

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
        children: [
          const SizedBox(height: 16),
          CosContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDropdown(
                  label: 'Surface water source',
                  icon: Icons.safety_check,
                  items: ['Farm pond', 'Water tank', 'Rivulet', 'Canal'],
                  hint: 'Type of water source',
                  value: selectedWaterSource,
                  onChanged: (value) {
                    setState(() {
                      selectedWaterSource = value;
                      _validateFields();
                    });
                  },
                ),
                buildTextField(
                  label: 'The volume of the water source (Liter)',
                  controller:
                      controllers['The volume of the water source (Liter)']!,
                  icon: Icons.access_alarm_outlined,
                  focusNode:
                      focusNodes['The volume of the water source (Liter)']!,
                ),
                buildTextField(
                  label: 'Height of the water source to land',
                  controller:
                      controllers['Height of the water source to land']!,
                  icon: Icons.accessibility_new_rounded,
                  focusNode: focusNodes['Height of the water source to land']!,
                ),
                buildTextField(
                  label: 'Distance between water source and farmland',
                  controller: controllers[
                      'Distance between water source and farmland']!,
                  icon: Icons.abc,
                  focusNode:
                      focusNodes['Distance between water source and farmland']!,
                ),
              ],
            ),
          ),
          const Spacer(),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showErrors = true;
                    });

                    _validateFields();

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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GradientIcon(
                  icon: icon,
                  startColor: Colors.blue,
                  endColor: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(50),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    hint,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 199, 197, 197),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  value: value,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      onChanged(newValue);
                    });
                  },
                ),
              ),
            ),
            if (validationErrors[label] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    validationErrors[label] ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required FocusNode focusNode,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        focusNode.addListener(() {
          setState(() {});
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GradientIcon(
                  icon: icon,
                  startColor: Colors.blue,
                  endColor: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: focusNode.hasFocus ? Colors.black : Colors.white,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: controller,
                  cursorColor: Colors.black,
                  focusNode: focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 199, 197, 197),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (validationErrors[label] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    validationErrors[label] ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
