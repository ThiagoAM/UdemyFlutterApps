import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {

  // Overridden Methods:
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {

  // Properties:
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Overridden Methods:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {

          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,

            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[

                TextFormField(
                  controller: _nameController,
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome inválido!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Nome completo",
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@")) {
                      return "Email inválido!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return "Senha inválida!";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _addressController,
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Endereço inválido!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                ),

                SizedBox(height: 16),


                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {

                        Map<String, dynamic> userData = {
                          "name" : _nameController.text,
                          "email" : _emailController.text,
                          "address" : _addressController.text,
                        };

                        model.signUp(
                          userData: userData,
                          password: _passwordController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );

                      }
                    },
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }

  // Private Methods:
  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

}

