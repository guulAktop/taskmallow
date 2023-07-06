// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/models/message_model.dart';
import 'package:taskmallow/pages/photo_view_page.dart';
import 'package:taskmallow/providers/providers.dart';

import '../components/rectangle_photo_component.dart';

class MessageBubble extends ConsumerStatefulWidget {
  final MessageModel messageModel;
  const MessageBubble({super.key, required this.messageModel});

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userProvider).userModel != null
        ? widget.messageModel.userWhoSended.email == ref.watch(userProvider).userModel!.email
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  constraints: BoxConstraints(maxWidth: UIHelper.getDeviceWidth(context) / 1.25),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: const BoxDecoration(
                    color: itemBackgroundLightColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onLongPress: () async {
                            await Clipboard.setData(ClipboardData(text: widget.messageModel.content));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              widget.messageModel.hasImage
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => PhotoViewPage(url: widget.messageModel.imageUrl!),
                                            transitionDuration: const Duration(seconds: 0),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Hero(
                                            tag: widget.messageModel.imageUrl!,
                                            child: AspectRatio(aspectRatio: 1, child: RectanglePhotoComponent(url: widget.messageModel.imageUrl))),
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.messageModel.content.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: TextComponent(
                                        text: widget.messageModel.content,
                                        textAlign: TextAlign.start,
                                        headerType: HeaderType.h5,
                                      ),
                                    )
                                  : const SizedBox(),
                              TextComponent(
                                text: DateFormat("dd.MM.yyyy HH:mm").format(DateTime.fromMillisecondsSinceEpoch(widget.messageModel.messageDate)),
                                textAlign: TextAlign.end,
                                color: secondaryColor,
                                headerType: HeaderType.h8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Tooltip(
                          message: widget.messageModel.userWhoSended.email,
                          child: FutureBuilder(
                            future: ref.watch(userProvider).getUserByEmail(widget.messageModel.userWhoSended.email),
                            builder: (context, snapshot) {
                              String? url;
                              if (snapshot.hasData) {
                                url = snapshot.data!.profilePhotoURL;
                              }
                              return CircularPhotoComponent(url: url, hasBorder: false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: UIHelper.getDeviceWidth(context) / 1.25),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: const BoxDecoration(
                    color: itemBackgroundLightColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Tooltip(
                          message: widget.messageModel.userWhoSended.email,
                          child: FutureBuilder(
                            future: ref.watch(userProvider).getUserByEmail(widget.messageModel.userWhoSended.email),
                            builder: (context, snapshot) {
                              String? url;
                              if (snapshot.hasData) {
                                url = snapshot.data!.profilePhotoURL;
                              }
                              return CircularPhotoComponent(url: url, hasBorder: false);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onLongPress: () async {
                            await Clipboard.setData(ClipboardData(text: widget.messageModel.content));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.messageModel.hasImage
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => PhotoViewPage(url: widget.messageModel.imageUrl!),
                                            transitionDuration: const Duration(seconds: 0),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Hero(
                                            tag: widget.messageModel.imageUrl!,
                                            child: AspectRatio(aspectRatio: 1, child: RectanglePhotoComponent(url: widget.messageModel.imageUrl))),
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.messageModel.content.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: TextComponent(
                                        text: widget.messageModel.content,
                                        textAlign: TextAlign.start,
                                        headerType: HeaderType.h5,
                                      ),
                                    )
                                  : const SizedBox(),
                              TextComponent(
                                text: DateFormat("dd.MM.yyyy HH:mm").format(DateTime.fromMillisecondsSinceEpoch(widget.messageModel.messageDate)),
                                textAlign: TextAlign.end,
                                color: secondaryColor,
                                headerType: HeaderType.h8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
        : Container();
  }
}
