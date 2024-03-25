import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/SessionStore.dart';
import 'package:flutter_frontend/model/dataInsert/mention_list.dart';
import 'package:flutter_frontend/model/dataInsert/thread_lists.dart';
import 'package:flutter_frontend/model/dataInsert/unread_list.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:flutter_frontend/screens/Mention/mention_body.dart';
import 'package:flutter_frontend/screens/Star/star_body.dart';
import 'package:flutter_frontend/screens/home/workspacehome.dart';
import 'package:flutter_frontend/screens/threadMessage/thread_message.dart';
import 'package:flutter_frontend/screens/unreadMessage/unread_msg.dart';
import 'package:flutter_frontend/services/mentionlistsService/mention_list.service.dart';
import 'package:flutter_frontend/services/starlistsService/star_list.service.dart';
import 'package:flutter_frontend/services/threadMessages/thread_message_service.dart';
import 'package:flutter_frontend/services/unreadMessages/unread_message_services.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_frontend/model/dataInsert/star_list.dart';
import 'package:dio/dio.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  List<bool> _dataFetched = [false, false, false, false, false];
  static const List<Widget> _page = [
    WorkHome(),
    MentionBody(),
    StarBody(),
    ThreadList(),
    unreadMessage()
  ];

  // Track ongoing asynchronous operations
  List<Completer<void>> _completers = List.filled(5, Completer<void>());

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (!_dataFetched[index]) {
      // Cancel any ongoing operation before starting a new one
      if (!_completers[index].isCompleted) _completers[index].complete();

      // Start a new operation
      _completers[index] = Completer<void>();

      // Fetch data only if not already fetched
      setState(() {
        _isLoading = true;
      });

      await fetchDataForIndex(index);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> fetchDataForIndex(int index) async {
    switch (index) {
      case 1:
        await getAllMentionMessages();
        break;
      case 2:
        await getStarLists();
        break;
      case 3:
        await getThreadMessages();
        break;
      case 4:
        await getAllUnreadMessages();
        break;
    }
    _dataFetched[index] = true; // Set flag to true after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ?  const  ProgressionBar(imageName: "list_sending.json", height: 200, size: 200)
          : _page[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Color.fromARGB(255, 246, 255, 255),
        color: const Color.fromARGB(255, 63, 189, 248),
        animationDuration:  const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
           Icon(Icons.home),
          Icon(Icons.alternate_email),
          Icon(Icons.star),
          Icon(Icons.message_sharp),
          Icon(Icons.mail)
        ],
      ),
    );
  }

  getStarLists() async {
    int currentUserId = SessionStore.sessionData!.currentUser!.id!.toInt();

    try {
      var token = await AuthController().getToken();
      var starListStore = await StarListsService(Dio())
          .getAllStarList(currentUserId, token!);
      StarListStore.starList = starListStore;
    } catch (e) {
      throw e;
    }
  }

  getThreadMessages() async {
    int currentUserId = SessionStore.sessionData!.currentUser!.id!.toInt();
    try {
      var token = await AuthController().getToken();
      var threadListStore =
          await ThreadService(Dio()).getAllThreads(currentUserId, token!);
      ThreadStore.thread = threadListStore;
    } catch (e) {
      throw e;
    }
  }

  getAllMentionMessages() async {
    int currentUserId = SessionStore.sessionData!.currentUser!.id!.toInt();
    try {
      var token = await AuthController().getToken();
      var mentionList = await MentionListService(Dio())
          .getAllMentionList(currentUserId, token!);
      MentionStore.mentionList = mentionList;
    } catch (e) {
      throw e;
    }
  }

  getAllUnreadMessages() async {
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

  @override
  void dispose() {
    // Cancel any ongoing asynchronous operations when the widget is disposed
    _completers.forEach((Completer<void> completer) {
      if (!completer.isCompleted) completer.complete();
    });
    super.dispose();
  }
}
