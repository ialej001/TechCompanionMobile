class QueryMutation {
  String submitWorkOrder = """
    mutation(
      \$stringId: String!,
      \$issues: [Issue],
      \$partsUsed: [Part],
      \$timeStarted: String,
      \$timeEnded: String)
     {
      completeWorkOrder(
        string_id: \$stringId,
        issues: \$issues,
        partsUsed: \$partsUsed,
        timeStarted: \$timeStarted,
        timeEnded: \$timeEnded
      ) {
        isCompleted
        string_id
        issues
        partsUsed
        timeStarted
        timeEnded
      }
    }""";
          
  // String submitWorkOrder(
  //   String stringId,
  //   String issues,
  //   // String partsUsed,
  //   String timeStarted,
  //   String timeEnded,
  //   ) {
  //   return ("""
  //     mutation CompleteWorkOrder {
  //       completeWorkOrder(
  //         string_id: "$stringId",
  //         issues: $issues,
  //         timeStarted: "$timeStarted",
  //         timeEnded: "$timeEnded"
  //         ) {
  //           string_id
  //           issues
  //           partsUsed
  //           timeStarted
  //           timeEnded
  //       }
  //     }
  //     """);
  // }

  String getIncomplete = '''
    query getWorkOrders {
      getIncompleteWorkOrders(isCompleted: false) {
        string_id
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
          resolution
        }
        partsUsed {
          description
          quantity
          price
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
