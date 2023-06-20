import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class SliverScaffoldWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> widgetList;
  final bool isKeyboardUsed;
  final bool centerTitle;
  final bool hasAppBar;
  final Widget? leadingWidget;
  final double? leadingWidth;
  final double? toolbarHeight;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final List<Widget>? actionList;
  final Function? popScopeFunction;
  final Color appBarBackgroundColor;
  final Widget? floatingActionButton;
  final CrossAxisAlignment crossAxisAlignment;

  const SliverScaffoldWidget({
    Key? key,
    this.title,
    this.titleWidget,
    required this.widgetList,
    this.isKeyboardUsed = false,
    this.centerTitle = true,
    this.hasAppBar = true,
    this.leadingWidget,
    this.leadingWidth,
    this.toolbarHeight,
    this.topPadding = 10,
    this.bottomPadding = 10,
    this.rightPadding = 10,
    this.leftPadding = 10,
    this.actionList,
    this.popScopeFunction,
    this.appBarBackgroundColor = Colors.transparent,
    this.floatingActionButton,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  defaultFunction() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return popScopeFunction == null ? defaultFunction() : popScopeFunction!();
      },
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        backgroundColor: appBackgroundLightColor,
        resizeToAvoidBottomInset: true,
        appBar: hasAppBar
            ? AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                backgroundColor: appBarBackgroundColor,
                toolbarHeight: toolbarHeight,
                elevation: 0,
                title: (titleWidget != null)
                    ? titleWidget
                    : ((title != null && title!.isNotEmpty)
                        ? MarqueeWidget(
                            child: Text(
                              title!,
                              style: const TextStyle(color: textPrimaryLightColor, fontSize: 18),
                            ),
                          )
                        : null),
                centerTitle: centerTitle,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                  child: leadingWidget,
                ),
                leadingWidth: leadingWidth,
                actions: actionList,
              )
            : null,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: widgetList,
          ),
        ),
      ),
    );
  }
}
