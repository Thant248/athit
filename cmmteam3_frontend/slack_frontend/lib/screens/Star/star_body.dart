import 'package:flutter/material.dart';
import 'package:flutter_frontend/componnets/Nav.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/model/MentionLists.dart';
import 'package:flutter_frontend/model/StarLists.dart';
import 'package:flutter_frontend/screens/Star/starsWidget/direct_star.dart';
import 'package:flutter_frontend/screens/Star/starsWidget/direct_thread_star.dart';
import 'package:flutter_frontend/screens/Star/starsWidget/group_star.dart';
import 'package:flutter_frontend/screens/Star/starsWidget/group_thread_star.dart';
import 'package:flutter_frontend/screens/home/workspacehome.dart';

class StarBody extends StatefulWidget {
  const StarBody({Key? key}) : super(key: key);

  @override
  State<StarBody> createState() => _StarBodyState();
}

class _StarBodyState extends State<StarBody> {
  int? isSelected = 1;
  static List<Widget> pages = [
    const DirectStars(),
    const DirectThreadStars(),
    const GroupStarWidget(),
    const GroupThreadStar()
  ];
  @override
  void dispose() {
    // Dispose any resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stars Groups"),
        backgroundColor: kPriamrybackground, // Corrected typo here
        automaticallyImplyLeading: false,
        actions: const [Icon(Icons.star)],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      isSelected = 1;
                    });
                  },style: ButtonStyle(
                        backgroundColor: isSelected ==1?
                        MaterialStateProperty.all<Color>(navColor):
                        MaterialStateProperty.all<Color>(kPrimarybtnColor),
                        minimumSize: MaterialStateProperty.all(const Size(120, 50))
                      ),
                  child: const  Padding(
                        padding:  EdgeInsets.all(15.0),
                        child:  Text("Direct Star"),
                      )
                ),
                const SizedBox(
                  width: 20.0,
                ),
                FilledButton(
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
                        child:  Text("Direct Thread Star"),
                      )
                ),
                const SizedBox(
                  width: 20.0,
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      isSelected = 3;
                    });
                  },
                  style: ButtonStyle(
                        backgroundColor: isSelected ==3?
                        MaterialStateProperty.all<Color>(navColor):
                        MaterialStateProperty.all<Color>(kPrimarybtnColor),
                        minimumSize: MaterialStateProperty.all(const Size(120, 50))
                      ),
                  child: const  Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text("Group Star"),
                      )
                ),
                const SizedBox(
                  width: 20.0,
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      isSelected = 4;
                    });
                  },style: ButtonStyle(
                        backgroundColor: isSelected ==4?
                        MaterialStateProperty.all<Color>(navColor):
                        MaterialStateProperty.all<Color>(kPrimarybtnColor),
                        minimumSize: MaterialStateProperty.all(const Size(120, 50))
                      ),
                  child: const  Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text("Group Thread Star"),
                      )
                ),
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
