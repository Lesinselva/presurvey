import 'package:presurveylist/src/widgets/button_action.dart';
import 'package:presurveylist/src/widgets/container.dart';
import 'package:presurveylist/src/widgets/date.dart';
import 'package:stepper/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrowingPatternsPage extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final ValueChanged<StepperStatus> onStatusChanged;

  const GrowingPatternsPage({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.onStatusChanged,
  });

  @override
  _GrowingPatternsPageState createState() => _GrowingPatternsPageState();
}

class _GrowingPatternsPageState extends State<GrowingPatternsPage> {
  List<Widget> growingPatterns = [];
  List<Widget> dynamicGrowingPatterns = [];
  final Map<int, TextEditingController> controllers = {};
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _addGrowingPattern(isDefault: true);
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _addGrowingPattern({bool isDefault = false}) {
    setState(() {
      int newPatternNumber = dynamicGrowingPatterns.length + 1;
      TextEditingController cropController = TextEditingController();
      controllers[newPatternNumber] = cropController;
      cropController.addListener(_validateFields);

      dynamicGrowingPatterns.add(buildGrowingPattern(
        newPatternNumber,
        controller: cropController,
        isDefault: isDefault,
      ));
    });
  }

  void removeGrowingPattern(int index) {
    setState(() {
      if (index > 0 && index < dynamicGrowingPatterns.length) {
        controllers.remove(index + 1);
        dynamicGrowingPatterns.removeAt(index);
        updateGrowingPatternNumbers();
        _validateFields();
      }
    });
  }

  void updateGrowingPatternNumbers() {
    setState(() {
      dynamicGrowingPatterns = List.generate(
        dynamicGrowingPatterns.length,
        (index) => buildGrowingPattern(
          index + 1,
          controller: controllers[index + 1]!,
        ),
      );
    });
  }

  void _validateFields() {
    bool allFieldsFilled =
        controllers.values.every((controller) => controller.text.isNotEmpty);

    _isButtonEnabled.value = allFieldsFilled;
  }

  Widget buildGrowingPattern(int patternNumber,
      {TextEditingController? controller, bool isDefault = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CosContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Growing Pattern $patternNumber'),
                    if (patternNumber > 1 && !isDefault)
                      Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton<String>(
                          icon: const Icon(Icons.more_horiz),
                          underline: const SizedBox(),
                          onChanged: (String? newValue) {
                            if (newValue == 'Delete') {
                              removeGrowingPattern(patternNumber - 1);
                            }
                          },
                          items:
                              <String>['Delete'].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text('From',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(child: CurrentDateWidget()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text('To',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(child: CurrentDateWidget()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildTextField('Crop Growing', controller!),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextFieldWithFocus(
      label: label,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Growing Patterns',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ResizableButton(
                                defaultHeight: 35,
                                pressedHeight: 32,
                                defaultWidth: 150,
                                pressedWidth: 147,
                                onPressed: _addGrowingPattern,
                                child: const Text('Add Season',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        ...dynamicGrowingPatterns,
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
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
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isButtonEnabled,
                            builder: (context, isButtonEnabled, child) {
                              return GestureDetector(
                                onTap: () {
                                  if (isButtonEnabled) {
                                    widget.onStatusChanged(
                                        StepperStatus.complete);
                                  } else {
                                    widget
                                        .onStatusChanged(StepperStatus.warning);
                                  }
                                  widget.onContinue();
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.black),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TextFieldWithFocus extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWithFocus({
    super.key,
    required this.label,
    required this.controller,
    this.inputFormatters,
    required TextInputType keyboardType,
  });

  @override
  _TextFieldWithFocusState createState() => _TextFieldWithFocusState();
}

class _TextFieldWithFocusState extends State<TextFieldWithFocus> {
  final FocusNode _focusNode = FocusNode();
  Color _borderColor = const Color.fromARGB(255, 245, 245, 245);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus ? Colors.black : Colors.white;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  inputFormatters: widget.inputFormatters,
                  // ignore: prefer_const_constructors
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
