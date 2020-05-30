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
  double subTotal;
  double total;
  double labor;
  double tax;

  WorkOrder({
    this.stringId,
    this.customer,
    this.issues,
    this.isComplete,
    this.timeStarted,
    this.timeEnded,
    this.partsUsed,
    this.subTotal,
    this.tax,
    this.total,
    this.labor,
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
      subTotal: json['subTotal'] == null ? 0 : json['subTotal'],
      labor: json['labor'] == null ? 0 : json['labor'],
      tax: json['tax'] == null ? 0 : json['tax'],
      total: json['total'] == null ? 0 : json['total'],
    );
  }

  List<Issue> getIssues() {
    return this.issues.issues;
  }
}

class Customer {
  final String stringId;
  final String propertyName;
  final String streetAddress;
  final String serviceAddress;
  final String propertyType;
  final String contactName;
  final String contactPhone;
  final String billingMethod;
  final double laborRate;
  final double taxRate;
  final List<GateDetails> gateDetails;

  Customer(
      {this.stringId,
      this.propertyName,
      this.streetAddress,
      this.serviceAddress,
      this.propertyType,
      this.contactName,
      this.contactPhone,
      this.billingMethod,
      this.laborRate,
      this.taxRate,
      this.gateDetails});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return new Customer(
        stringId: json['string_id'],
        propertyName: json['propertyName'],
        propertyType: json['propertyType'],
        streetAddress: json['streetAddress'],
        serviceAddress: json['serviceAddress'],
        contactName: json['contactName'],
        contactPhone: json['contactPhone'],
        billingMethod: json['billingMethod'],
        laborRate: (json['laborRate']),
        taxRate: (json['taxRate']),
        gateDetails:
            GateDetails.createGateDetailsFromJson(json['gateDetails']));
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

  // String writeJson() {
  //   return '{location: "$location", problem: "$problem", resolution: "$resolution"}';
  // }
}

class GateDetails {
  final String location;
  String accessCodes;
  String operator1;
  String operator2;
  String gateType1;
  String gateType2;
  bool isMasterSlave;
  final String safetyChecklistID;

  GateDetails(
      {this.location,
      this.accessCodes,
      this.operator1,
      this.operator2,
      this.gateType1,
      this.gateType2,
      this.isMasterSlave,
      this.safetyChecklistID});

  factory GateDetails.fromJson(Map<String, dynamic> json) {
    return new GateDetails(
      location: json['location'],
      accessCodes: json['accessCodes'],
      operator1: json['operator1'],
      operator2: json['operator2'],
      gateType1: json['gateType1'],
      gateType2: json['gateType2'],
      isMasterSlave: json['isMasterSlave'],
      safetyChecklistID: json['safetyChecklistID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'location': this.location,
        'accessCodes': this.accessCodes,
        'operator1': this.operator1,
        'operator2': this.operator2,
        'gateType1': this.gateType1,
        'gateType2': this.gateType2,
        'isMasterSlave': this.isMasterSlave,
        'safetyChecklistID': this.safetyChecklistID,
      };

  static List<GateDetails> createGateDetailsFromJson(List<dynamic> json) {
    List<GateDetails> gateDetails = new List<GateDetails>();
    gateDetails = json.map((i) => GateDetails.fromJson(i)).toList();
    return gateDetails;
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
