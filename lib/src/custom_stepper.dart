import 'package:presurveylist/src/pages/five.dart';
import 'package:presurveylist/src/pages/four.dart';
import 'package:presurveylist/src/pages/one.dart';
import 'package:presurveylist/src/pages/six.dart';
import 'package:presurveylist/src/pages/three.dart';
import 'package:presurveylist/src/pages/two.dart';
import 'package:stepper/stepper.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({super.key});

  @override
  State<CustomStepper> createState() => CustomStepperState();
}

class CustomStepperState extends State<CustomStepper> {
  int currentIndex = 0;
  PageController pageController = PageController();
  final List<StepperStatus> statuses =
      List.generate(6, (_) => StepperStatus.defaultStatus);

  List<StepperStatus> get stepperStatuses => statuses;

  void goToNextPage() {
    if (currentIndex < 5) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void handleContinue() {
    goToNextPage();
  }

  void handleBack() {
    goToPreviousPage();
  }

  void updateStatus(int index, StepperStatus status) {
    setState(() {
      statuses[index] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.person,
      Icons.location_city,
      Icons.landscape,
      Icons.business,
      Icons.calendar_today,
      Icons.settings,
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => StepperComponent(
                  currentIndex: currentIndex,
                  index: index,
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      pageController.jumpToPage(currentIndex);
                    });
                  },
                  icon: icons[index],
                  status: statuses[index],
                  isLast: index == 5,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                PageOne(
                  onContinue: handleContinue,
                  onStatusChanged: (status) => updateStatus(0, status),
                ),
                PageTwo(
                  onContinue: handleContinue,
                  onBack: handleBack,
                  onStatusChanged: (status) => updateStatus(1, status),
                ),
                PageThree(
                  onContinue: handleContinue,
                  onBack: handleBack,
                  onStatusChanged: (status) => updateStatus(2, status),
                ),
                WaterSourcePage(
                  onContinue: handleContinue,
                  onBack: handleBack,
                  onStatusChanged: (status) => updateStatus(3, status),
                ),
                GrowingPatternsPage(
                  onContinue: handleContinue,
                  onBack: handleBack,
                  onStatusChanged: (status) => updateStatus(4, status),
                ),
                DetailPage(onBack: handleBack),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
