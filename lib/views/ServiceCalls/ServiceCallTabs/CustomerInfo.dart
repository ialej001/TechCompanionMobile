import 'package:flutter/material.dart';
import 'package:tech_companion_mobile/models/WorkOrder.dart';

class CustomerInfo extends StatefulWidget {
  CustomerInfo({Key key, this.customer}) : super(key: key);

  final Customer customer;
  @override
  State<StatefulWidget> createState() => _CustomerInfoView(this.customer);
}
class _CustomerInfoView extends State<CustomerInfo> {
  Customer customer;

  _CustomerInfoView(this.customer);

  Future<void> _openAccessCodes(int index) async {
    String inputtedText;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Codes:'),
          content: Container(
            child: TextFormField(
              initialValue: customer.gateDetails[index].accessCodes,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              maxLines: null,
              onChanged: (String textTyped) {
                setState(() {
                  inputtedText = textTyped;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  customer.gateDetails[index].accessCodes = inputtedText;
                });
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _buildCustomerInfo(context, customer),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 2, 25, 2),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Locations:',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          _buildAccessInfo(context, customer.gateDetails),
        ],
      ),
    );
  }

  Widget _buildAccessInfo(BuildContext context, List<GateDetails> gateDetails) {
    if (gateDetails.length != 0) {
      return Expanded(
        flex: 2,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: ListView.separated(
            itemCount: gateDetails.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(gateDetails[index].location),
                // trailing: IconButton(
                //   icon: Icon(Icons.more_vert),
                //   onPressed: () {},
                // ),
                trailing: _locationOptions(gateDetails, index),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          child: Text('Houston, we have a problem: No locations given'),
        ),
      );
    }
  }

  Widget _locationOptions(List<GateDetails> gateDetails, int index) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Access Codes'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Safety Checklist'),
          value: 2,
        ),
      ],
      onCanceled: () {},
      onSelected: (value) {
        // picked access codes
        if (value == 1) {
          _openAccessCodes(index);
        }
        // picked safety checklist
      },
      icon: Icon(Icons.more_vert, size: 25),
    );
  }



  Widget _buildCustomerInfo(BuildContext context, Customer customer) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: ListTile(
              title: SelectableText(
                customer.serviceAddress,
                style: TextStyle(fontSize: 18),
              ),
              leading: _getPropertyIcon(customer.propertyType),
              subtitle: _getAddressSubtitle(customer.propertyName),
              trailing: IconButton(
                icon: Icon(Icons.navigation),
                iconSize: 30,
                onPressed: () {},
              ),
              isThreeLine: true,
            ),
          ),
          Flexible(
            child: ListTile(
              leading: Icon(Icons.person),
              title: SelectableText(
                customer.contactPhone,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: _getPhoneSubtitle(customer.contactName),
              trailing: IconButton(
                icon: Icon(Icons.phone),
                iconSize: 30,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon _getPropertyIcon(String propertyType) {
    if (propertyType == "House") {
      return Icon(Icons.home);
    }
    if (propertyType == "Apartment") {
      return Icon(Icons.domain);
    }
    if (propertyType == "Business") {
      return Icon(Icons.store);
    }
    return Icon(Icons.location_on);
  }

  Text _getAddressSubtitle(String propertyName) {
    if (customer.propertyName == '')
      return Text(customer.propertyName);
    else
      return Text(
        customer.contactName,
        style: TextStyle(fontSize: 18),
      );
  }

  Text _getPhoneSubtitle(String contactName) {
    if (customer.propertyName != '')
      return Text('');
    else
      return Text(
        customer.contactName,
        style: TextStyle(fontSize: 18),
      );
  }
}
