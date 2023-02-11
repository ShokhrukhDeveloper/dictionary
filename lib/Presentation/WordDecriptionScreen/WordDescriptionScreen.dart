import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:dictionary/Entities/Word.dart';
import 'package:dictionary/Repository/Repository.dart';

class WordDescriptonScreen extends StatefulWidget {
  final String args;
  const WordDescriptonScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<WordDescriptonScreen> createState() => _WordDescriptonScreenState();
}

class _WordDescriptonScreenState extends State<WordDescriptonScreen> {
  Future<void> getWordMeans() async {
    words = await Repository.getWordMeans(text: widget.args);
    setState(() {});
  }

  Future<void> translate() async {
    for (int i = 0; i < words.length; i++) {
      if(wordsUz[i]!=null)return;
      var res = await tr.translate(words[i].definition!, from: "en", to: 'uz');
      wordsUz[i] = res.text;
      setState(() {});

    }

  }

  bool uzbek = false;
  static var tr = GoogleTranslator();
  List<Word> words = [];
  List<String?> wordsUz = List.generate(40, (index) => null);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWordMeans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  translate();
                  uzbek = !uzbek;
                },
                child: Icon(
                  Icons.translate,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                  label: Text(
                widget.args,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              )),
              Expanded(
                child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (_, i) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                                label: Text(
                              "${words[i].word} ",
                              style: const TextStyle(color: Colors.pink),
                            )),
                            Text(
                              "(${words[i].wordType})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              " ${uzbek ? (wordsUz[i] ?? words[i].definition) : words[i].definition}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const Divider()
                          ],
                        )),
              )
            ],
          ),
        )

        //Center(child: Text(widget.args),)
        );
  }
}
