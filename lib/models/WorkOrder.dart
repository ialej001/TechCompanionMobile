// model class for received data. also functions as the model for inputted data collection

import 'package:flutter/material.dart';

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
  TimeOfDay timeStarted;
  TimeOfDay timeEnded;
  List<Part> partsUsed;
  List<String> workPerformed;
  
  WorkOrder({
    this.stringId,
    this.customer,
    this.issues,
    this.isComplete,
    this.timeStarted,
    this.timeEnded,
    this.partsUsed,
    this.workPerformed
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return new WorkOrder(
      stringId: json['string_id'],
      customer: Customer.fromJson(json['customer']),
      issues: Issues.fromJson(json['issues']),
      isComplete: json['isComplete'],
      workPerformed: List<String>(),
      partsUsed: List<Part>()
    );
  }

  List<Issue> getIssues() {
    return this.issues.issues;
  }
}

class Customer {
  final String propertyName;
  final String serviceAddress;
  final String propertyType;
  final String contactName;
  final String contactPhone;

  Customer({
    this.propertyName,
    this.serviceAddress,
    this.propertyType,
    this.contactName,
    this.contactPhone
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return new Customer(
      propertyName: json['propertyName'],
      propertyType: json['propertyType'],
      serviceAddress: json['serviceAddress'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone']
    );
  }
}

class Issues {
  List<Issue> issues;

  Issues({
    this.issues
  });

  factory Issues.fromJson(List<dynamic> json) {
    List<Issue> issues = new List<Issue>();
    issues = json.map((i) => Issue.fromJson(i)).toList();

    return new Issues(issues: issues);
  }

  int length() {
    return this.issues.length;
  }
}

class Issue {
  final String location;
  final String problem;
  String resolution;

  Issue({
    this.location,
    this.problem,
    this.resolution
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return new Issue(
      location: json['location'], 
      problem: json['problem'],
      resolution: ""
    );
  }
}

class WorkDoneForIssue {
  List<Part> partsUsed;
  List<String> workPerformed;
  int index;

  WorkDoneForIssue(this.partsUsed, this.workPerformed, this.index);
}