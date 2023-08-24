class Expense {

  int? _id;
  String? _title;
  String? _totalprice;
  int? position;
  String? _date;
  int? _priority;
  String? _expensename;



  Expense(this._title, this._date,this.position, this._totalprice, this._priority, this._expensename);

  Expense.withId(this._id, this._title, this._date,this.position, this._totalprice, this._priority, this._expensename);

  int? get id => _id;
  String? get title => _title;
  String? get totalprice => _totalprice;
  int? get priority => _priority;
  String? get date => _date;
  String? get expensename => _expensename;
  int? get positiona => position;

  set title(newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set totalprice(newtotalprice) {

    this._totalprice = newtotalprice;

  }

  set priority(newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }


  set date(newDate) {
    this._date = newDate;
  }

  set expensename(newExpenseName) {
    this._expensename = newExpenseName;
  }
  set positiona(po) {
    this.position = po;
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['totalprice'] = _totalprice;
    map['priority'] = _priority;
    map['position'] = position;
    map['edate'] = _date;
    map['etype'] = _expensename;

    return map;
  }

  // Extract a Note object from a Map object
  Expense.fromMapObject(Map<String, dynamic> map) {
    this._id = int.parse(map['id'].toString());
    this._title = map['title'];
    this._totalprice = map['totalprice'];
    this._priority = int.parse(map['priority'].toString());
    this.positiona = int.parse(map['position'].toString());
    this._date = map['edate'];
    this._expensename = map['etype'];
  }
}

