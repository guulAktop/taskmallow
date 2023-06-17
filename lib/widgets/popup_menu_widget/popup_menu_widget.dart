import 'package:flutter/material.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/widgets/popup_menu_widget/popup_menu_widget_item.dart';

class PopupMenuWidget extends StatelessWidget {
  final List<List<PopupMenuWidgetItem>> menuList;
  final CustomIconData iconData;

  const PopupMenuWidget({Key? key, required this.menuList, this.iconData = CustomIconData.ellipsisVertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry> popupMenuEntryList = [];

    int counter = 0;
    for (List<PopupMenuWidgetItem> list in menuList) {
      for (PopupMenuWidgetItem listItem in list) {
        popupMenuEntryList.add(PopupMenuItem(
          onTap: () {
            listItem.function();
          },
          child: createPopupMenuItemWidget(
              listItem.title, listItem.subTitle, listItem.prefixIcon, listItem.suffixIcon, color: listItem.color, listItem.function, context),
        ));
      }

      if (counter != menuList.length - 1) {
        popupMenuEntryList.add(const PopupMenuDivider());
      }
      counter++;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ).apply(bodyColor: Colors.black),
      ),
      child: TooltipVisibility(
        visible: false,
        child: PopupMenuButton(
          icon: IconComponent(iconData: iconData),
          splashRadius: AppConstants.iconSplashRadius,
          padding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          offset: const Offset(0, 0),
          itemBuilder: ((context) => popupMenuEntryList),
          color: textPrimaryDarkColor,
        ),
      ),
    );
  }

  createPopupMenuItemWidget(String title, String? subTitle, CustomIconData? prefixIcon, CustomIconData? suffixIcon, Function function, BuildContext context,
      {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        prefixIcon != null
            ? IconComponent(
                iconData: prefixIcon,
                color: color ?? Colors.black,
              )
            : const SizedBox(),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponent(
                  text: title,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  color: color ?? Colors.black,
                ),
                Visibility(
                  visible: (subTitle != null && subTitle.isNotEmpty),
                  child: TextComponent(
                    text: subTitle ?? "",
                    headerType: HeaderType.h6,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        suffixIcon != null
            ? IconComponent(
                iconData: suffixIcon,
              )
            : const SizedBox()
      ],
    );
  }
}
