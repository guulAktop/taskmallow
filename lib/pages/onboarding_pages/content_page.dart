import 'package:flutter/widgets.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';

class ContentPage extends StatelessWidget {
  final String title;
  final String content;
  final String imageAsset;

  const ContentPage({
    Key? key,
    required this.title,
    required this.content,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRect(
            child: AspectRatio(
              aspectRatio: UIHelper.getDeviceHeight(context) / 1.25 > UIHelper.getDeviceWidth(context) ? 1 : 2,
              child: Image.asset(
                fit: BoxFit.cover,
                imageAsset,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      content,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
