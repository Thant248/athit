import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/services/threadMessages/thread_message_service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:flutter_frontend/model/dataInsert/thread_lists.dart';
import 'package:dio/dio.dart';

class groupThread extends StatefulWidget {
  const groupThread({Key? key}) : super(key: key);

  @override
  State<groupThread> createState() => _groupThreadState();
}

class _groupThreadState extends State<groupThread> {
  late Future<void> _refrshFuture;
  final _starListService = ThreadService(Dio());

  int userId = SessionStore.sessionData!.currentUser!.id!.toInt();

  @override
  void initState() {
    super.initState();
    _refrshFuture = _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      var token = await getToken();
      var data = await _starListService.getAllThreads(userId, token!);
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          ThreadStore.thread = data;
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
      child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: ThreadStore.thread!.groupThread!.length,
                        itemBuilder: (context, index) {
                          var snapshot = ThreadStore.thread;
                          List GThreadStar =
                              snapshot!.groupThreadStar!.toList();
                          bool star = GThreadStar.contains(
                              snapshot!.groupThread![index].id);
                          String g_thread = snapshot!
                              .groupThread![index].groupthreadmsg
                              .toString();
                          String g_thread_name =
                              snapshot!.groupThread![index].name.toString();
                          String g_thread_t = snapshot!
                              .groupThread![index].created_at
                              .toString();
                          DateTime time = DateTime.parse(g_thread_t);
                          String created_ats =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
                          String created_at =
                              DateTImeFormatter.convertJapanToMyanmarTime(
                                  created_ats);

                          return ListTile(
                              leading: Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.amber,
                                  child: Center(
                                      child: Text(
                                    g_thread_name.characters.first,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              title: Row(
                                children: [
                                  Text(
                                    g_thread_name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(created_at,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color.fromARGB(143, 0, 0, 0)))
                                ],
                              ),
                              subtitle: Text(g_thread),
                              trailing: star
                                  ? const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : null);
                        }),
                  ),
                ],
              ))),
    ));
  }
}
