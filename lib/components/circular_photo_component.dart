import 'package:flutter/material.dart';
import 'dart:io';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/image_constants.dart';

class CircularPhotoComponent extends StatelessWidget {
  final File? image;
  final String? url;
  final bool smallCircularProgressIndicator;
  final bool byTotalBytes;
  const CircularPhotoComponent({Key? key, this.url, this.image, this.smallCircularProgressIndicator = false, this.byTotalBytes = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: itemBackgroundLightColor,
        borderRadius: const BorderRadius.all(Radius.circular(500)),
        border: Border.all(
          width: 2,
          color: primaryColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(500)),
        child: url != null
            ? Image.network(
                url ?? ImageAssetKeys.defaultProfilePhotoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Transform.scale(
                      scale: smallCircularProgressIndicator ? 0.5 : 1.0,
                      child: CircularProgressIndicator(
                        value: byTotalBytes
                            ? (loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)
                            : null,
                      ),
                    ),
                  );
                },
              )
            : image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.cover,
                  )
                : null,
      ),
    );
  }
}
