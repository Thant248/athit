import 'package:flutter/material.dart';
import 'package:flutter_frontend/const/date_time.dart';
import 'package:flutter_frontend/model/SessionStore.dart';

import 'package:flutter_frontend/model/dataInsert/unread_list.dart';
import 'package:flutter_frontend/services/unreadMessages/unread_message_services.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class unReadDirectMsg extends StatefulWidget {
  const unReadDirectMsg({Key? key}) : super(key: key);

  @override
  State<unReadDirectMsg> createState() => _unReadDirectMsgState();
}

class _unReadDirectMsgState extends State<unReadDirectMsg> {
  var snapshot = UnreadStore.unreadMsg;

  late Future<void> _refreshFuture;

  @override
  void initState() {
    super.initState();
    _refreshFuture = _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    int currentUserId = SessionStore.sessionData!.currentUser!.id!.toInt();
    try {
      var token = await AuthController().getToken();
      var unreadListStore = await UnreadMessageService(Dio())
          .getAllUnreadMsg(currentUserId, token!);
      UnreadStore.unreadMsg = unreadListStore;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _refresh() async {
    await _fetchData();
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
                          itemCount: snapshot!.unreadDirectMsg!.length,
                          itemBuilder: (context, index) {
                            String d_message_name = snapshot!
                                .unreadDirectMsg![index].name
                                .toString();
                            String d_message = snapshot!
                                .unreadDirectMsg![index].directmsg
                                .toString();
                            String d_message_t = snapshot!
                                .unreadDirectMsg![index].created_at
                                .toString();
                            DateTime time = DateTime.parse(d_message_t);
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
                                    d_message_name.characters.first,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              title: Row(
                                children: [
                                  Text(
                                    d_message_name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    created_at,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Color.fromARGB(143, 0, 0, 0)),
                                  )
                                ],
                              ),
                              subtitle: Text(d_message),
                              //  trailing: IconButton(onPressed: (){print(dMessageStar);}, icon: Icon(Icons.star)),
                              // trailing: dMessageStar.isEmpty ? Icon(Icons.star) : Icon(Icons.star_border_outlined),
                            );
                          })),
                ],
              ))),
    ));
  }
}
