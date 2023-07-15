import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/shared_preferences_helper.dart';
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
      backgroundColor: appBackgroundLightColor,
      body: Column(
        children: [
          Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: PageView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
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
            ),
          )),
          Padding(
            padding: EdgeInsets.all(UIHelper.getDeviceHeight(context) < 400 ? 10 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                generateContainerList(3, currentPageIndex),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: currentPageIndex == 2 ? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))) : const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () async {
                    if (currentPageIndex == 2) {
                      Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
                      await SharedPreferencesHelper.setBool("onboardingPagesShown", true).onError((error, stackTrace) {
                        throw Exception([error]);
                      });
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                    }
                  },
                  child: SizedBox(
                    height: UIHelper.getDeviceHeight(context) < 400 ? 25 : 50,
                    child: currentPageIndex == 2
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child: Text(
                                getTranslated(context, AppKeys.next),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: UIHelper.getDeviceHeight(context) < 400 ? 15 : 20),
                              ),
                            ),
                          )
                        : const IconComponent(
                            iconData: CustomIconData.arrowRight,
                            color: iconDarkColor,
                            size: 30,
                          ),
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
        Color color = index == currentIndex ? primaryColor : itemBackgroundLightColor;
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          width: UIHelper.getDeviceWidth(context) / 10,
          height: 10,
          margin: const EdgeInsets.all(3),
        );
      }),
    );
  }
}
