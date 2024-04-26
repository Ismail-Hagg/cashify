class Catagory {
  String name;
  List<String> subCatagories;
  String icon;
  Catagory({
    required this.name,
    required this.subCatagories,
    required this.icon,
  });

  toMap() {
    return <String, dynamic>{
      'name': name,
      'subCatagories': subCatagories,
      'icon': icon,
    };
  }

  factory Catagory.fromMap(Map<String, dynamic> map) {
    return Catagory(
        name: map['name'],
        subCatagories: map['subCatagories'],
        icon: map['icon']);
  }
}
