import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/model/dataInsert/star_list.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_frontend/services/starlistsService/star_list.service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';

import 'package:dio/dio.dart';

class GroupThreadStar extends StatefulWidget {
  const GroupThreadStar({super.key});

  @override
  State<GroupThreadStar> createState() => _GroupThreadStarState();
}

class _GroupThreadStarState extends State<GroupThreadStar> {
  final _starListService = StarListsService(Dio());

  // ignore: unused_field
  late Future<void> _refreshFuture;

  int userId = SessionStore.sessionData!.currentUser!.id!.toInt();
  

  @override
  void initState() {
    super.initState();
    _refreshFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var token = await getToken();
      var data = await _starListService.getAllStarList(userId, token!);
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          StarListStore.starList = data;
        });
      }
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _refresh() async {
    await _fetchData();
  }

  Future<String?> getToken() async {
    return await AuthController().getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiquidPullToRefresh(
      onRefresh: _refresh,
      color: Colors.blue.shade100,
      animSpeedFactor: 100,
      showChildOpacityTransition: true,
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: StarListStore.starList!.groupStarThread!.length,
            itemBuilder: (context, index) {
              var snapshot = StarListStore.starList;
              String name = snapshot!.groupStarThread![index].name.toString();
              String groupthreadmsg =
                  snapshot!.groupStarThread![index].groupthreadmsg.toString();
              String channelName =
                  snapshot!.groupStarThread![index].channelName.toString();
              String dateFormat =
                  snapshot!.groupStarThread![index].createdAt.toString();
              DateTime dateTime = DateTime.parse(dateFormat);
              String times = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                          String time = DateTImeFormatter.convertJapanToMyanmarTime(times);

              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  color: Colors.amber,
                  child: Center(
                    child: Text(
                      name.characters.first.toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  channelName,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  groupthreadmsg,
                  style: const TextStyle(fontSize: 15),
                ),
                trailing: Text(
                  time,
                  style: const TextStyle(fontSize: 15),
                ),
              );
            },
          ),
        ),
      ]),
    ));
  }
}
