import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:flutter_frontend/services/threadMessages/thread_message_service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_frontend/model/dataInsert/thread_lists.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class directThread extends StatefulWidget {
  const directThread({Key? key}) : super(key: key);

  @override
  State<directThread> createState() => _directThreadState();
}

class _directThreadState extends State<directThread> {
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
                        itemCount: ThreadStore.thread!.d_thread!.length,
                        itemBuilder: (context, index) {
                          var snapshot = ThreadStore.thread;
                          if (snapshot!.d_thread!.length == 0) {
                            return const ProgressionBar(
                              imageName: 'dataSending.json',
                              height: 200,
                              size: 200,
                            );
                          } else {
                            List dStar = snapshot!.directMsgstar!.toList();
                            bool star =
                                dStar.contains(snapshot!.d_thread![index].id);
                            String d_thread = snapshot!
                                .d_thread![index].directthreadmsg
                                .toString();
                            String d_thread_name =
                                snapshot!.d_thread![index].name.toString();
                            String d_thread_t = snapshot!
                                .d_thread![index].created_at
                                .toString();
                            DateTime time = DateTime.parse(d_thread_t);
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
                                      d_thread_name.characters.first,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                title: Row(
                                  children: [
                                    Text(
                                      d_thread_name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(created_at,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                Color.fromARGB(143, 0, 0, 0)))
                                  ],
                                ),
                                subtitle: Text(d_thread),
                                trailing: star
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      )
                                    : null);
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              ))),
    ));
  }
}
