import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/rectangle_photo_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/app_functions.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/project_model.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/message_bubble.dart';
import '../models/message_model.dart';

class ProjectMessagingPage extends ConsumerStatefulWidget {
  const ProjectMessagingPage({super.key});

  @override
  ConsumerState<ProjectMessagingPage> createState() => _ProjectMessagingPageState();
}

class _ProjectMessagingPageState extends ConsumerState<ProjectMessagingPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();

    ref.read(projectProvider).isLoading = true;
    Future.delayed(Duration.zero, () async {
      await ref.read(projectProvider).listenForProjectMessages().whenComplete(() {
        ref.read(projectProvider).isLoading = false;
      });
    });
  }

  Future<void> sendMessage(ProjectModel projectModel, UserModel userModel, MessageModel messageModel) async {
    setState(() {
      isLoading = true;
    });
    UserRepository userRepository = UserRepository();
    if (_pickedImage != null) {
      messageModel.hasImage = true;
      messageModel.imageUrl =
          await userRepository.uploadImage(_pickedImage!, "MessageImages/${userModel.email}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
    }
    setState(() {
      _pickedImage = null;
    });
    await userRepository.sendMessageToProject(projectModel, userModel, messageModel).whenComplete(() async {
      for (var user in ref.watch(projectProvider).projectModel!.collaborators) {
        if (user.email != userModel.email) {
          await AppFunctions().sendPushMessage(user, projectModel.name, "${userModel.firstName}: ${messageModel.content}");
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProjectRepository projectRepository = ref.watch(projectProvider);
    UserRepository userRepository = ref.watch(userProvider);
    return WillPopScope(
      onWillPop: isLoading ? () async => false : () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          title: MarqueeWidget(
            child: Text(
              projectRepository.projectModel != null ? projectRepository.projectModel!.name : getTranslated(context, AppKeys.projectDetails),
              style: const TextStyle(color: textPrimaryLightColor, fontSize: 18),
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
            child: IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
          ),
          actions: [
            isLoading ? Center(child: Transform.scale(scale: 0.7, child: const CircularProgressIndicator())) : const SizedBox(),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              ref.read(projectProvider).isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: projectRepository.projectMessages.length,
                        itemBuilder: (context, index) {
                          int reversedIndex = projectRepository.projectMessages.length - 1 - index;
                          return MessageBubble(messageModel: projectRepository.projectMessages[reversedIndex]);
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _pickedImage != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                color: itemBackgroundLightColor,
                                height: UIHelper.getDeviceHeight(context) / 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Dismissible(
                                    key: const Key("imageFile"),
                                    direction: isLoading ? DismissDirection.none : DismissDirection.horizontal,
                                    child: RectanglePhotoComponent(
                                      image: _pickedImage,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    onDismissed: (direction) {
                                      setState(() {
                                        _pickedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      decoration: const BoxDecoration(color: itemBackgroundLightColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: const TextStyle(
                                color: textPrimaryLightColor,
                              ),
                              cursorColor: primaryColor,
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              enabled: !isLoading,
                              enableIMEPersonalizedLearning: true,
                              scribbleEnabled: true,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: itemBackgroundLightColor,
                                hintStyle: TextStyle(color: hintTextLightColor),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              controller: textEditingController,
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            splashRadius: AppConstants.iconSplashRadius,
                            icon: const IconComponent(
                              iconData: CustomIconData.image,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              AppFunctions().showMediaSnackbar(context, () {
                                AppFunctions().pickImageFromCamera().then((file) {
                                  setState(() => _pickedImage = file);
                                });
                              }, () {
                                AppFunctions().pickImageFromGallery().then((file) {
                                  setState(() => _pickedImage = file);
                                });
                              });
                            },
                          ),
                          IconButton(
                            splashRadius: AppConstants.iconSplashRadius,
                            icon: IconComponent(
                              iconData: CustomIconData.paperPlaneTop,
                              color: _pickedImage != null
                                  ? primaryColor
                                  : (textEditingController.text.trim().isEmpty || isLoading)
                                      ? Colors.grey
                                      : primaryColor,
                            ),
                            onPressed: !isLoading
                                ? _pickedImage != null
                                    ? () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        MessageModel messageModel = MessageModel(
                                          content: textEditingController.text.trim(),
                                          userWhoSended: UserModel.fromMap(userRepository.userModel!.toMap())..password = null,
                                          messageDate: Timestamp.now().millisecondsSinceEpoch,
                                        );
                                        textEditingController.clear();
                                        await sendMessage(projectRepository.projectModel!, userRepository.userModel!, messageModel);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    : (textEditingController.text.trim().isEmpty || isLoading)
                                        ? null
                                        : () async {
                                            MessageModel messageModel = MessageModel(
                                              content: textEditingController.text.trim(),
                                              userWhoSended: UserModel.fromMap(userRepository.userModel!.toMap())..password = null,
                                              messageDate: Timestamp.now().millisecondsSinceEpoch,
                                            );
                                            textEditingController.clear();
                                            await sendMessage(projectRepository.projectModel!, userRepository.userModel!, messageModel);
                                          }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
