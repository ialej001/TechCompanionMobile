import 'package:tech_companion_mobile/models/WorkOrder.dart';

class QueryMutation {
  String submitWorkOrder(WorkOrder workOrder) {
    return """
      mutation {
        completeWorkOrder(workOrder: "$workOrder") {
        }
      }
      """;
  }

  String getIncomplete = '''
    query getWorkOrders {
      getIncompleteWorkOrders(isCompleted: false) {
        customer {
          propertyType
          propertyName
          contactName
          contactPhone
          gateLocations
          serviceAddress
          gateLocations
          accessCodes
        }
        issues {
          location
          problem
        }
        isCompleted
      }
    }
    ''';

  String getParts = """
    query fetchParts {
      parts {
        partNumber
        description
        price
        }
      }
    """;
}
