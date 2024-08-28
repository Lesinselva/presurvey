import 'package:presurveylist/src/widgets/container.dart';
import 'package:stepper/stepper.dart';
import 'package:flutter/material.dart';
import 'package:grandienticon/grandienticon.dart';

class PageThree extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final ValueChanged<StepperStatus> onStatusChanged;

  const PageThree({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  PageThreeState createState() => PageThreeState();
}

class PageThreeState extends State<PageThree> {
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final FocusNode lengthFocusNode = FocusNode();
  final FocusNode widthFocusNode = FocusNode();

  final ValueNotifier<String> lengthValue = ValueNotifier<String>('0');
  final ValueNotifier<String> widthValue = ValueNotifier<String>('0');

  String? selectedOption;
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
    lengthFocusNode.dispose();
    widthFocusNode.dispose();
    lengthController.dispose();
    widthController.dispose();
    lengthValue.dispose();
    widthValue.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _initializeListeners() {
    lengthController.addListener(() {
      lengthValue.value =
          lengthController.text.isNotEmpty ? lengthController.text : '0';
      _validateFields();
    });

    widthController.addListener(() {
      widthValue.value =
          widthController.text.isNotEmpty ? widthController.text : '0';
      _validateFields();
    });

    lengthFocusNode.addListener(() {
      setState(() {});
    });

    widthFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _validateFields() {
    bool allValid = _validateField(lengthController.text, 'Length') == null &&
        _validateField(widthController.text, 'Width') == null &&
        _validateField(selectedOption, 'Soil Type') == null;

    if (_showErrors) {
      setState(() {
        validationErrors['Length'] =
            _validateField(lengthController.text, 'Length');
        validationErrors['Width'] =
            _validateField(widthController.text, 'Width');
        validationErrors['Soil Type'] =
            _validateField(selectedOption, 'Soil Type');
      });
    }

    _isButtonEnabled.value = allValid;
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CosContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            buildTextField(
                              label: 'Length',
                              controller: lengthController,
                              icon: Icons.short_text,
                              focusNode: lengthFocusNode,
                            ),
                            const SizedBox(height: 16.0),
                            buildTextField(
                              label: 'Width',
                              controller: widthController,
                              icon: Icons.short_text,
                              focusNode: widthFocusNode,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 250,
                              width: 250,
                              padding:
                                  const EdgeInsets.only(top: 50, bottom: 15),
                              child: Image.asset(
                                'image/size.png',
                                package: 'presurvelist',
                              ),
                            ),
                            Positioned(
                              top: 150,
                              right: 0,
                              child: ValueListenableBuilder<String>(
                                valueListenable: lengthValue,
                                builder: (context, value, child) {
                                  return Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 92,
                              child: ValueListenableBuilder<String>(
                                valueListenable: widthValue,
                                builder: (context, value, child) {
                                  return Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  buildDropdownButton(),
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
                      width: double.infinity,
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
                  child: GestureDetector(
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
                      width: double.infinity,
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
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required FocusNode focusNode,
  }) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: controller,
              cursorColor: Colors.black,
              focusNode: focusNode,
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
        if (_showErrors && validationErrors[label] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              validationErrors[label]!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget buildDropdownButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            GradientIcon(
              icon: Icons.arrow_drop_down,
              startColor: Colors.blue,
              endColor: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Soil Type'),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String?>(
              value: selectedOption == 'None' ? null : selectedOption,
              decoration: const InputDecoration(
                hintText: 'Select soil type',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 199, 197, 197),
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem<String?>(
                  value: 'Clay',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Clay'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Sand',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.abc,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Sand'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Loam',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Loam'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Peat',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Peat'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Chalk',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Chalk'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Silt',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Silt'),
                    ],
                  ),
                ),
                DropdownMenuItem<String?>(
                  value: 'Rocky',
                  child: Row(
                    children: [
                      GradientIcon(
                        icon: Icons.public,
                        startColor: Colors.blue,
                        endColor: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text('Rocky'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOption = value ?? 'None';
                  _validateFields();
                });
              },
              hint: const Text(
                'Select soil type',
                style: TextStyle(
                  color: Color.fromARGB(255, 199, 197, 197),
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        if (_showErrors && validationErrors['Soil Type'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              validationErrors['Soil Type']!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
