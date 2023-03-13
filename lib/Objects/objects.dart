class CheckList {
  late String _name;
  late String _desc;
  late bool _checked;

  CheckList (String name, String desc, bool checked) {
    this._name = name;
    this._desc = desc;
    this._checked = checked;
  }

  String get name => _name;
  String get desc => _desc;
  bool get checked => _checked;

  set name (String value) {
    _name = value;
  }

  set desc (String value) {
    _desc = value;
  }

  set checked (bool value) {
    _checked = value;
  }



}