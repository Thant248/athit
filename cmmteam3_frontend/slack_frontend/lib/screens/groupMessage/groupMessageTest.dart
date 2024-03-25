// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:async';
// import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';
// import 'package:flutter_frontend/model/channelUser.dart';
import 'package:flutter_frontend/model/groupMessage.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:flutter_frontend/screens/groupMessage/DrawerTest.dart/drawer.dart';
import 'package:flutter_frontend/screens/groupMessage/groupThread.dart';
// import 'package:flutter_frontend/services/channelUser/channelUserService.dart';
import 'package:flutter_frontend/services/groupMessageService/group_message_service.dart';
import 'package:flutter_frontend/services/groupMessageService/retrofit/groupMessage_Services.dart';
// import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
enum SampleItem { itemOne ,itemTwo, itemThree }

class groupMessage extends StatefulWidget {
  final channelID ,channelName,workspace_id;
  final channelStatus;
  final member;
   groupMessage({super.key, this.channelID,this.channelStatus,this.channelName,this.member,this.workspace_id});
   
    

  @override
  State<groupMessage> createState() => _groupMessageState();
}

class _groupMessageState extends State<groupMessage> with RouteAware {
    GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
    final _GroupMessage = GroupMessageServices(Dio());
    // final _channelUser = channelUser(Dio());
  // final TextEditingController _sendMessageController = TextEditingController();
  StreamController<groupMessageData> _control = StreamController<groupMessageData>();
  StreamController<groupMessageData> _control1 = StreamController<groupMessageData>();
  String? GroupMessageName;
  late Timer _timer;
  bool isloading = false;
  @override
  void initState(){
    super.initState();
    _startTimer();

  }
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }
  @override
  void didPopNext(){
    super.didPopNext();
    _startTimer();
  }
  RetrieveGroupMessage data = RetrieveGroupMessage();
  void _startTimer() async {
    if(!isloading){
      _timer = Timer.periodic( const Duration(seconds: 4), (timer) async {
        try {
          final token = await getToken();
          
          groupMessageData gpMessage = await _GroupMessage.getAllGpMsg(
            widget.channelID, token!);
         
             setState(() {
            data = gpMessage.retrieveGroupMessage!; // Update data here
          });
            _control.add(gpMessage);
            _control1.add(gpMessage);
        }
        catch(e){
          print(e);
        }
       });
    }
  }
   Future<void> sendGroupMessageData(
  String groupMessage, int channelID, String mentionName) async { 
  final token = await getToken();
  try {
    await _GroupMessage.sendGroupMsgData(
      
      {
        
        "s_channel_id": channelID,
        "message": groupMessage,
        "mention_name": mentionName

      },
     token!
    );
    print("Send GroupThread Successfully");
  } catch (e) {
    print("Send GroupThread fail: $e");
  }
}

  // void _groupMessageSend() async {
  //   String messageText = _sendMessageController.text;
  //   int channel_id= widget.channelID;
  //  await sendGroupMessageData(messageText , channel_id);
  //   if (messageText.isNotEmpty) {
  //     setState(() {
  //       GroupMessageName = messageText;
  //     });
  //   }

  // }
  
  
  groupMessageData ? _getUserDetails;

  //  @override
  // void initState() {
  //   super.initState();
  //   fetchUserDetailsUpdate();
  //   print("fetchUserDetailsUpdate");
  //   print(fetchUserDetailsUpdate);
    
  // }
  Future<void> fetchUserDetailsUpdate() async {
    _getUserDetails = await fetchAlbum(widget.channelID);

    setState(() {
      //  channelName1 = _getUserDetails!.mChannel!.channelName.toString();
       memberCount =  _getUserDetails!.retrievehome!.mUsers!.length;
      //  Member
    });
    
    
  }
   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }
   
   
   String? channelName;
   int? memberCount; 
    
  @override
  Widget build(BuildContext context) {
    int? groupMessageID;
    int? channelID;
   
    return Scaffold(
       key: _scaffoldKey,
      backgroundColor: kPriamrybackground,
      drawer: Drawer(
        child: DrawerPage(
        channelName: widget.channelName,
        channelStatus:widget.channelStatus,
        memberCount: memberCount,
        member:data.mChannelUsers,
        channelID: channelID,)
      ),
      appBar: AppBar(
        backgroundColor: navColor,
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () {
           Navigator.pop(context);
          print(data.mChannelUsers);
        },),
        title: Row(
          children: [
            Container(
              child: widget.channelStatus ? Icon(Icons.tag,color: Colors.white,):
              Icon(Icons.lock,color: Colors.white,),
               
            ),
            const SizedBox(width: 10,),
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    _openDrawer();
                  },
                  child: Text(widget.channelName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                
              ],
            ),
          ],
        ),
        

      ),
      body: SingleChildScrollView(
            child: Container(
              child: StreamBuilder<groupMessageData?>(
              stream: _control.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  groupMessageData groupMessageList = snapshot.data!;
                  int groupMessageLength = groupMessageList.retrieveGroupMessage!.tGroupMessages!.length.toInt();
                  // List<Map<String,dynmaic>> mention = groupMessageList.retrievehome.mUsers.asMap
                  // print("SnapshotData");
                  // print(groupMessage.mChannel!.channelName.toString());
                  return Column(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.83,
                          child: ListView.builder(
                            itemCount: groupMessageLength,
                            itemBuilder: (BuildContext context, int index) {
                              SampleItem? selectedItem;
                            // Star 
                            // List tgroupMessageId = groupMessageList
                            // .retrieveGroupMessage!.tGroupMessages!
                            // .map((e) => e.id)
                            // .toList();
                           
                           List tgroupStarMessageIds = groupMessageList
                            .retrieveGroupMessage!.tGroupStarMsgids!
                            .toList();
                           
                           bool isStarred = tgroupStarMessageIds.contains(groupMessageList
                            .retrieveGroupMessage!.tGroupMessages![index].id);
                              
                              int? count = groupMessageList.retrieveGroupMessage!.tGroupMessages![index].count;
                              int messageID = groupMessageList.retrieveGroupMessage!.tGroupMessages![index].id!.toInt();
                              String message = groupMessageList.retrieveGroupMessage!.tGroupMessages![index].groupmsg.toString();
                              List<TGroupMessages>? name = groupMessageList.retrieveGroupMessage!.tGroupMessages;
                              String time = groupMessageList.retrieveGroupMessage!.tGroupMessages![index].createdAt.toString();
                              DateTime date = DateTime.parse(time);
                              String created_at = DateFormat('yyyy-MM-dd').format(date);
                              // Drawer(
                              //   child:DrawerPage(channelName: widget.channelName,channelStatus: widget.channelStatus,member:name,),
                              // );
                              return Container(
                                 padding: EdgeInsets.only(top: 10),
                                  width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: Center(child: Text(name![index].name.toString().characters.first.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),)
                                            )
                                            ),
                                            SizedBox(height: 22,)
                                          ],
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          
                                          width: MediaQuery.of(context).size.width*0.75,
                                          decoration:BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))
                                          ),
                                          child: ListTile(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(message,style: TextStyle(fontSize: 18),),
                                                    subtitle: Row(
                                                      children: [
                                                        Text('Thread : $count',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                                        const SizedBox(width: 25,),
                                                        Text(created_at,style: TextStyle(fontSize: 10),),
                                                        
                                                        
                                                      ],
                                                    ),
                                                  ),
                                                  
                                                ],
                                              ),
                                            ),
                                             trailing:  PopupMenuButton<SampleItem>(
                                                  initialValue: selectedItem,
                                                  onSelected: (SampleItem item) {
                                                    setState(() {
                                                      selectedItem = item;
                                                    });
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                                                                         PopupMenuItem<SampleItem>(
                                                                          value: SampleItem.itemOne,
                                                                          onTap: () async {
                                          setState(() {
                                            groupMessageID = groupMessageList
                                                .retrieveGroupMessage!
                                                .tGroupMessages![index]
                                                .id!
                                                .toInt();
                                            channelID = groupMessageList
                                                .retrieveGroupMessage!.sChannel!.id!
                                                .toInt();
                                          });
                                           if (tgroupStarMessageIds.contains(groupMessageID)) {
                                            try {
                                                  await deleteGroupStarMessage(groupMessageID!,channelID!);
                                                } catch (e) {
                                                  print('Error deleting star: $e');
                                                }
                                           }else{
                                                await getMessageStar(
                                              groupMessageID!, channelID!);
                                           }
                                                                          },
                                                                          // onTap: _groupStarUnstar(groupMessageID!,channelID!),
                                                                          child: ListTile(
                                            leading:
                                                    isStarred ?? true
                                                    ? const Icon(Icons.star,color: Colors.yellow)
                                                    : const Icon(Icons.star_outline,color: Colors.black),
                                            title: Text("Star")),
                                                                        ),
                                                       PopupMenuItem<SampleItem>(
                                                        value: SampleItem.itemTwo,
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(
                                                            builder: (context)=>GpThreadMessage(
                                                              channelID: widget.channelID,
                                                              channelStatus: widget.channelStatus,
                                                              channelName: widget.channelName,
                                                              messageID: messageID,
                                                              message : message,
                                                              name: name[index].name.toString(),
                                                              time: created_at,
                                                              fname: name[index].name.toString().characters.first.toUpperCase(),)));
                                                        },
                                                        child: ListTile(
                                                          leading: Icon(Icons.reply),
                                                          title: Text('Threads'),
                                                        )
                                                      ),
                                                       PopupMenuItem<SampleItem>(
                                                                          value: SampleItem.itemThree,
                                                                          onTap: () async {
                                          setState(() {
                                            groupMessageID = groupMessageList
                                                .retrieveGroupMessage!
                                                .tGroupMessages![index]
                                                .id!
                                                .toInt();
                                            channelID = groupMessageList
                                                .retrieveGroupMessage!.sChannel!.id!
                                                .toInt();
                                          });
                                          await deleteGroupMessage(
                                              groupMessageID!, channelID!);
                                                                          },
                                                                          child: ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('delete'),
                                                                          ),
                                                                        ),
                                                      
                                                      ]                     ,
                                                  ),
                                             ),
                                        ),
                                      ],
                                    ),
                                  
                                
                              );
                                                  },
                                                ),
                                                
                                            ),
                      ),
            
                    ]
                    
                  ); 
                }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },),
            ),
          ),  
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: _control1.stream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressionBar(
                      imageName: 'loading.json', height: 200,size: 200,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null) {
                    return const ProgressionBar(imageName: 'dataSending.json', height: 200, size: 200,);
                  } else {
            groupMessageData groupMessageList = snapshot.data!;
            List<Map<String, Object?>> mention = groupMessageList.retrievehome!.mUsers!.map((e){
            
                      return 
                           {
                            'display': e.name,
                             'name': e.name
                           };
                    }
                    ).toList();
                    
        
              return 
                  FlutterMentions(
                key: key,
                suggestionPosition: SuggestionPosition.Top,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'send messages',
                  prefixIcon: GestureDetector(
                    onTap: (){
        
                      // _sendGpThread();
                       String name = key.currentState!.controller!.text;
                        int? channel_id = widget.channelID;
                       
                        String mentionName = " ";
                        mention.forEach((data) {
                         if (name.contains('@${data['display']}')) {
                            mentionName = '@${data['display']}';
                           print("mentionName");
                           print(mentionName);
                    //  GpThreadMsg().sendGroupThreadData(name, channel_id!, widget.messageID!,mentionName);
                         }
                        });
                       
                       sendGroupMessageData(name, channel_id!,mentionName);
                     // print(message);
                       key.currentState!.controller!.text = " ";
                    
                        
        
                        
                    },
                    child: Icon(Icons.telegram,color: Colors.blue,))
                  ),
                mentions: [
                  Mention(
                      trigger: '@',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                     data: mention,
                      matchAll: false,
                      suggestionBuilder: (data) {
                        
                        return Container(
                          color: Colors.grey.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                children: <Widget>[
                                  //  Text(data['display']),
                                   Text('@${data['display']}'),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                  
                ],
              ) ;       
                  }
          })),
      ),
        
      

      
    );
  }
}
  