import 'package:flutter/material.dart';
import 'package:flutter_frontend/componnets/Nav.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/screens/Mention/MentionWidget/group_mention.dart';
import 'package:flutter_frontend/screens/Mention/MentionWidget/group_thread_mention.dart';

class MentionBody extends StatefulWidget {
  const MentionBody({Key? key}) : super(key: key);

  @override
  State<MentionBody> createState() => _MentionBodyState();
}

class _MentionBodyState extends State<MentionBody> {
  int? isSelected = 1;
  static List<Widget> pages = [
    const GroupMessages(),
    const GroupThreads(),
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
      appBar: AppBar(
        title: const Text("Mention Groups"),
        backgroundColor: kPriamrybackground,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isSelected = 1;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: isSelected ==1?
                        MaterialStateProperty.all<Color>(navColor):
                        MaterialStateProperty.all<Color>(kPrimarybtnColor),
                        minimumSize: MaterialStateProperty.all(const Size(120, 50))
                      ),
                      child: const  Padding(
                        padding:  EdgeInsets.all(15.0),
                        child:  Text("Group Message"),
                      )
                      ),
                ),
                const SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isSelected = 2;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: isSelected ==2?
                        MaterialStateProperty.all<Color>(navColor):
                        MaterialStateProperty.all<Color>(kPrimarybtnColor),
                        minimumSize: MaterialStateProperty.all(const Size(120, 50))
                      ),
                      child: const  Padding(
                        padding:  EdgeInsets.all(15.0),
                        child:  Text("Group Thread"),
                      )),
                )
              ],
            ),
          ),
          if (isSelected != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: pages[isSelected! - 1],
              ),
            )
        ],
      ),
    );
  }
}
