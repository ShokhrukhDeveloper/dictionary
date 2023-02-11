import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dictionary/Entities/Word.dart';
import 'package:dictionary/Presentation/Drawer/Drawer.dart';
import 'package:dictionary/Presentation/WordDecriptionScreen/WordDescriptionScreen.dart';
import 'package:dictionary/Repository/Repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> init() async {
    words = await Repository.getInitial();
    setState(() {});
  }

  TextEditingController? controller;
  String searchText = "";
  Timer timer = Timer(const Duration(seconds: 0), () {});
  int delay = 5;
  ScrollController? scrollController;
  int currentPage = 1;
  var last = false;
  late FocusNode focus;
  @override
  void initState() {
    init();
    super.initState();
    focus = FocusNode();
    controller = TextEditingController();
    controller?.addListener(() {
      if (!timer.isActive) {
        delay = 1;
        timer = Timer.periodic(
            const Duration(
              milliseconds: 500,
            ), (e) async {
          if (delay <= 0) {
            if (controller!.text.isEmpty) {
              words = await Repository.getInitial();
              print(words);
              print("initial");
            } else {
              words = await Repository.getResult(controller!.text);
              print(words);
              print("search");
            }
            upadate(upadate.value++);
            // setState(() {
            // });
            print(delay);
            e.cancel();
          }

          currentPage = 1;
          last = false;
          print(delay);
          delay--;
        });
      }
      delay = 1;
    });
    scrollController = ScrollController();
    scrollController?.addListener(() async {
      if (!last &&
          scrollController!.offset ==
              scrollController!.position.maxScrollExtent) {
        currentPage++;
        var result = controller!.text.isNotEmpty
            ? await Repository.getResult(controller!.text, page: currentPage)
            : await Repository.getInitial(page: currentPage);
        if (result.isNotEmpty) {
          words.addAll(result);
          upadate(upadate.value++);
        } else {
          last = true;
        }
        print("search");
      }
    });
  }

  var upadate = 0.obs;
  List<Word> words = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Container(
              height: 55,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Colors.white10, Colors.black12],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            focusNode: focus,
                            controller: controller,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            // size: 20,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            focus.requestFocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // leading: IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: (){}
          // ),
          title: const Text("Dictionary off line"),
          actions: [
            IconButton(onPressed: () async {}, icon: const Icon(Icons.share))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: Obx(() => !upadate.isNegative
                ? words.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            CupertinoIcons.ant_fill,
                            size: 56,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Not found")
                        ],
                      ))
                    : Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: words.length,
                                  itemBuilder: (_, i) => Card(
                                        child: ListTile(
                                          trailing: Text(words[i].wordType),
                                          title: Text(words[i].word),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        WordDescriptonScreen(
                                                            args: words[i]
                                                                .word)));
                                          },
                                        ),
                                      ))),
                        ],
                      )
                : SizedBox())));
  }
}
