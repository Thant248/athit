import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/services/starlistsService/star_list.service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_frontend/model/dataInsert/star_list.dart';
import 'package:dio/dio.dart';

class DirectStars extends StatefulWidget {
  const DirectStars({Key? key}) : super(key: key);

  @override
  State<DirectStars> createState() => _DirectStarsState();
}

class _DirectStarsState extends State<DirectStars> {
  late Future<void> _refreshFuture;
  final _starListService = StarListsService(Dio());
  int userId = SessionStore.sessionData!.currentUser!.id!.toInt();

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
        animSpeedFactor: 200,
        showChildOpacityTransition: true,
        child: ListView.builder(
          itemCount: StarListStore.starList?.directStar?.length ?? 0,
          itemBuilder: (context, index) {
            final starList = StarListStore.starList!;
            final star = starList.directStar![index];
            String name = star.name.toString();
            String directmsg = star.directmsg.toString();
            String dateFormat = star.createdAt.toString();
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
                  ),
                ),
              ),
              title: Text(
                directmsg,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                time,
                style: const TextStyle(fontSize: 15),
              ),
            );
          },
        ),
      ),
    );
  }
}
