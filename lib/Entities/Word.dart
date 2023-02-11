class Word {
  Word({required this.word, required this.wordType, required this.definition});
  factory Word.json(Map<String, dynamic> json) => Word(
      word: json["word"],
      wordType: json["wordtype"],
      definition: json["definition"]);
  String word;
  String wordType;
  String? definition;
}
