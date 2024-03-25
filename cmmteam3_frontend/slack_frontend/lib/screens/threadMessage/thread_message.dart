import 'package:flutter/material.dart';
import 'package:flutter_frontend/componnets/Nav.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/screens/threadMessage/threadWidget/GroupThread.dart';
import 'package:flutter_frontend/screens/threadMessage/threadWidget/directThread.dart';

class ThreadList extends StatefulWidget {
  const ThreadList({Key? key}) : super(key: key);

  @override
  State<ThreadList> createState() => _ThreadListState();
}

class _ThreadListState extends State<ThreadList> {
  int? selectedIndex = 1;
  static List<Widget> pages = [
    const directThread(),
    const groupThread(),
  ];
  @override
  void dispose() {
    // Dispose any resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPriamrybackground,
      appBar: AppBar(
        title: const Text(
          "Thread List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: navColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: selectedIndex == 1
                              ? MaterialStateProperty.all<Color>(navColor)
                              : MaterialStateProperty.all<Color>(
                                  kPrimarybtnColor),
                          minimumSize:
                              MaterialStateProperty.all(const Size(120, 50))),
                      child: const Padding(
                        padding:  EdgeInsets.all(15.0),
                        child:  Text(
                          "Direct Threads",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: selectedIndex == 2
                            ? MaterialStateProperty.all<Color>(navColor)
                            : MaterialStateProperty.all<Color>(
                                kPrimarybtnColor),
                      ),
                      child: const  Padding(
                        padding:  EdgeInsets.all(15.0),
                        child:  Text(
                          "Group Threads",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedIndex != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: pages[selectedIndex! - 1],
              ),
            )
        ],
      ),
    );
  }
}
