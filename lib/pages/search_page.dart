import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/components/circular_photo_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/components/text_form_field_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/constants/string_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/localization/app_localization.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/providers/providers.dart';
import 'package:taskmallow/repositories/user_repository.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';
import 'package:taskmallow/widgets/project_row_item.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool isLoading = false;
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(userProvider).filteredUsers.clear();
    ref.read(userProvider).filteredProjects.clear();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return BaseScaffoldWidget(
      title: getTranslated(context, AppKeys.searchUserOrProject),
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: () => isLoading ? null : Navigator.pop(context),
      ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      widgetList: [
        TextFormFieldComponent(
          context: context,
          textEditingController: _searchTextEditingController,
          iconData: CustomIconData.magnifyingGlass,
          hintText: getTranslated(context, AppKeys.enterAtLeast3LettersToSearch),
          onChanged: (text) {
            userRepository.searchUserAndProject(text.trim().toLowerCase());
          },
        ),
        userRepository.isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: LinearProgressIndicator(),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: _searchTextEditingController.text.length > 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        TextComponent(
                          text: userRepository.filteredUsers.isNotEmpty ? getTranslated(context, AppKeys.users) : getTranslated(context, AppKeys.userNotFound),
                          color: userRepository.filteredUsers.isNotEmpty ? textPrimaryLightColor : danger,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: userRepository.filteredUsers.map((user) => getUserRow(user)).toList(),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _searchTextEditingController.text.length > 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        TextComponent(
                          text: userRepository.filteredProjects.isNotEmpty
                              ? getTranslated(context, AppKeys.projects)
                              : getTranslated(context, AppKeys.projectNotFound),
                          color: userRepository.filteredProjects.isNotEmpty ? textPrimaryLightColor : danger,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: ref
                              .watch(userProvider)
                              .filteredProjects
                              .map(
                                (project) => ProjectRowItem(
                                  projectModel: project,
                                  onTap: () {
                                    if (project.collaborators.map((collaborator) => collaborator.email).toList().contains(userRepository.userModel!.email)) {
                                      Navigator.pushNamed(context, projectDetailPageRoute, arguments: project);
                                    } else {
                                      Navigator.pushNamed(context, projectScreenPageRoute, arguments: project);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget getUserRow(UserModel userModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: listViewItemBackgroundLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (userModel.email == ref.watch(userProvider).userModel!.email) {
            Navigator.pushNamed(context, profilePageRoute, arguments: userModel);
          } else {
            Navigator.pushNamed(context, profileScreenPageRoute, arguments: userModel);
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: UIHelper.getDeviceWidth(context) / 7,
              height: UIHelper.getDeviceWidth(context) / 7,
              child: CircularPhotoComponent(
                url: userModel.profilePhotoURL,
                hasBorder: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                    child: TextComponent(
                      text: "${userModel.firstName} ${userModel.lastName}",
                      fontWeight: FontWeight.bold,
                      headerType: HeaderType.h4,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                  MarqueeWidget(
                    child: TextComponent(
                      text: userModel.email,
                      headerType: HeaderType.h7,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
