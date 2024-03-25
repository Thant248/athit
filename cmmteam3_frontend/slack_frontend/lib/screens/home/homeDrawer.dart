// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/screens/Login/login_form.dart';
import 'package:flutter_frontend/screens/userManage/usermanage.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:slide_to_act/slide_to_act.dart';


class HomeDrawer extends StatefulWidget {
  final workspacename,username,useremail;
  const HomeDrawer({super.key,this.useremail,this.username,this.workspacename});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
     backgroundColor: Colors.white54,
     child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Container(
        child: Column(
          children: [
             Padding(
          padding: const EdgeInsets.only(top: 15,bottom: 30),
          child: ListTile(
            leading: Text("Workspace...",
            style: TextStyle(fontSize: 34,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold),),
          ),
        ),
        
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 3,color: Colors.white),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(child: Text(widget.workspacename.toString().characters.first.toUpperCase(),
            style: TextStyle(fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700),)),
          ),
          title: Text("${widget.workspacename.toString()} (${widget.username})",
          style: TextStyle(fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700),),
          subtitle: Text(widget.useremail),
        ),
          ],
        ),
       ),
        
       Container(
        child: Column(
          children: [
             GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserManagement()));
              },
               child: ListTile(
                leading: Icon(Icons.people_outline),
                title: Text("User Management... "),
               ),
             ),
             const SizedBox(height: 5,),
             //////////Change Password ///////////////
             GestureDetector(
              onTap: (){

              },
               child: ListTile(
                leading: Icon(Icons.lock_reset_outlined),
                title: Text('Change Password...'),
               ),
             ),
             const SizedBox(height: 10,),
             /////// log out //////////////
             Container(
             width: 250,
             child: SlideAction(
               borderRadius: 12,
               elevation: 0,
               innerColor: Colors.deepPurple,
               outerColor: Colors.deepPurple[200],
               sliderButtonIcon: const Icon(
                 Icons.logout,
                 color: kPriamrybackground,
               ),
               text: 'Logout',
               onSubmit: () async {
                 await AuthController().removeToken();
                 // ignore: use_build_context_synchronously
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) =>
                             const LoginForm()));
               },
             ))
          ],
        ),
       ),
      ],
     ),
    );
  }
}