import 'package:flutter/material.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/color_constants.dart';

class ListViewItem {
  String title;
  String? subTitle;
  Widget? prefixWidget;
  Widget? suffixWidget;
  Function? onTap;
  Function? suffixOnTap;
  bool hasPrefixSpace;
  bool hasSuffixSpace;
  bool isVisible;
  Color foregroundColor;

  ListViewItem({
    required this.title,
    this.subTitle,
    this.prefixWidget,
    this.suffixWidget,
    this.onTap,
    this.suffixOnTap,
    this.hasPrefixSpace = true,
    this.hasSuffixSpace = false,
    this.isVisible = true,
    this.foregroundColor = textPrimaryLightColor,
  });
}

class ListViewWidget extends StatefulWidget {
  final List<ListViewItem> itemList;
  final Color borderColor;
  final bool hasBorder;
  final Color backgroundColor;
  final Color dividerColor;

  const ListViewWidget({
    Key? key,
    required this.itemList,
    this.borderColor = Colors.transparent,
    this.hasBorder = true,
    this.backgroundColor = itemBackgroundLightColor,
    this.dividerColor = itemDividerLightColor,
  }) : super(key: key);

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    widget.itemList.removeWhere((element) => element.isVisible == false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          border: widget.hasBorder ? Border.all(color: widget.borderColor) : null,
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: widget.itemList.map(
              (item) {
                return item.isVisible
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              item.onTap != null ? item.onTap!() : () {};
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  item.prefixWidget != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                                          child: item.prefixWidget,
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
                                            text: item.title,
                                            headerType: HeaderType.h5,
                                            color: item.foregroundColor,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                          item.subTitle != null && item.subTitle!.isNotEmpty
                                              ? TextComponent(
                                                  text: item.subTitle!,
                                                  headerType: HeaderType.h7,
                                                  color: textSecondaryLightColor,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  item.suffixWidget != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                          child: item.suffixOnTap != null
                                              ? InkWell(
                                                  child: item.suffixWidget,
                                                  onTap: () {
                                                    item.suffixOnTap!();
                                                  },
                                                )
                                              : item.suffixWidget,
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          widget.itemList.indexOf(item) != widget.itemList.length - 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(thickness: 1, color: widget.dividerColor),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox();
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
