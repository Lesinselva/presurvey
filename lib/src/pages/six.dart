import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:presurveylist/src/widgets/container.dart';

class DetailPage extends StatefulWidget {
  final VoidCallback onBack;
  const DetailPage({super.key, required this.onBack});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool? _sunlightAvailability;
  bool? _farmerConsent;
  List<File> imageFiles = [];
  bool isChecked = false;

  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  void validateFields() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CosContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Availability of sunlight',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<bool?>(
                                value: true,
                                groupValue: _sunlightAvailability,
                                onChanged: (value) {
                                  setState(() {
                                    _sunlightAvailability = value;
                                  });
                                },
                              ),
                              const Text('Yes'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<bool?>(
                                value: false,
                                groupValue: _sunlightAvailability,
                                onChanged: (value) {
                                  setState(() {
                                    _sunlightAvailability = value;
                                  });
                                },
                              ),
                              const Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Capture Images'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final XFile? newImage = await _pickImage();
                          if (newImage != null) {
                            setState(() {
                              if (imageFiles.length < 9) {
                                imageFiles.add(File(newImage.path));
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 245, 245, 245),
                          ),
                          child: imageFiles.isEmpty
                              ? const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFiles.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == imageFiles.length) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final XFile? newImage =
                                              await _pickImage();
                                          if (newImage != null) {
                                            setState(() {
                                              if (imageFiles.length < 9) {
                                                imageFiles
                                                    .add(File(newImage.path));
                                              }
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            width: 150,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child:
                                                const Icon(Icons.add, size: 40),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          final XFile? newImage =
                                              await _pickImage();
                                          if (newImage != null) {
                                            setState(() {
                                              imageFiles[index] =
                                                  File(newImage.path);
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.file(
                                            imageFiles[index],
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 100,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CosContainer(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          'Have you got the farmer\'s consent to store and use the data?'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<bool?>(
                                value: true,
                                groupValue: _farmerConsent,
                                onChanged: (value) {
                                  setState(() {
                                    _farmerConsent = value;
                                  });
                                },
                              ),
                              const Text('Yes'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<bool?>(
                                value: false,
                                groupValue: _farmerConsent,
                                onChanged: (value) {
                                  setState(() {
                                    _farmerConsent = value;
                                  });
                                },
                              ),
                              const Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CosContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: isChecked ? Colors.green : Colors.red,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 130, 130, 130),
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'I agree with the '),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 4, 5, 215),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Terms & Conditions ');
                                  },
                              ),
                              const TextSpan(text: ' of the Spowdi App.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              widget.onBack();
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
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: isChecked
                                  ? Colors.black
                                  : const Color.fromARGB(255, 231, 230, 230),
                            ),
                            child: const Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
