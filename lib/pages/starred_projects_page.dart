import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmallow/components/icon_component.dart';
import 'package:taskmallow/components/text_component.dart';
import 'package:taskmallow/constants/app_constants.dart';
import 'package:taskmallow/constants/category_constants.dart';
import 'package:taskmallow/constants/color_constants.dart';
import 'package:taskmallow/helpers/ui_helper.dart';
import 'package:taskmallow/pages/project_detail_page.dart';
import 'package:taskmallow/pages/update_task_page.dart';
import 'package:taskmallow/routes/route_constants.dart';
import 'package:taskmallow/widgets/base_scaffold_widget.dart';
import 'package:taskmallow/widgets/marquee_widget.dart';

class StarredProjectsPage extends StatefulWidget {
  const StarredProjectsPage({super.key});

  @override
  State<StarredProjectsPage> createState() => _StarredProjectsPageState();
}

class _StarredProjectsPageState extends State<StarredProjectsPage> with TickerProviderStateMixin {
  bool isLoading = false;

  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<ProjectModel> projects = [
    ProjectModel(
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
    ProjectModel(
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
    ProjectModel(
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
    )
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

  void _handleButtonTap() {
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
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const TextComponent(
          text: "Starred Projects",
          color: textPrimaryLightColor,
          headerType: HeaderType.h4,
        ),
        leading: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.chevronLeft),
          onPressed: () => isLoading ? null : Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: const [
                SizedBox(),
              ],
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
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, projectDetailPageRoute);
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
                                  text: projects[index].name,
                                  fontWeight: FontWeight.bold,
                                  headerType: HeaderType.h6,
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
                                  debugPrint(projects[index].name);
                                },
                                icon: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (BuildContext context, Widget? child) {
                                    return Transform.scale(
                                      scale: isExpanded ? _animation.value : 1.0,
                                      child: const IconComponent(
                                        iconData: CustomIconData.star,
                                        color: warning,
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
                },
                childCount: projects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Column(
//           children: [
//             Container(color: Colors.red, height: UIHelper.getDeviceHeight(context) * 1.5),
//             Expanded(
//               child: GridView.count(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(20),
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 crossAxisCount: 2,
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[100],
//                     child: const Text("He'd have you all unravel at the"),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[200],
//                     child: const Text('Heed not the rabble'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[300],
//                     child: const Text('Sound of screams but the'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[400],
//                     child: const Text('Who scream'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[500],
//                     child: const Text('Revolution is coming...'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[600],
//                     child: const Text('Revolution, they...'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[300],
//                     child: const Text('Sound of screams but the'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[400],
//                     child: const Text('Who scream'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[500],
//                     child: const Text('Revolution is coming...'),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.teal[600],
//                     child: const Text('Revolution, they...'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
