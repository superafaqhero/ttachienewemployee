class Note {
  int colId;
  String colTitle;
  String colDescription;
  String colemail;
  String colnumber;
  String coladdress;
  double colTotalprice;
  double colDeposit;
  double colBalance;
  double colCollectthisweek;
  int colPriority;
  int colposition;
  String colDate;

  Note({
    required this.colId,
    required this.colTitle,
    required this.colDescription,
    required this.colemail,
    required this.colnumber,
    required this.coladdress,
    required this.colTotalprice,
    required this.colDeposit,
    required this.colBalance,
    required this.colCollectthisweek,
    required this.colPriority,
    required this.colposition,
    required this.colDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      colId: json['colId'],
      colTitle: json['colTitle'],
      colDescription: json['colDescription'],
      colemail: json['colemail'],
      colnumber: json['colnumber'],
      coladdress: json['coladdress'],
      colTotalprice: double.parse(json['colTotalprice']),
      colDeposit: double.parse(json['colDeposit']),
      colBalance: double.parse(json['colBalance']),
      colCollectthisweek: double.parse(json['colCollectthisweek']),
      colPriority: json['colPriority'],
      colposition: json['colposition'],
      colDate: json['colDate'],
    );
  }
}
