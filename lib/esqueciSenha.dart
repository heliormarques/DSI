import 'package:dsi_app/constants.dart';
import 'package:dsi_app/infra.dart';
import 'package:dsi_app/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EsqueciSenha extends StatefulWidget {
  @override
  EsqueciFormState createState() => EsqueciFormState();
}



class EsqueciFormState extends State<EsqueciSenha>{
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image(
              image: Images.bsiLogo,
              height: 100,
            ),
            SizedBox(height: 100),
            Constants.spaceSmallHeight,
            Text("Informe seu e-mail:"),
            TextField(
                textAlign: TextAlign.center,
            decoration: InputDecoration(
            hintText: "email@example.com"
              ),
              onChanged: (String str) {
                setState(() {
                email = str;
                });
              }
            ),

            Text(
                "Um e-mail sera enviado para resetar sua senha",
              textScaleFactor: 0.8,
            ),
            FlatButton(
              onPressed: (){},
              color: Colors.lime,
              child: Text("Enviar"),

            ),
            ]

         )
       )
      )
    );
  }
}


