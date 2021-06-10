import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_event/screens/note_detail.dart';
import 'package:new_event/models/note.dart';

//import 'package:new_event/task_with_calendar/database_helper.dart';
import 'package:new_event/utils/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

class EventList extends StatefulWidget {
  Note note;

  //_callMethod(BuildContext context) => createState()._delete(context, note);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Color _themeColor = Color(0xff30384c);
  CalendarController calController;
  TextEditingController tfTitleController = TextEditingController();
  TextEditingController tfDecController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  List taskList = List();
  final dateFormat = new DateFormat("d EEE, MMM ''yyyy");
  DateTime _selectedDate = DateTime.now();

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  //Background for edit task (when user swipe start to end)
  getEditBg() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.edit,
        color: _themeColor,
        size: 25,
      ),
    );
  }

  //Background for delete task (when user swipe end to start)
  getDeleteBg() {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.only(right: 10),
      child: Icon(
        Icons.delete,
        color: _themeColor,
        size: 25,
      ),
    );
  }

  //Returning date
  getDiff() {
    var now = DateTime.now();
    if (dateFormat.format(_selectedDate) == dateFormat.format(now))
      return "Today";
    return dateFormat.format(_selectedDate).toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    calController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      // backgroundColor: Colors.blueGrey,

      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            //padding: EdgeInsets.symmetric(),
            decoration: BoxDecoration(
              color: Color(0xff29404E),
              //  color: Color(0xff181A4A)
            ),
          ),
          SingleChildScrollView(
            child: Container(
              //  height: MediaQuery.of(context).size.height,
              // padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),

              padding: EdgeInsets.only(
                top: 38,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Event",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          "App",
                          style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/notify.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          "assets/menu.png",
                          height: 25,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Hello!!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                        weekdayStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                        weekendStyle: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                        selectedColor: Colors.deepOrangeAccent,
                        todayColor: Colors.deepOrangeAccent,
                        todayStyle:
                            TextStyle(fontSize: 14, color: Colors.white)),
                    onDaySelected: (date, events, holiday) => {
                      setState(() {
                        _selectedDate = date;
                        taskList = List();
                        //getAllTasks();
                      }),
                    },
                    builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                              margin: EdgeInsets.all(5.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.bold),
                        weekdayStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        formatButtonTextStyle:
                            TextStyle(color: Colors.deepOrange),
                        centerHeaderTitle: true,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.deepOrange,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.deepOrange,
                        )),
                    calendarController: calController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // color: Color(0xFFfff7ed),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 25),
                          child: Row(
                            children: [
                              Text(
                                "All Events",
                                style:
                                    TextStyle(color: _themeColor, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // color: Colors.blue,
                          // height: MediaQuery.of(context).size.height - 100,
                          //height: 512,
                          child:
                              //notesListView()
                              //notesListView1(),
                              GestureDetector(child: notesListView2()),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  notesListView(),
        ],
      ),

      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: FloatingActionButton(
            backgroundColor: Colors.deepOrangeAccent,
            child: Icon(Icons.add),
            onPressed: () {
              debugPrint('Fab Clicked');
              navigateToDetail(Note('', '', 2, "", ""), 'Add Note');
            }),
      ),
    );
  }

  Widget notesListView2() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    return Container(
      //  height: 150,
      width: MediaQuery.of(context).size.width,
      //  color: Colors.green,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return Dismissible(
              key: Key(noteList[position].id.toString()),
              onDismissed: (DismissDirection direction) async {
                _delete(context, noteList[position]);
                noteList.removeAt(position);
              },
              direction: DismissDirection.endToStart,
              secondaryBackground: getDeleteBg(),
              background: Container(),
              //getEditBg(),
              child: GestureDetector(
                onTap: () {
                  debugPrint('ListTile Tapped');
                  navigateToDetail(this.noteList[position], 'Edit note');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  //  height: MediaQuery.of(context).size.height,
                  // height: 120,
                  //width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: Color(0xff29404E),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        //color: Colors.deepOrangeAccent,
                        // padding: EdgeInsets.only(left: 16),
                        // width: MediaQuery.of(context).size.width - 46,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              this.noteList[position].title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/calender.png",
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      this.noteList[position].date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/location.png",
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      this.noteList[position].address,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white70,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white70,
                                          child: Icon(
                                            Icons.delete_rounded,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.deepOrangeAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Do you want to delete?",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    _delete(context,
                                                        noteList[position]);
                                                    Navigator.of(context).pop();
                                                  },
                                                  color: Colors.white,
                                                  child: Text('Delete'),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            // _delete(context, noteList[position]);
                          }),

                      //),

                      // ClipRRect(
                      //   borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                      // child: Image.asset(imgeAssetPath, height: 100,width: 120, fit: BoxFit.cover,)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Returns the priority color

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.deepOrangeAccent;
        break;

      case 2:
        return Colors.lightGreenAccent;
        break;

      default:
        return Colors.lightGreenAccent;
    }
  }

  // Returns to priority icon

  Icon getIconPriority(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.arrow_right);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(
    BuildContext context,
    Note note,
  ) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Successully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(
    Note note,
    String title,
  ) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

class Delete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white70,
                  child: Icon(
                    Icons.delete_rounded,
                    size: 50,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.deepOrangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Do you want to delete?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        RaisedButton(
                          onPressed: () {
                            // _delete(context, noteList[position]);
                          },
                          color: Colors.white,
                          child: Text('Delete'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
