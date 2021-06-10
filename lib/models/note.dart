import 'package:flutter/cupertino.dart';

class Note {
  int _id;
  String _title;
  String _description;

  String _address;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description, this._address,]);

  Note.withId(
    this._id,
    this._title,
    this._date,
    this._priority, [
    this._description,
        this._address,
  ]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get address => _address;
  String get date => _date;

  int get priority => _priority;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }


  set address(String newAddress) {
    if (newAddress.length <= 255) {
      this._address = newAddress;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  // Convert a Note object into Map object

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map['title'] = _title;
    map["description"] = _description;
    map["address"] = _address;
    map["date"] = _date;
    map["priority"] = _priority;

    return map;
  }

  // Extract a Note object from a Map object

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._description = map["description"];
    this._address = map["address"];
    this._date = map["date"];
    this._priority = map["priority"];
  }
}
