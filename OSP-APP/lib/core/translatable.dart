class Translatable {
  final String pl;
  final String en;

  const Translatable({required this.pl, required this.en});

  Map<String, dynamic> toJSON() {
    return { "pl": pl, "en": en };
  }

  factory Translatable.fromJSON(Map<String, dynamic> data) {
    return Translatable(pl: data['pl'] ?? '', en: data['en'] ?? '');
  }

  String translate(String locale) {
    switch (locale) {
      case 'pl':
        return pl;
      default:
        return en;
    }
  }

}