import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/mChannelService/m_channel_services.dart';
import 'package:flutter_frontend/services/memberinvite/member_invite.dart';

class DrawerPage extends StatefulWidget {
 final dynamic channelName,memberCount,channelStatus,channelID;
  final member;

   DrawerPage({super.key,this.channelName,this.memberCount,this.channelStatus, this.member, this.channelID});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool light = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFA9FFE4),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.3,
            padding: EdgeInsets.all(10),
            color: Colors.black12,
            child: Center(
              child: ListTile(
                leading:widget.channelStatus ? Icon(Icons.tag,size: 50,color: Colors.white,) 
                : Icon(Icons.lock,size: 50,color: Colors.white),
                  
                  title: Text(widget.channelName,style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),),
                  subtitle: Text('${widget.member.toList().length} : member',style: TextStyle(color: Colors.white),),
                ),
            ),
          ),
          SizedBox(height: 20,),
      
          Container(
            
            height: MediaQuery.of(context).size.height*0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //add button
                GestureDetector(
                  onTap: (){
                  
                  },
                  child: ListTile(
                    leading: Icon(Icons.add,color:Color(0xFF005138) ),
                    title: Text('Member Add...',
                    style: TextStyle(color: Color(0xFF005138),fontWeight: FontWeight.bold)
                    )
                  ),
                ),
                // Edit Button
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: ListTile(
                    leading: Icon(Icons.edit,color:Color(0xFF005138) ),
                    title: Text('Edit channel...',
                    style: TextStyle(color: Color(0xFF005138),fontWeight: FontWeight.bold)
                   )
                  ),
                ),
                
                // see membert
                GestureDetector(
                  onTap: (){
                    showDialog(context: context,

                     builder: (BuildContext context)=>Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.amber,width: 2)
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          child: ListView.builder(
                            itemCount: widget.member.toList().length,
                            itemBuilder: (context,index){
                              
                              return Padding(
                                padding: const EdgeInsets.only(left: 20,top: 20),
                                child: ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[900],
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(color: Colors.white,width: 1
                                      )
                                    ),
                                    child: Center(child: 
                                    Text(widget.member[index].name.toString().characters.first.toUpperCase(),
                                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),))
                                    ),
                                    title: Text(widget.member[index].name.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                    // subtitle: Text(widget.member[index].toString()),
                                    // trailing: Icon(Icons.admin_panel_settings),
                                
                                ),
                              );
                            }),
                        ),
                      )
                     ));
                  },
                  child: ListTile(
                    leading: Icon(Icons.people_alt_outlined,color:Color(0xFF005138) ,),
                    title: Text('see member...',
                    style: TextStyle(color: Color(0xFF005138),fontWeight: FontWeight.bold),
                     ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          // delete
                GestureDetector(
                  onTap: (){
                           MChannelServices().deleteChannel(widget.channelID);           },
                  child: ListTile(
                    leading: Icon(Icons.delete,color:Color(0xFF005138) ),
                    title: Text('Delete channel...',
                    style: TextStyle(color: Color(0xFF005138),fontWeight: FontWeight.bold)
                  ),
                ),
                )
      
          
        ],
      ),
    );
  }
}