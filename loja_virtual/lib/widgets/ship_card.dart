import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {

  // Overridden Methods:
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Icon(Icons.location_on),
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              initialValue: "",
              decoration: InputDecoration(
                hintText: "Digite o seu CEP",
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (text) {},
            ),
          ),
        ],
      ),
    );
  }

}
