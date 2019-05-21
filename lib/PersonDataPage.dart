import 'package:flutter/material.dart';
import 'package:testeinicial/DbContext.dart';
import 'package:testeinicial/Models/Person.dart';
 
class PersonDataPage extends StatefulWidget {
  final Person person;
  PersonDataPage(this.person);
 
  @override
  State<StatefulWidget> createState() => new _PersonDataPageState();
}
 
class _PersonDataPageState extends State<PersonDataPage> {
  DbContext db = DbContext.instance;
 
  TextEditingController _nameController;
  TextEditingController _ageController;
 
  @override
  void initState() {
    super.initState();
 
    _nameController = new TextEditingController(text: widget.person.name);
    _ageController = new TextEditingController(text: widget.person.age == null ? '' : widget.person.age.toString());
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(widget.person.name != null ? widget.person.name : "Nova pessoa")),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              cursorColor: Colors.pink,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder( 
                  borderSide: BorderSide(color: Colors.pink)) ,
                labelStyle: TextStyle(color: Colors.pink),
                labelText: 'Nome'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _ageController,  
              cursorColor: Colors.pink,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder( 
                  borderSide: BorderSide(color: Colors.pink)) ,
                labelStyle: TextStyle(color: Colors.pink),
                labelText: 'Idade'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              color: Colors.pinkAccent,
              textColor: Colors.white,
              child: (widget.person.id != null) ? Text(
                'Atualizar') : Text('Salvar'),
              onPressed: () {
                if (widget.person.id != null) {
                  db.updatePerson(Person.fromMap({
                    'Id': widget.person.id,
                    'Name': _nameController.text,
                    'Age': int.parse(_ageController.text)
                  })).then((_) {
                    Navigator.pop(context, 'Update');
                  });
                }else {
                  var person = new Person();
                  person.age = int.parse(_ageController.text);
                  person.name = _nameController.text;
                  db.savePerson(person).then((_) {
                    Navigator.pop(context, 'Add');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}