import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

// Home:
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Properties:
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _infoText = 'Informe seus dados!';

  // Private Methods:
  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Informe seus dados';
    });
  }

  void _calculateBMI() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double bmi = weight/(height * height);
      String formattedBMI = bmi.toStringAsPrecision(3);
      if (bmi < 18.6) {
        _infoText = "Abaixo do peso ($formattedBMI)";
      } else if (bmi >= 18.6 && bmi < 24.9) {
        _infoText = "Peso ideal ($formattedBMI)";
      } else if (bmi >= 24.9 && bmi < 29.9) {
        _infoText = "Levemente acima do peso ($formattedBMI)";
      } else if (bmi >= 29.9 && bmi < 34.9) {
        _infoText = "Obesidade grau I ($formattedBMI)";
      } else if (bmi >= 34.9 && bmi < 39.9) {
        _infoText = "Obesidade grau II ($formattedBMI)";
      } else if (bmi > 39.9) {
        _infoText = "Obesidade grau III ($formattedBMI)";
      }
    });
  }

  // Overridden Methods:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _resetFields();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.green,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Insira o seu peso!';
                  }
                },
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
              ),

              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Insira a sua altura!';
                  }
                },
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculateBMI();
                      }
                    },

                    child: Text(
                      'Calcular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),

                    color: Colors.green,

                  ),
                ),
              ),

              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
