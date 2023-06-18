import 'package:flutter/material.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import '../components/icon_component.dart';
import '../constants/app_constants.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
        title: "Invitations",
        leadingWidget: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.chevronLeft),
          onPressed: () => isLoading ? null : Navigator.pop(context),
        ),
        widgetList: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: listViewItemBackgroundLightColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "firstlastname@gmail.com",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " kişisi sizi ",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "Taskmallow",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " projesine dahil etmek istiyor.",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ButtonComponent(
                        text: "Accept",
                        onPressed: () {},
                        isOutLined: true,
                        color: success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        child: ButtonComponent(
                          text: "Reject",
                          onPressed: () {},
                          isOutLined: true,
                          color: danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: listViewItemBackgroundLightColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "firstlastname@gmail.com",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " kişisi sizi ",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "Taskmallow",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " projesine dahil etmek istiyor.",
                        style: TextStyle(
                          color: textPrimaryLightColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ButtonComponent(
                        text: "Accept",
                        onPressed: () {},
                        isOutLined: true,
                        color: success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        child: ButtonComponent(
                          text: "Reject",
                          onPressed: () {},
                          isOutLined: true,
                          color: danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          getInvitationRow(),
          getInvitationRow(),
        ]);
  }

  Widget getInvitationRow() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "firstlastname@gmail.com",
                  style: TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " kişisi sizi ",
                  style: TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "Taskmallow",
                  style: TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " projesine dahil etmek istiyor.",
                  style: TextStyle(
                    color: textPrimaryLightColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ButtonComponent(
                  text: "Accept",
                  onPressed: () {},
                  isOutLined: true,
                  color: success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  child: ButtonComponent(
                    text: "Reject",
                    onPressed: () {},
                    isOutLined: true,
                    color: danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
