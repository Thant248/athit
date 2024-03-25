// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, override_on_non_overriding_member

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/model/groupMessage.dart';
import 'package:flutter_frontend/model/group_thread_list.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:flutter_frontend/services/groupMessageService/group_message_service.dart';
import 'package:flutter_frontend/services/groupThreadApi/groupThreadService.dart';
import 'package:flutter_frontend/services/groupThreadApi/retrofit/groupThread_services.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:intl/intl.dart';
class GpThreadMessage extends StatefulWidget {
  String? name,fname,time,message,channelName;
  final messageID,channelID;
  final channelStatus;
  GpThreadMessage({super.key,this.name,this.fname,this.time,this.message,this.messageID,this.channelID,this.channelStatus,this.channelName});

  @override
  State<GpThreadMessage> createState() => _GpThreadMessageState();
}

class _GpThreadMessageState extends State<GpThreadMessage> with RouteAware {
  StreamController<GroupThreadMessage> _control = StreamController<GroupThreadMessage>();
   StreamController<GroupThreadMessage> _control1 = StreamController<GroupThreadMessage>();

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
    _control.close();
    _control1.close();
    key.currentState!.controller!.dispose();
    super.dispose();
  }
  @override
  void didPopNext(){
    super.didPopNext();
    _startTimer();
    
    
  }
  void _startTimer() async{
    if(!isloading){
      _timer = Timer.periodic(const Duration(seconds: 3),(timer) async{
        try{
          final token = await getToken();
          GroupThreadMessage gpThread = await _GroupThread.getAllThread(
            widget.messageID, widget.channelID, token!);
            _control.add(gpThread);
              _control1.add(gpThread);   
        }
        catch(e){
          print(e);
        }
      });
    }
  }
   GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
   final _GroupThread = GroupThreadServices(Dio());
   
   TextEditingController threadMessage = TextEditingController();
  void _sendGpThread() async {
      String message = threadMessage.text;
      int? channel_id = widget.channelID;
      String mention = '';
      await GpThreadMsg().sendGroupThreadData(message,channel_id!,widget.messageID,mention);
      if(message.isEmpty){
        setState(() {
          GroupThread = message;
        });
      }
      print("GroupThreads : $GroupThread");
      threadMessage.text = "";
    }
    GroupThreadMessage GroupThreadList = GroupThreadMessage();
    String? GroupThread;
    Future<String?> getToken() async{
      return await AuthController().getToken();
    }

    Future<void> sendGroupThreadData(
  String groupMessage, int channelID, int messageID, String mentionName) async { 
  final token = await getToken();
  try {
    await _GroupThread.sendGroupThreadData(
      
      {
        "s_group_message_id": messageID,
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
    
  @override
  Widget build(BuildContext context) {
    dynamic channel = widget.channelStatus? "public"
                                    :"private";
    String threadMsg = widget.message.toString();
    int maxLiane = (threadMsg.length/15).ceil();

    
    return Scaffold(
      backgroundColor: kPriamrybackground,
      appBar: AppBar(
        backgroundColor: navColor,
        leading: GestureDetector(
          onTap: () {
           Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back)),
          title: Column(
            children: [
              ListTile(
                title: Text("Message",style: TextStyle(color: Colors.white),),
                subtitle: Text("${channel} : ${widget.channelName}",style: TextStyle(color: Colors.white)),
              ),
              
            ],
          ),
      ),
       body: Column(
        children: [
          ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("${widget.fname}",style: TextStyle(color: Colors.white,fontSize: 30),)),
            ),
            title: Text("${widget.name}"),
            subtitle: Text("${widget.time}"),
          ),
          Container(
            height: 120,
            child: ListTile(
                  leading: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height:120,
                      color: Colors.amberAccent,
                      child: Text("${threadMsg}",
                       maxLines: maxLiane,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                    ),
                  )
                ),
          ),
              const Divider(),        
         SingleChildScrollView(
          
           
           
            child: Expanded(
              child: StreamBuilder(
                stream: _control.stream,
                
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressionBar(
                      imageName: 'loading.json', height: 200, size: 200,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.GpThreads == null ||
                      snapshot.data!.GpThreads!.isEmpty) {
                    return  ProgressionBar(imageName: 'dataSending.json', height: 200, size: 200,);
                  } else {
                    return Column(
                      children: [
                            Container(
                              height: MediaQuery.of(context).size.height*0.7,
                               child: ListView.builder(
                                itemCount: snapshot.data!.GpThreads!.length,
                                itemBuilder: (context, index) {
                                int GpThreadID = snapshot.data!.GpThreads![index].id!.toInt();
                                String message =snapshot.data!.GpThreads![index].groupthreadmsg.toString();
                                String name = snapshot.data!.GpThreads![index].name.toString();
                                String time = snapshot.data!.GpThreads![index].created_at.toString();
                                DateTime date = DateTime.parse(time);
                                String created_at = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                List GpThreadStarID = snapshot.data!.GpThreadStar!.toList();
                                bool isStar = GpThreadStarID.contains(snapshot.data!.GpThreads![index].id);
                                return Container(
                                      padding: EdgeInsets.only(top:10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 30),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.brown.shade900,
                                            borderRadius: BorderRadius.circular(25)
                                          ),
                                          child: Center(child: Text(name.characters.first.toUpperCase(),
                                          style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),),
                                          
                                        ),
                                        SizedBox(
                                          width:10
                                        ),
                                          Container(
                                            width: MediaQuery.of(context).size.width*0.75,
                                            decoration: BoxDecoration(
                                              color:Colors.grey.shade200,
                                              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(13),
                                              bottomRight:Radius.circular(13),
                                              topRight: Radius.circular(13) )
                                            ),
                                            child: ListTile(
                                             
                                              title: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(message,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                    subtitle: Text(created_at),
                                                  )
                                                ],
                                              ),
                                              trailing: Container(
                                                    width:100,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        
                                                        Container(
                                                          height: 30,
                                                          width: 30,
                                                            child: IconButton(
                                                            onPressed: (){
                                                               if (GpThreadStarID.contains(GpThreadID)) {
                                                                try {
                                                                GpThreadMsg().unStarThread(GpThreadID, widget.channelID, widget.messageID);
                                                                    } catch (e) {
                                                                 print('Error deleting star: $e');
                                                                    }
                                                                }else{
                                                                  print("error");
                                                                    GpThreadMsg().sendStarThread(GpThreadID, widget.channelID, widget.messageID);
                                                                      }
                                                              
                                                               
                                                            }, 
                                                            icon: isStar ?Icon(Icons.star,color: Colors.yellow,):Icon(Icons.star_border_outlined),
                                                                                                  ),
                                                        ),
                                                        const SizedBox(width: 20,),
                                                         Container(
                                                          height: 30,
                                                          width: 30,
                                                            child: IconButton(
                                                            onPressed: (){
                                                                    GpThreadMsg().deleteGpThread(GpThreadID, widget.channelID, widget.messageID);      
                                                            }, 
                                                            icon: Icon(Icons.delete,color: Colors.blueAccent,),
                                                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                  
                                                     
                                );
                                 
                                },
                                                       ),
                             ),
                           
                        
                      ],
                    );
                  }
                },
              ),
            ),
                   
         ),
        ]
      ),
      
      
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(10),
      //   child: Container(
      //     child: Row(
      //       children: [
      //         Expanded(
      //           child: TextField(

      //             controller: threadMessage,
      //             maxLines: null,
      //             textInputAction: TextInputAction.newline,
      //             keyboardType: TextInputType.multiline,
      //             decoration: InputDecoration(
      //               border: InputBorder.none,
      //               hintText: "Send Threads",
      //               focusColor: Colors.grey.shade100,
      //               prefixIcon: GestureDetector(
      //                 onTap: (){
      //                   _sendGpThread();
      //                 },
      //                 child: Icon(Icons.telegram_sharp,size: 30,),
      //               )
      //             ),
      //         ),)
      //       ],
      //     ),
      //   ),
      //   ),
      bottomNavigationBar: StreamBuilder(
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
          GroupThreadMessage groupMessageList = snapshot.data!;
          List<Map<String, Object?>> mention = groupMessageList.MUsers!.map((e){
          
                    return 
                         {
                          'display': e.name,
                           'name': e.name
                         };
                  }
                  ).toList();
                  

            return 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlutterMentions(
                  key: key,
                  suggestionPosition: SuggestionPosition.Top,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                  hintText: 'send threads',
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
                     
                         sendGroupThreadData(name, channel_id!, widget.messageID!,mentionName);
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
                              ),
                ) ;       
                }
        })),
      

  );
  }
}

