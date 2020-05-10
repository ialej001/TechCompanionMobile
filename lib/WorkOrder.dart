// model class for received data. also functions as the model for inputted data collection

import 'package:flutter/material.dart';

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
  final Customer customer;
  final Issues issues;
  final bool isComplete;
  TimeOfDay timeStarted;
  TimeOfDay timeEnded;
  
  WorkOrder({
    this.customer,
    this.issues,
    this.isComplete,
    this.timeStarted,
    this.timeEnded
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return new WorkOrder(
      customer: Customer.fromJson(json['customer']),
      issues: Issues.fromJson(json['issues']),
      isComplete: json['isComplete']
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
  final List<Issue> issues;

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

  Issue getIssue(int index) {
    return this.issues[index];
  }
}

class Issue {
  final String location;
  final String problem;

  Issue({
    this.location,
    this.problem
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return new Issue(
      location: json['location'], 
      problem: json['problem']
    );
  }
}