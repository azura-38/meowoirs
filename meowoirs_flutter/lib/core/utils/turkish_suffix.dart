/// Produces grammatically correct Turkish title suffixes:
/// e.g. "Minnoş'un Hikâyesi", "Tekir'in Hikâyesi", "Maya'nın Hikâyesi"
String getCatStoryTitle(String catName) {
  if (catName.trim().isEmpty) return 'Kedinin Hikâyesi';
  final trimmed = catName.trim();
  const vowels = 'aeıioöuüAEIİOÖUÜ';

  // Find last vowel
  String? lastVowel;
  for (int i = trimmed.length - 1; i >= 0; i--) {
    final char = trimmed[i];
    if (vowels.contains(char)) {
      lastVowel = char.toLowerCase();
      break;
    }
  }
  lastVowel ??= 'i';

  final lastChar = trimmed[trimmed.length - 1].toLowerCase();
  final endsWithVowel = vowels.contains(lastChar);

  final String suffix;
  switch (lastVowel) {
    case 'a':
    case 'ı':
      suffix = endsWithVowel ? "'nın" : "'ın";
      break;
    case 'e':
    case 'i':
      suffix = endsWithVowel ? "'nin" : "'in";
      break;
    case 'o':
    case 'u':
      suffix = endsWithVowel ? "'nun" : "'un";
      break;
    case 'ö':
    case 'ü':
      suffix = endsWithVowel ? "'nün" : "'ün";
      break;
    default:
      suffix = "'in";
  }

  return '$trimmed$suffix Hikâyesi';
}
