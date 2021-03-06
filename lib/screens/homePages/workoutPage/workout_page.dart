import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitfunction/models/adapter.dart';
import 'package:fitfunction/screens/homePages/workoutPage/createPlan_page.dart';
import 'package:fitfunction/screens/homePages/workoutPage/myplan.dart';
import 'package:fitfunction/screens/homePages/workoutPage/view_workout_page.dart';
import 'package:fitfunction/widgets/circularProgress.dart';
import 'package:fitfunction/widgets/timer_current.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final sharePlan = StreamBuilder(
      stream: Firestore.instance.collection('SharePlan').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data == null) {
          return Container();
        } else {
          return Column(
            children: List.generate(snapshot.data.documents.length, (index) {
              DocumentSnapshot snapShare = snapshot.data.documents[index];
              return StreamBuilder(
                stream: Firestore.instance
                    .collection('Workout')
                    .document(snapShare.data['workoutID'])
                    .snapshots(),
                builder: (context, snapWorkout) {
                  if (snapWorkout.connectionState == ConnectionState.waiting) {
                    return CircularProgress(
                      title: 'ກຳລັງໂຫຼດ...',
                    );
                  } else if (snapWorkout.data == null) {
                    return Container();
                  } else {
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection('Users')
                          .document(snapShare.data['userID'])
                          .snapshots(),
                      builder: (context, snapUserInfo) {
                        if (snapUserInfo.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgress(
                            title: 'ກຳລັງໂຫຼດ..',
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapUserInfo.data['urlProfile']),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(
                                snapWorkout.data['workoutName'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(TimerCurrent().readTimestamp(
                                      snapShare.data['timestamp'])),
                                  Text('ລະດັບ: ${snapWorkout.data['level']}'),
                                  Text('ປະເພດ: ${snapWorkout.data['type']}'),
                                ],
                              ),
                              trailing: InkWell(
                                child: Icon(Icons.favorite_border),
                                onTap: () {},
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewWorkoutPage(
                                        snapUserInfo.data['name'],
                                        snapUserInfo.data['surname'],
                                        snapUserInfo.data['urlProfile'],
                                        snapShare.data['workoutID']),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }),
          );
        }
      },
    );

    ///====================================================
    final favoriteLis = StreamBuilder(
      stream: Firestore.instance
          .collection('Workout')
          .where('favorite', arrayContains: currentUser.uid)
          .snapshots(),
      builder: (context, snapFavorite) {
        if (snapFavorite.connectionState == ConnectionState.waiting) {
          return CircularProgress(
            title: 'ກຳລັງໂຫຼດ',
          );
        }
        if (snapFavorite.data.documents.length < 1) {
          return Container();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapFavorite.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot snappp = snapFavorite.data.documents[index];
              return InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: Image.asset(
                              'images/person.png',
                              width: 20,
                            ),
                            title: Text(
                              '${snappp.data['workoutName']}',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Icon(
                              Icons.favorite,
                              color: Colors.orange,
                            )),
                        Text('ລະດັບ: ${snappp.data['level']}'),
                        Text('ປະເພດ: ${snappp.data['type']}'),
                      ],
                    ),
                  ),
                ),
                onTap: () {
//            Navigator.of(context).push(
//                MaterialPageRoute(builder: (context) => ViewWorkoutPage()));
                },
              );
            },
          );
        }
      },
    );

    ///Favorite
    /// ========================================================
    final createButton = Align(
      alignment: Alignment.topRight,
      child: RaisedButton.icon(
        elevation: 1,
        color: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(5),
        icon: Icon(
          Icons.add,
          color: Colors.orange,
        ),
        label: Text('ສ້າງແຜນໃຫມ່'),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreatePlan()));
        },
      ),
    );
    final searchText = SizedBox(
      height: 35,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'ຄົ້ນຫາ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              32.0,
            ),
            borderSide: BorderSide(width: 1),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
        ),
      ),
    );
    return Container(
      child: ListView(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Workout')
                    .where('userID', isEqualTo: currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgress(
                      title: 'ກຳລັງໂຫຼດ...',
                    );
                  }

                  if (snapshot.data.documents.length < 1) {
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreatePlan(),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        searchText,
                        createButton,
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot snapWorkout =
                                  snapshot.data.documents[index];
                              return StreamBuilder(
                                stream: Firestore.instance
                                    .collection('Users')
                                    .document(snapWorkout.data['userID'])
                                    .snapshots(),
                                builder: (context, snapUserInfo) {
                                  if (!snapUserInfo.hasData) {
                                    return Container();
                                  }

                                  return InkWell(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 3,
                                      child: Container(
                                        margin: EdgeInsets.all(3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      '${snapUserInfo.data['urlProfile']}'),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                title: Text(
                                                  '${snapWorkout.data['workoutName']}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                trailing: PopupMenuButton(
                                                  onSelected: (value) {
                                                    if (value == 1) {
                                                      deleteWorkout(snapWorkout
                                                              .documentID)
                                                          .then((value) {
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'ລຶບສຳເລັດແລ້ວ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 1,
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                )),
                                            Text(
                                                'ລະດັບ: ${snapWorkout.data['level']}'),
                                            Text(
                                                'ປະເພດ: ${snapWorkout.data['type']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MyPlanPage(
                                              snapWorkout.documentID,
                                              snapWorkout.data['workoutName'],
                                              snapUserInfo.data['urlProfile']),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 120,
                          child: favoriteLis,
                        ),
                        sharePlan,
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteWorkout(String workOutID) async {
    await Firestore.instance.collection('Workout').document(workOutID).delete();
  }
}
