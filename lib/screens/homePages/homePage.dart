import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfunction/authentication.dart';
import 'package:fitfunction/models/adapter.dart';
import 'package:fitfunction/screens/homePages/menuPages/menu_page.dart';
import 'package:fitfunction/screens/homePages/postPages/post_page.dart';
import 'package:fitfunction/screens/homePages/profiles/profile_page.dart';
import 'package:fitfunction/screens/homePages/workoutPage/workout_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Authen authentication = Authen();
  ScrollController scrollController;
@override
  void initState() {
  currentUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var flexibleSpaceWidget = SliverAppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Center(
          child: Text(
            'FitFunction',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      bottom: TabBar(

       // labelColor: Colors.black87,
        //unselectedLabelColor: Colors.black26,

        tabs: [
          Tab(
            icon: Image.asset(
              'images/home.png',
              width: 30,
            ),
          ),
          Tab(
            icon: Image.asset('images/dumbbell.png', width: 30),
          ),
          Tab(
            icon: Image.asset('images/person.png', width: 30),
          ),
          Tab(
            icon: Image.asset('images/menu.png', width: 30),
          ),
        ],
      ),
      pinned: true,
      floating: true,
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: 4,
            child: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  flexibleSpaceWidget,
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  PostPage(),
                  WorkoutPage(),
                  ProfilePage(),
                  MenuPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> currentUsers() async{
    currentUser =await FirebaseAuth.instance.currentUser();

  }
}
