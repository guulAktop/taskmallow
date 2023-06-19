import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmallow/components/button_component.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/pages/project_match_page.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isLoading = false;

  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<FavoriteProjectModel> favoriteProjects = [
    FavoriteProjectModel(
      projectModel: ProjectModel(
        name: "Project 1",
        category: Categories.mobile_applications,
        description:
            "TaskMallow, iş yönetimi ve inovasyonu bir araya getiren yenilikçi bir uygulamadır. Projelerinizi yönetmek, görevleri takip etmek, yaratıcı fikirler geliştirmek ve eşleşme özelliğiyle en uygun görevleri bulmak için tasarlanmıştır.",
        userWhoCreated: UserModel(
            email: "enescerrahoglu1@gmail.com",
            firstName: "Enes",
            lastName: "Cerrahoğlu",
            profilePhotoURL:
                "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
        tasks: [],
        collaborators: [],
      ),
      isFavorite: true,
    ),
    FavoriteProjectModel(
      projectModel: ProjectModel(
        name: "Project 2",
        category: Categories.mobile_applications,
        description:
            "TaskMallow, iş yönetimi ve inovasyonu bir araya getiren yenilikçi bir uygulamadır. Projelerinizi yönetmek, görevleri takip etmek, yaratıcı fikirler geliştirmek ve eşleşme özelliğiyle en uygun görevleri bulmak için tasarlanmıştır.",
        userWhoCreated: UserModel(
            email: "enescerrahoglu1@gmail.com",
            firstName: "Enes",
            lastName: "Cerrahoğlu",
            profilePhotoURL:
                "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
        tasks: [],
        collaborators: [],
      ),
      isFavorite: true,
    ),
    FavoriteProjectModel(
      projectModel: ProjectModel(
        name: "Project 3",
        category: Categories.mobile_applications,
        description:
            "TaskMallow, iş yönetimi ve inovasyonu bir araya getiren yenilikçi bir uygulamadır. Projelerinizi yönetmek, görevleri takip etmek, yaratıcı fikirler geliştirmek ve eşleşme özelliğiyle en uygun görevleri bulmak için tasarlanmıştır.",
        userWhoCreated: UserModel(
            email: "enescerrahoglu1@gmail.com",
            firstName: "Enes",
            lastName: "Cerrahoğlu",
            profilePhotoURL:
                "https://firebasestorage.googleapis.com/v0/b/taskmallow-app.appspot.com/o/team%2Fenes.jpg?alt=media&token=faac91a0-5467-4c4f-ab33-6f248ba88b75"),
        tasks: [],
        collaborators: [],
      ),
      isFavorite: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleButtonTap() {
    setState(() {
      isExpanded = true;
    });

    _animationController.forward().whenComplete(() {
      setState(() {
        isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundLightColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const TextComponent(
          text: "Hello User",
          color: textPrimaryLightColor,
          headerType: HeaderType.h4,
        ),
        leading: null,
        leadingWidth: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchPageRoute);
            },
            icon: const IconComponent(
              iconData: CustomIconData.magnifyingGlass,
            ),
            splashRadius: AppConstants.iconSplashRadius,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, invitationsPageRoute);
            },
            icon: const IconComponent(
              iconData: CustomIconData.envelopes,
            ),
            splashRadius: AppConstants.iconSplashRadius,
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getMatchingContainer(),
                  const SizedBox(height: 20),
                  const TextComponent(
                    text: "Some Projects",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: UIHelper.getDeviceWidth(context) / 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return getProjectGridCard(favoriteProjects[index]);
                },
                childCount: favoriteProjects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMatchingContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: matchColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconComponent(
                iconData: CustomIconData.wandMagicSparkles,
                color: textPrimaryDarkColor,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: TextComponent(
                  text: "See the most suitable projects for you instantly with the matching feature.",
                  textAlign: TextAlign.start,
                  color: textPrimaryDarkColor,
                  headerType: HeaderType.h6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ButtonComponent(
            text: "Start Matching",
            isOutLined: true,
            isWide: true,
            textPadding: 6,
            color: textPrimaryDarkColor,
            onPressed: () {
              Navigator.pushNamed(context, projectMatchPageRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget getProjectGridCard(FavoriteProjectModel favoriteProjectModel) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(context, projectScreenPageRoute);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: itemBackgroundLightColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MarqueeWidget(
                  child: TextComponent(
                    text: favoriteProjectModel.projectModel.name,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: UIHelper.getDeviceWidth(context) / 5,
                        width: UIHelper.getDeviceWidth(context) / 5,
                        child: const CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 15,
                          backgroundColor: secondaryColor,
                          value: 0.75,
                        ),
                      ),
                      const TextComponent(
                        text: "100%",
                        headerType: HeaderType.h7,
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    debugPrint(favoriteProjectModel.projectModel.name);
                    setState(() {
                      favoriteProjectModel.isFavorite = !favoriteProjectModel.isFavorite;
                    });
                  },
                  icon: AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: isExpanded ? _animation.value : 1.0,
                        child: IconComponent(
                          iconData: CustomIconData.star,
                          color: primaryColor,
                          iconWeight: favoriteProjectModel.isFavorite ? CustomIconWeight.solid : CustomIconWeight.regular,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
