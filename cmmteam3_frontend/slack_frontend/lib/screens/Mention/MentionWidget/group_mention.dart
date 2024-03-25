import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/model/dataInsert/mention_list.dart';
import 'package:flutter_frontend/services/mentionlistsService/mention_list.service.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:dio/dio.dart';

class GroupMessages extends StatefulWidget {
  const GroupMessages({super.key});

  @override
  State<GroupMessages> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessages> {
 
  final _mentionListService = MentionListService(Dio());
  late Future<void> _refreshFuture;

 int userId = SessionStore.sessionData!.currentUser!.id!.toInt();
  @override
  void initState() {
    super.initState();
    // _refreshFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var token = await getToken();
      var data = await _mentionListService.getAllMentionList(userId, token!);
      if (mounted) {
        MentionStore.mentionList = data;
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
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: LiquidPullToRefresh(
                  onRefresh: _refresh,
                  color: Colors.blue.shade100,
                  animSpeedFactor: 100,
                  showChildOpacityTransition: true,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(

                          itemCount: MentionStore.mentionList!.groupMessage!.length,
                          itemBuilder: (context, index) {
                             var snapshot = MentionStore.mentionList;
                          List gpThreadStar = snapshot!.groupStar!.toList();
                          bool star = gpThreadStar.contains(snapshot!.groupMessage![index].id);
                            String dateFormat = snapshot!
                                .groupMessage![index].createdAt
                                .toString();
                            DateTime dateTime = DateTime.parse(dateFormat);
                            String time =
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                            String name =
                                snapshot!.groupMessage![index].name.toString();
                            String groupmsg = snapshot!
                                .groupMessage![index].groupmsg
                                .toString();
                            String channelName = snapshot!
                                .groupMessage![index].channelName
                                .toString();
                            return ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.amber,
                                  // decoration: BoxDecoration(
                                  //     color: Colors.blueGrey,
                                  //     borderRadius: BorderRadius.circular(25),
                                  //     border: const Border(
                                  //       top: BorderSide(color: Colors.white),
                                  //       bottom: BorderSide(color: Colors.white),
                                  //     )),
                                  child: Center(
                                      child: Text(
                                    name.characters.first.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                title: Row(
                                  children: [
                                    Text(channelName,style: TextStyle(fontSize: 20),),
                                    SizedBox( width: 20,),
                                    Text(time,style: TextStyle(fontSize: 10),)
                                  ],
                                ),
                                subtitle: Text(
                                  groupmsg,style: TextStyle(fontSize: 15),),
                                trailing: star? Icon(Icons.star,color:Colors.yellow): null
                              );
                            
                          },
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
