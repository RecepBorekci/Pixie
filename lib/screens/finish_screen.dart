import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'welcome_screen.dart';
import '../models/share_buttons.dart';

class FinishScreen extends StatefulWidget {
  const FinishScreen(this.finishedImage);
  final Image finishedImage;

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  bool showContent = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: showContent
            ? SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: new Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: Navigator.of(context).pop),
                          MaterialButton(
                            onPressed: () {},
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: widget.finishedImage,
                                ),
                                InkWell(
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        color: Colors.white,
                                        Icons.search_rounded,
                                        size: 80,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showContent = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: IconButton(
                              icon: new Icon(
                                Icons.home,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return WelcomeScreen();
                                }));
                              },
                            ),
                          ),
                          //  Navigator.of(context).popUntil((route) => route.isFirst);
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Share!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Proxima Nova"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: 6,
                            padding: EdgeInsets.all(10),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        list[index].url,
                                        scale: 0.01),
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: widget.finishedImage,
                ),
                onTap: () {
                  setState(() {
                    showContent = true;
                  });
                },
              ));
  }
}
