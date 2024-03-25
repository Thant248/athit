  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'package:flutter_frontend/componnets/Nav.dart';
  import 'package:flutter_frontend/constants.dart';
  import 'package:flutter_frontend/model/SessionStore.dart';
  import 'package:flutter_frontend/model/direct_message.dart';
  import 'package:flutter_frontend/progression.dart';
  import 'package:flutter_frontend/screens/directThreadMessage/direct_message_thread.dart';
  import 'package:flutter_frontend/services/directMessage/direct_message_api.dart';

  import 'package:dio/dio.dart';
  import 'package:flutter_frontend/services/directMessage/retrofit/direct_meessages.dart';
  import 'package:flutter_frontend/services/userservice/api_controller_service.dart';
  import 'package:intl/intl.dart';

  enum SampleItem { itemOne, itemTwo, itemThree }

  class DirectMessageWidget extends StatefulWidget {
    final int userId;
    final String receiverName;

    const DirectMessageWidget({
      Key? key,
      required this.userId,
      required this.receiverName,
    }) : super(key: key);

    @override
    State<DirectMessageWidget> createState() => _DirectMessageWidgetState();
  }

  class _DirectMessageWidgetState extends State<DirectMessageWidget>
      with RouteAware {
    final DirectMessageService directMessageService = DirectMessageService();
    final TextEditingController messageTextController = TextEditingController();
    String currentUserName =
        SessionStore.sessionData!.currentUser!.name.toString();
    StreamController<DirectMessages> _controller =
        StreamController<DirectMessages>();

    final _apiService = ApiService(Dio());

    bool isreading = false;
    bool isSelected = false;
    bool isStarred = false;
    int? _selectedMessageIndex;
    int? selectUserId;

    late Timer _timer;
    // final ScrollController _scrollController = ScrollController();

    @override
    void initState() {
      super.initState();
      _startTimer();
    
    }

    @override
    void dispose() {
      _timer.cancel();
      _controller.close();
      messageTextController.dispose();

      super.dispose();
    }

    @override
    void didPopNext() {
      super.didPopNext();
       _timer.cancel();
      // _startTimer(); // Restart the timer when returning to this page
    }

    @override
    void didPushNext() {
      
      super.didPushNext();
      _timer.cancel();
      // _startTimer();
    }

    void _startTimer() async {
      if (!isreading) {
        _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
          try {
            final token = await getToken();
            DirectMessages directMessages =
                await _apiService.getAllDirectMessages(widget.userId, token!);
            _controller.add(directMessages);
          } catch (e) {
            print("Error fetching messages: $e");
          }
        });
      }
    }

    Future<void> sendMessage() async {
      if (messageTextController.text.isNotEmpty) {
        await directMessageService.sendDirectMessage(
            widget.userId, messageTextController.text);
        messageTextController.clear();
      }
    }

    Future<String?> getToken() async {
      return await AuthController().getToken();
    }

    String convertJapanToMyanmarTime(String japanTime) {
      DateTime japanDateTime = DateTime.parse(japanTime);

      DateTime myanmarDateTime =
          japanDateTime.add(const Duration(hours: -2, minutes: -30));

      String myanmarTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(myanmarDateTime);

      return myanmarTime;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState() {
                isreading = !isreading;
              }

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Nav()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.lightBlue,
          title: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                height: 50,
                width: 50,
                child: Center(
                  child: Text(
                    widget.receiverName.isNotEmpty
                        ? "${widget.receiverName.characters.first.toUpperCase()}"
                        : "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.receiverName}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
        body: StreamBuilder<DirectMessages>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const ProgressionBar(
                imageName: 'dataSending.json',
                height: 200,
                size: 200,
              );
            } else {
              final directMessages = snapshot.data!;

              int directMessage = directMessages.tDirectMessages!.length.toInt();
              return Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.83,
                      child: ListView.builder(
                        itemCount: directMessage,
                        itemBuilder: (context, index) {
                          var channelStar = directMessages.tDirectMessages;
                          List<int> tempStar =
                              directMessages.tDirectStarMsgids!.toList();

                          bool isStared =
                              tempStar.contains(channelStar![index].id);

                          String message = directMessages
                              .tDirectMessages![index].directmsg!
                              .toString();
                          // String messageedUser = directMessages
                          //     .tDirectMessages![index].name
                          //     .toString();
                          int count = directMessages
                              .tDirectMessages![index].count!
                              .toInt();
                          String time = directMessages
                              .tDirectMessages![index].createdAt
                              .toString();
                          DateTime date = DateTime.parse(time).toLocal();

                          String created_at =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

                          String myanmarTime =
                              convertJapanToMyanmarTime(created_at);

                          bool isMessageFromCurrentUser = currentUserName ==
                              directMessages.tDirectMessages![index].name;
                          int directMsgIds = directMessages.tDirectMessages![index].id!.toInt();

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedMessageIndex =
                                    directMessages.tDirectMessages![index].id;
                                isSelected = !isSelected;
                              });
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isMessageFromCurrentUser)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (_selectedMessageIndex ==
                                                  directMessages
                                                      .tDirectMessages![index]
                                                      .id &&
                                              !isSelected)
                                            Align(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    bottom: 8,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          await directMessageService
                                                              .deleteMsg(
                                                                  _selectedMessageIndex!);
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        color: Colors.red,
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) => DirectMessageThreadWiget(
                                                                      receiverId:
                                                                          widget
                                                                              .userId,
                                                                      directMsgId:
                                                                          directMsgIds,
                                                                      receiverName:
                                                                          widget
                                                                              .receiverName)));
                                                        },
                                                        icon: const Icon(
                                                            Icons.reply),
                                                        color:
                                                            const Color.fromARGB(
                                                                255, 15, 15, 15),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: isStared
                                                              ? Colors.yellow
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () async {
                                                          if (isStared) {
                                                            await directMessageService
                                                                .directUnStarMsg(
                                                                    _selectedMessageIndex!);
                                                          } else {
                                                            await directMessageService
                                                                .directStarMsg(
                                                                    widget.userId,
                                                                    _selectedMessageIndex!);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 200),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.zero),
                                              color: Color.fromARGB(
                                                  110, 121, 120, 124),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    message,
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ),
                                                  Text(
                                                    myanmarTime,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 15, 15, 15),
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '$count',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 15, 15, 15),
                                                      ),
                                                      children: const [
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.0),
                                                            child:
                                                                Icon(Icons.reply),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 200),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft: Radius.zero),
                                              color: Color.fromARGB(
                                                  111, 113, 81, 228),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    message,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    myanmarTime,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '$count',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 15, 15, 15),
                                                      ),
                                                      children: const [
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.0),
                                                            child:
                                                                Icon(Icons.reply),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          if (_selectedMessageIndex ==
                                                  directMessages
                                                      .tDirectMessages![index]
                                                      .id &&
                                              !isSelected)
                                            Align(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    bottom: 8,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.star,
                                                          color: isStared
                                                              ? Colors.yellow
                                                              : Colors.grey,
                                                        ),
                                                        onPressed: () async {
                                                          if (isStared) {
                                                            await directMessageService
                                                                .directUnStarMsg(
                                                                    _selectedMessageIndex!);
                                                          } else {
                                                            await directMessageService
                                                                .directStarMsg(
                                                                    widget.userId,
                                                                    _selectedMessageIndex!);
                                                          }
                                                        },
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) => DirectMessageThreadWiget(
                                                                      receiverId:
                                                                          widget
                                                                              .userId,
                                                                      directMsgId:
                                                                          _selectedMessageIndex!,
                                                                      receiverName:
                                                                          widget
                                                                              .receiverName)));
                                                        },
                                                        icon: const Icon(
                                                            Icons.reply),
                                                        color:
                                                            const Color.fromARGB(
                                                                255, 15, 15, 15),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await directMessageService
                                                              .deleteMsg(
                                                                  _selectedMessageIndex!);
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                          // Spacer(),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageTextController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Type Messages",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.message),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState() {
                    isreading = !isreading;
                  }

                  sendMessage();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(right: 25),
                  child: const Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
