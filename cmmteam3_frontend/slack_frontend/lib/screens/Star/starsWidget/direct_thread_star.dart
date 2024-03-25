import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/model/dataInsert/star_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_frontend/services/starlistsService/star_list.service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:dio/dio.dart';

class DirectThreadStars extends StatefulWidget {
  const DirectThreadStars({super.key});

  @override
  State<DirectThreadStars> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DirectThreadStars> {
  final _starListService = StarListsService(Dio());
  // ignore: unused_field
  late Future<void> _refreshFuture;

  int userId = SessionStore.sessionData!.currentUser!.id!.toInt();
  var snapshot = StarListStore.starList;

  @override
  void initState() {
    super.initState();
    _refreshFuture = _fetchData();
  }

  @override
  void dispose() {
    // Cancel any ongoing operations here
    super.dispose();
  }

  Future<void> _fetchData() async {
    var token = await getToken();
    var data = await _starListService.getAllStarList(userId, token!);

    if (mounted) {
      setState(() {
        snapshot = data;
      });
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
      animSpeedFactor: 200,
      showChildOpacityTransition: true,
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: snapshot!.directStarThread!.length,
            itemBuilder: (context, index) {
              String name = snapshot!.directStarThread![index].name.toString();
              String directthreadmsg =
                  snapshot!.directStarThread![index].directthreadmsg.toString();
              String dateFormat =
                  snapshot!.directStarThread![index].createdAt.toString();
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
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                title:
                    Text(directthreadmsg, style: const TextStyle(fontSize: 20)),
                subtitle: Text(
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
