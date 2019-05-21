import 'package:flutter/material.dart';
import 'package:testeinicial/DbContext.dart';
import 'package:testeinicial/Models/Person.dart';
import 'package:testeinicial/PersonDataPage.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Person> ps = new List();
  DbContext db = DbContext.instance;
 
  @override
  void initState() {
    super.initState();
 
    db.getAllPersons().then((persons) {
      setState(() {
        for(final p in persons){
          ps.add(Person.fromMap(p));
        }
      });
    });
  }
 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Page'),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: ps.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${ps[position].name}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${ps[position].age}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.pinkAccent,
                            radius: 15.0,
                            child: Text(
                              '${ps[position].id}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _navigateToPerson(context, ps[position]),
                      onLongPress: () => _showDialog(ps[position]),
                    ),
                  ]
                );
              }),
            ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          child: Icon(Icons.add),
          onPressed: () => _createNewPerson(context),
        ),
      ),
    );
  }

  void _showDialog(Person person) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Atenção!"),
          content: new Text("Deseja excluir ${person.name}?"),
          actions: <Widget>[
            new FlatButton(
              color: Colors.pinkAccent,
              textColor: Colors.white,
              child: new Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: Colors.pinkAccent,
              textColor: Colors.white,
              child: new Text("Sim"),
              onPressed: () {
                _deletePerson(context, person);
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }
 
  void _deletePerson(BuildContext context, Person person) async {
    db.deletePerson(person.id);
    db.getAllPersons().then((persons) {
      setState(() {
        ps.clear();
        persons.forEach((person) {
          ps.add(Person.fromMap(person));
        });
      });
    });
  }
 
  void _createNewPerson(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonDataPage(Person()))
    );
 
    db.getAllPersons().then((persons) {
      setState(() {
        ps.clear();
        persons.forEach((person) {
          ps.add(Person.fromMap(person));
        });
      });
    });
  }

  void _navigateToPerson(BuildContext context, Person person) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonDataPage(person)),
    );
 
    db.getAllPersons().then((persons) {
      setState(() {
        ps.clear();
        persons.forEach((person) {
          ps.add(Person.fromMap(person));
        });
      });
    });
  }
 
}