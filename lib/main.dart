import 'package:flutter/material.dart';
import 'package:medical_telemetry/registro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Telemetry',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: AppMain(),
    );
  }
}

class AppMain extends StatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          "assets/images/m.jpg",
          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
        Center(
            child: Container(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [
              SizedBox(
                height: 50,
              ),
              text("Bienvenido", 20.0, Colors.black, FontWeight.bold),
              text(
                "Monitoreo de Pacientes",
                24.0,
                Colors.blue.shade900,
                FontWeight.bold,
              )
            ]),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return Register();
                }));
              },
              child: text("Continuar", 16.0, Colors.white, FontWeight.w500),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  backgroundColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
            )
          ],
        ))),
      ],
    ));
  }

  Widget text(title, size, color, font) {
    return Text(
      title,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: font, fontFamily: "Kanit"),
    );
  }
}
