import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/pages/onboarding_pages/content_page.dart';
import 'package:taskmallow/routes/route_constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
              child: PageView(
            onPageChanged: (value) {
              setState(() {
                currentPageIndex = value;
              });
            },
            controller: _controller,
            children: [
              ContentPage(
                  title: getTranslated(context, AppKeys.onboardingTitle1),
                  content: getTranslated(context, AppKeys.onboardingContent1),
                  imageAsset: ImageAssetKeys.onboarding1),
              ContentPage(
                  title: getTranslated(context, AppKeys.onboardingTitle2),
                  content: getTranslated(context, AppKeys.onboardingContent2),
                  imageAsset: ImageAssetKeys.onboarding2),
              ContentPage(
                  title: getTranslated(context, AppKeys.onboardingTitle3),
                  content: getTranslated(context, AppKeys.onboardingContent3),
                  imageAsset: ImageAssetKeys.onboarding3),
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                generateContainerList(3, currentPageIndex),
                currentPageIndex == 2
                    ? ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          if (currentPageIndex < 2) {
                            _controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                          } else {
                            Navigator.pushNamed(context, loginPageRoute);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          child: Text(getTranslated(context, AppKeys.next),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      )
                    : ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          _controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: const IconComponent(
                          iconData: CustomIconData.arrowRight,
                          size: 30,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget generateContainerList(int pageCount, int currentIndex) {
    return Row(
      children: List<Widget>.generate(pageCount, (index) {
        Color color = index == currentIndex ? primaryColor : secondaryColor;
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          width: UIHelper.getDeviceWidth(context) / 8,
          height: 10,
          margin: const EdgeInsets.all(3),
        );
      }),
    );
  }
}
