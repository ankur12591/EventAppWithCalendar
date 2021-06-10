import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:new_event/models/note.dart';
import 'package:new_event/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  final appBarTitle;
  NoteDetail(this.note,this.appBarTitle );

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle );
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priorities = ["High", "Low"];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);

  DateTime _dateTime = DateTime.now();

  Future<void> _selectedEventDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        dateTimeController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    titleController.text = note.title;
    descriptionController.text = note.description;
    addressController.text = note.address;
    dateTimeController.text = note.date;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Control Things when user press Back button
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff102733),
          title: Row(
            children: <Widget>[
              Text(
                "Event",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "App",
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  debugPrint('saved');
                  _save();
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.save_rounded,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  debugPrint('Delete Button Clicked');
                  _delete();
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.delete_rounded,
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            Container(
              //color: Colors.blue,
              height: 450,
              decoration: BoxDecoration(
                  color: Color(0xfff2f6fa),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(50, 40),
                      bottomLeft: Radius.elliptical(50, 40))),
              padding: const EdgeInsets.all(10.0),
              child: noteDetailListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget noteDetailListView() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return ListView(
      children: <Widget>[
        // First Element
        ListTile(
          title: DropdownButton(
              items: _priorities
                  .map(
                    (String dropDownStringItems) => DropdownMenuItem<String>(
                      value: dropDownStringItems,
                      child: Text(dropDownStringItems),
                    ),
                  )
                  .toList(),
              value: getPriorityAsString(note.priority),
              onChanged: (value) {
                setState(() {
                  debugPrint('User selected $value ');
                  updatePriorityAsInt(value);
                });
              }),
        ),

        // Second Element
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: titleController,
            // onChanged: (value) {
            //   debugPrint('Title');
            //   // updateTitle();
            //   note.title = titleController.text;
            //   //  FocusScope.of(context).unfocus();
            // },
            decoration: InputDecoration(
              labelText: 'Event name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: dateTimeController,
            decoration: InputDecoration(
              // hintText: 'Pick a date',
              prefixIcon: InkWell(
                  onTap: () {
                    _selectedEventDate(context);
                    // _selectedEventDate(context);
                    // FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.calendar_today_rounded)),
              labelText: 'Date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),

        // Third Element
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: descriptionController,
            // onChanged: (value) {
            //   debugPrint('Description');
            //   // updateDescription();
            //   note.description = descriptionController.text;
            // },
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: addressController,
            // onChanged: (value) {
            //   debugPrint('Address');
            //   note.address = addressController.text;
            //   // updateAddress();
            //   //  FocusScope.of(context).unfocus();
            // },
            decoration: InputDecoration(
              hintText: 'Pick a location',
              prefixIcon:
                  InkWell(onTap: () {}, child: Icon(Icons.location_on_rounded)),
              labelText: 'Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),

        // Fourth Element

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  //color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    'Save',
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      debugPrint('saved');
                      _save();
                    });
                  },
                ),
              ),
              Container(
                width: 10.0,
              ),
              Expanded(
                child: RaisedButton(
                  //color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    'Delete',
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      debugPrint('Delete Button Clicked');
                      _delete();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to database

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert the Integer priority into String priority and Display it to user in DropDown

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the Title of Note Object

  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the Date of Note Object

  void updateDate() {
    note.date = dateTimeController.text;
  }

  // Update the Address of Note Object

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void updateAddress() {
    note.address = addressController.text;
  }

  // Save data to database

  void _save() async {
    moveToLastScreen();
    note.title = titleController.text;
    // note.date = dateTimeController.text;
    note.description = descriptionController.text;
    note.address = addressController.text;

    note.date = DateFormat.yMMMd().format(_dateTime);

    int result;
    if (note.id != null) {
      // Case 1: Update Operation
      result = await helper.updatetNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Stayus', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();
    // Case 1: If the User is trying to delete the NEW NOTE

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was Deleted');
      return;
    }

    // Case 2: If the User is trying to delete the OLD NOTE with id
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
