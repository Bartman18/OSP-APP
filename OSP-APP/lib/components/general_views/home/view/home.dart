import 'dart:developer';
//import 'dart:math' ;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_core/components/general_views/home/bloc/home_bloc.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/enums/statuses.dart';
import 'package:fox_core/widgets/bottom_navigation/bottom_bar.dart';
import 'package:fox_core/widgets/bottom_navigation/dashboard_view.dart';
import 'package:fox_core/widgets/card.dart';
import 'package:fox_core/components/general_views/home/widgets/event.dart';
import 'package:fox_core/widgets/skeleton.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fox_core/core/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fox_core/core/repositories/user.dart';
import 'package:get_it/get_it.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepository = GetIt.instance<UserRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  Widget _buildTitleWidget(BuildContext context) {
    String profilePicture = _userRepository.profile.profilePicture;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.settings);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CoreColors.gray.withAlpha(40),
                    border: Border.all(color: CoreColors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: profilePicture.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: profilePicture,
                      fit: BoxFit.contain,
                    )
                        : SvgPicture.asset(
                      'assets/icons/profile.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "home_view.header.hello".tr() + " Użytkownik",
                    style: CoreTheme.mediumTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 16,
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/coin.png',
                          width: 15,
                        ),
                        SizedBox(width: 3,),
                        Text(
                          "home_view.header.you_have".tr() + " 420 " + "home_view.header.points".tr(),
                          style: CoreTheme.baseTextStyle.copyWith(
                            color: CoreColors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Align(
          widthFactor: 0.7,
          alignment: Alignment.centerRight,
          child: Row(
          children: [ 
            IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.settings),
            icon: Image.asset('assets/icons/present.png', width: 20,),
            
          ),
            IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.settings),
            icon: SvgPicture.asset('assets/icons/user.svg'),
          ),
          ],
        ),
        ),
      ],
    );
  }

  

  Widget _buildForYou(HomeState state) {
    String clockStr = "";
    
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Wrap(
            children: [
              if (index == 0) _buildTitleWidget(context),
              SizedBox(height: 70,),
              const AdCard(
                title: "Odbierz 200 PLN w SuperBet", 
                subtitle: "+ zwrot pierwszego przegranego kuponu", 
                buttonText: "Skorzystaj", 
                buttonURL: "https://superbet.pl/intro",
                backgroundImageURL: 'assets/placeholder/superBet.png',
                ),
                SizedBox(height: 200,),
                Row(
                  children:[
                    Text(
                      "home_view.play".tr(),
                      style: CoreTheme.boldTextStyle.copyWith(
                      color: CoreColors.white,
                      fontSize: 26,
                    ),
                    ),
                    Spacer(flex: 1,),
                    /*Container(
                      width: 128,
                      height: 29,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Color.fromRGBO(255, 137, 0, 1), Color.fromRGBO(254, 204, 2, 1)],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          )
                      ),
                      
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/clock.png', width: 15),
                            SizedBox(width: 3),
                            Text(
                               clockStr,
                                style: CoreTheme.semiBoldTextStyle.copyWith(
                                color: CoreColors.black,
                                fontSize: 12,
                              ),
                              ),
                          ],
                        ),
                    )
                  ],
                ),*/
                  ],
                ),
                SizedBox(height: 30,),
                
                
              //Match(betsModel: betsModelList[0],),
              const AdCard(
                title: "Podwój stawkę jednego meczu", 
                subtitle: "Obejrzyj reklamę z nagrodą", 
                buttonText: "Odbierz", 
                buttonURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley",
                backgroundImageURL: 'assets/placeholder/goldAd.png',
                ),
            ],
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 20),
        itemCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.stateStatus == StateStatus.loading) {
            context.loaderOverlay.show();
          }
          if (state.stateStatus != StateStatus.loading) {
            context.loaderOverlay.hide();
          }
        },
        builder: (BuildContext context, HomeState state) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: CoreColors.black,
                ),
              ),
          DashboardView(
            highlightedTab: BottomBarTab.home,
             child: Skeleton(
                padding: const EdgeInsets.only(left: 20, right: 20),
                removeAppBar: true,
                backgroundColor: Colors.transparent,
                child: _buildForYou(state),
              ),
          ),
            ],
          );
        }
    );
  }
}
