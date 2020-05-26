// model class for received data. also functions as the model for inputted data collection

import 'Part.dart';

class WorkOrders {
  final List<WorkOrder> workOrders;

  WorkOrders({
    this.workOrders,
  });

  factory WorkOrders.fromJson(List<dynamic> parsedJson) {
    List<WorkOrder> workOrders = new List<WorkOrder>();
    workOrders = parsedJson.map((i) => WorkOrder.fromJson(i)).toList();

    return new WorkOrders(workOrders: workOrders);
  }

  int length() {
    return this.workOrders.length;
  }
}

class WorkOrder {
  final stringId;
  final Customer customer;
  Issues issues;
  final bool isComplete;
  DateTime timeStarted;
  DateTime timeEnded;
  List<Part> partsUsed;

  WorkOrder({
    this.stringId,
    this.customer,
    this.issues,
    this.isComplete,
    this.timeStarted,
    this.timeEnded,
    this.partsUsed,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return new WorkOrder(
      stringId: json['stringId'],
      customer: Customer.fromJson(json['customer']),
      issues: Issues.fromJson(json['issues']),
      isComplete: json['isComplete'],
      partsUsed: makePartsUsed(json['partsUsed']),
      timeStarted: json['timeStarted'] == null
          ? null
          : DateTime.parse(json['timeStarted']),
      timeEnded:
          json['timeEnded'] == null ? null : DateTime.parse(json['timeEnded']),
    );
  }

  List<Issue> getIssues() {
    return this.issues.issues;
  }
}

class Customer {
  final String stringId;
  final String propertyName;
  final String serviceAddress;
  final String propertyType;
  final String contactName;
  final String contactPhone;
  final String billingMethod;
  final double laborRate;
  final double taxRate;

  Customer(
      {this.stringId,
      this.propertyName,
      this.serviceAddress,
      this.propertyType,
      this.contactName,
      this.contactPhone,
      this.billingMethod,
      this.laborRate,
      this.taxRate});

  factory Customer.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return new Customer(
        stringId: json['string_id'],
        propertyName: json['propertyName'],
        propertyType: json['propertyType'],
        serviceAddress: json['serviceAddress'],
        contactName: json['contactName'],
        contactPhone: json['contactPhone'],
        billingMethod: json['billingMethod'],
        laborRate: (json['laborRate']),
        taxRate: (json['taxRate']));
  }

    Map<String, dynamic> toJson() => {
      'string_id': this.stringId,
      'propertyName': this.propertyName,
      'serviceAddress': this.serviceAddress,
      'propertyType': this.propertyType,
      'contactName': this.contactName,
      'contactPhone': this.contactPhone,
      'billingMethod': this.billingMethod,
      'laborRate': this.laborRate,
      'taxRate': this.taxRate
      };
}

class Issues {
  List<Issue> issues;

  Issues({this.issues});

  factory Issues.fromJson(List<dynamic> json) {
    List<Issue> issues = new List<Issue>();
    issues = json.map((i) => Issue.fromJson(i)).toList();

    return new Issues(issues: issues);
  }

  int length() {
    return this.issues.length;
  }

  Map<String, dynamic> toJson() => {'issues': issues};
}

class Issue {
  final String location;
  final String problem;
  String resolution;

  Issue({this.location, this.problem, this.resolution});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return new Issue(
        location: json['location'],
        problem: json['problem'],
        resolution: json['resolution'] == null ? "" : json['resolution']);
  }

  Map<String, dynamic> toJson() => {
        'location': this.location,
        'problem': this.problem,
        'resolution': this.resolution
      };

  String writeJson() {
    return '{location: "$location", problem: "$problem", resolution: "$resolution"}';
  }
}

class WorkDoneForIssue {
  List<Part> partsUsed;
  List<String> workPerformed;
  int index;

  WorkDoneForIssue(this.partsUsed, this.workPerformed, this.index);
}

List<Part> makePartsUsed(json) {
  if (json == null) {
    return new List<Part>();
  }

  List<Part> partsUsed = new List<Part>();
  for (int i = 0; i < json.length; i++) {
    partsUsed.add(Part.fromJson(json[i]));
  }

  return partsUsed;
}
