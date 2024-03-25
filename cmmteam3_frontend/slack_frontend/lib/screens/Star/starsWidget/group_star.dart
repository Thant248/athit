import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/model/dataInsert/star_list.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:flutter_frontend/services/starlistsService/star_list.service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';

import 'package:dio/dio.dart';

class GroupStarWidget extends StatefulWidget {
  const GroupStarWidget({Key? key}) : super(key: key);

  @override
  State<GroupStarWidget> createState() => _GroupStarState();
}

class _GroupStarState extends State<GroupStarWidget> {
  final _starListService = StarListsService(Dio());

  int userId = SessionStore.sessionData!.currentUser!.id!.toInt();

  // ignore: unused_field
  late Future<void> _refreshFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var token = await getToken();
      var data = await _starListService.getAllStarList(userId, token!);
      if (mounted) {
        setState(() {
          StarListStore.starList = data;
        });
      }
    } catch (e) {}
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
      animSpeedFactor: 200,
      showChildOpacityTransition: true,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: StarListStore.starList!.groupStar!.length,
              itemBuilder: (context, index) {
                var snapshot = StarListStore.starList;
                String name = snapshot!.groupStar![index].name.toString();
                String groupmsg =
                    snapshot!.groupStar![index].groupmsg.toString();
                String channelName =
                    snapshot!.groupStar![index].channelName.toString();
                String dateFormat =
                    snapshot!.groupStar![index].createdAt.toString();
                DateTime dateTime = DateTime.parse(dateFormat);
                String times =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                            String time = DateTImeFormatter.convertJapanToMyanmarTime(times);

                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    color: Colors.amber,
                    child: Center(
                      child: Text(
                        name.characters.first.toUpperCase(),
                        style: const TextStyle(
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
                  subtitle:
                      Text(groupmsg, style: const TextStyle(fontSize: 15)),
                  trailing: Text(
                    time,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
