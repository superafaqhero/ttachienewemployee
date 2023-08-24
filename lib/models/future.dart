class Fut {

  int? _id;
  String? _title;
  String? _description;
  String? _totalprice;
  String? _deposit;
  String? _balance;
  String? _collectthisweek;
  int? position;
  String? _date;
  int? _priority;
  String? _email;
  String? _number;
  String? _address;

  Fut(this._title, this._date,this.position, this._totalprice,this._deposit,this._balance,this._collectthisweek, this._priority,[this._description, this._email, this._number, this._address]);

  Fut.withId(this._id, this._title, this._date, this.position, this._totalprice,this._deposit,this._balance,this._collectthisweek, this._priority,[this._description, this._email, this._number, this._address]);

  int? get id => _id;

  String? get title => _title;

  String? get description => _description;
  String? get totalprice => _totalprice;
  String? get deposit => _deposit;
  String? get balance => _balance;
  String? get  collectthisweek => _collectthisweek;
  int? get priority => _priority;

  String? get date => _date;
  int? get positiona => position;

  String? get email => _email;

  String? get number => _number;

  String? get address => _address;



  set title(newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }
  set totalprice(newtotalprice) {

    this._totalprice = newtotalprice;

  }
  set deposit(newdeposit) {

    this._deposit = newdeposit;

  }

  set balance(newbalance) {

    this._balance = newbalance;

  }
  set collectthisweek(newcollectthisweek) {

    this._collectthisweek = newcollectthisweek;

  }

  set priority(newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(newDate) {
    this._date = newDate;
  }
  set positiona(po) {
    this.position = po;
  }
  set email(newEmail) {
    if (newEmail.length <= 255) {
      this._email = newEmail;
    }
  }

  set number(newNumber) {
    this._number = newNumber;
  }

  set address(newAddress) {
    if (newAddress.length <= 255) {
      this._address = newAddress;
    }
  }
  // Convert a Fut object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['totalprice'] = _totalprice;
    map['deposit'] = _deposit;
    map['balance'] = _balance;
    map['collectthisweek'] = _collectthisweek;
    map['priority'] = _priority;
    map['position'] = position;
    map['date'] = _date;
    map['email'] = _email;
    map['number'] = _number;
    map['address'] = _address;

    return map;
  }

  // Extract a Fut object from a Map object
  Fut.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._totalprice = map['totalprice'];
    this._deposit = map['deposit'];
    this._balance = map['balance'];
    this._collectthisweek = map['collectthisweek'];
    this._priority = map['priority'];
    this.positiona = map['position'];
    this._date = map['date'];
    this._email = map['email'];
    this._number = map['number'];
    this._address = map['address'];
  }
}

