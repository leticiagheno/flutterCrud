class Person {
  int id;
  String name;
  int age;

  Person();

  Person.fromMap(Map<String, dynamic> map) {
    this.id = map['Id'];
    this.name = map['Name'];
    this.age = map['Age'];
  }

   Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['Id'] = id;
    }
    map['Name'] = name;
    map['Age'] = age;
 
    return map;
  }
}