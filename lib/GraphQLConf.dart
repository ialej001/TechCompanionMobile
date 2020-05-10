import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(uri: 'http://10.0.2.2:9000/graphql');

  GraphQLConfiguration();

  ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: httpLink, cache: InMemoryCache()));

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }
}
