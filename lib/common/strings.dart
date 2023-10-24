const Map<String, String> _strings = {'CREATE_STORY': 'Create story'};

getString(String string) {
  return _strings.containsKey(string) ? _strings[string] : string;
}
