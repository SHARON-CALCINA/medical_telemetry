import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:medical_telemetry/regPaciente.dart';
import 'package:http/http.dart' as http;
import 'package:medical_telemetry/registro.dart';
import 'pacientes.dart';

class Menu extends StatefulWidget {
  final String idDoc;
  Menu(this.idDoc);
  @override
  _MenuState createState() => _MenuState(this.idDoc);
}

class _MenuState extends State<Menu> {
  _MenuState(this.idDoc);
  String idDoc;
  List<charts.Series<Pollution, String>> _seriesData = [];
  List<charts.Series<Task, String>> _seriesPieData = [];
  //List<charts.Series<Sales, int>> _seriesLineData = [];
  List<String> k;

  Future<List<String>> pacDoctor() async {
    final response = await http
        .post(Uri.parse('https://teracorp.ga/patient_doc.php'), body: {
      'd_idDoctor': idDoc,
    });
    var dataUser = jsonDecode(response.body);
    String resp = dataUser.toString();
    k = resp.split("},");
    //messagelog = resp[resp.length - 1];
    print("meeeeeeeeeeeeeeeeeeeeeeeeeeeeeesssssssssssss$resp");
    return k;
  }

  _generateData() {
    var data1 = [
      new Pollution(1980, 'USA', 30),
      new Pollution(1980, 'Asia', 40),
      new Pollution(1980, 'Europe', 10),
    ];
    var data2 = [
      new Pollution(1985, 'USA', 100),
      new Pollution(1980, 'Asia', 150),
      new Pollution(1985, 'Europe', 80),
    ];
    var data3 = [
      new Pollution(1985, 'USA', 200),
      new Pollution(1980, 'Asia', 300),
      new Pollution(1985, 'Europe', 180),
    ];

    var piedata = [
      new Task('0-18', 45.8, Color(0xff3366cc)),
      new Task('19-27', 28.3, Color(0xff990099)),
      new Task('28-36', 2, Color(0xff109618)),
      new Task('37-48', 15.6, Color(0xfffdbe19)),
      new Task('49-56', 19.2, Color(0xffff9900)),
      new Task('57- ', 10.3, Color(0xffdc3912)),
    ];

    /*var linesalesdata = [
      new Sales(DateTime(2017, 12, 30), 58),
      new Sales(DateTime(2018, 12, 30), 56),
      new Sales(DateTime(2019, 12, 30), 55),
      new Sales(DateTime(2020, 12, 30), 60),
      new Sales(DateTime(2021, 12, 30), 61),
      new Sales(DateTime(2022, 12, 30), 70),
    ];*/
    /*var linesalesdata1 = [
      new Sales(DateTime(2017, 12, 30), 58),
      new Sales(DateTime(2018, 12, 30), 56),
      new Sales(DateTime(2019, 12, 30), 55),
      new Sales(DateTime(2020, 12, 30), 60),
      new Sales(DateTime(2021, 12, 30), 61),
      new Sales(DateTime(2022, 12, 30), 70),
    ];*/

    /*var linesalesdata2 = [
      new Sales(DateTime(2017, 12, 30), 58),
      new Sales(DateTime(2018, 12, 30), 56),
      new Sales(DateTime(2019, 12, 30), 55),
      new Sales(DateTime(2020, 12, 30), 60),
      new Sales(DateTime(2021, 12, 30), 61),
      new Sales(DateTime(2022, 12, 30), 70),
    ];*/

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2018',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2019',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    /* _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval.year,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );*/
    /*_seriesLineData.add(
      charts.Series<Sales, DateTime>(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );*/
    /* _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval.year,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );*/
  }

  List<charts.Series<Sales, DateTime>> _createSampleData() {
    final data = [
      new Sales(new DateTime(2017), 5),
      new Sales(new DateTime(2018), 25),
      new Sales(new DateTime(2019), 100),
      new Sales(new DateTime(2020), 75),
    ];
    final data2 = [
      new Sales(new DateTime(2017), 25),
      new Sales(new DateTime(2018), 25),
      new Sales(new DateTime(2019), 80),
      new Sales(new DateTime(2020), 55),
    ];
    final data3 = [
      new Sales(new DateTime(2017), 35),
      new Sales(new DateTime(2018), 45),
      new Sales(new DateTime(2019), 40),
      new Sales(new DateTime(2020), 25),
    ];
    List<charts.Series<Sales, DateTime>> _chartLineal = [];
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Temperatura',
      colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data,
    ));
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Oxigeno en la Sangre',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data2,
    ));
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Ritmo cardiaco',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data3,
    ));

    return _chartLineal;
  }

  @override
  void initState() {
    super.initState();
    _seriesData = [];
    _seriesPieData = [];
    //_seriesLineData = [];
    _generateData();
    // pushNot.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    //getP();
    pacDoctor();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 103, 65, 114),
        body: Stack(
          children: [background(), body(width, height), header()],
        ));
  }

  Widget background() {
    return Container(
      decoration: new BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.black.withOpacity(0.8),
        Colors.black.withOpacity(0.6),
        Color.fromARGB(255, 25, 25, 112).withOpacity(0.5),
        Colors.black.withOpacity(0.8),
      ], stops: [
        0.2,
        0.4,
        0.6,
        0.9
      ], begin: FractionalOffset.topRight, end: FractionalOffset.bottomLeft)),
    );
  }

  Widget header() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            height: 40,
            //color: Colors.white,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 20,
                ),
                Align(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Register();
                      }));
                    },
                    iconSize: 25,
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  child: Text(
                    "Monitoreo de Pacientes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontFamily: "kanit"),
                  ),
                ),
                /*Align(
                  child: CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notification_important,
                        color: Colors.red.shade400,
                      ),
                      iconSize: 25,
                    ),
                  ),
                  alignment: Alignment.centerRight,
                ),
                SizedBox(
                  width: 20,
                ),*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget body(w, h) {
    return SingleChildScrollView(
        child: Center(
            child: Column(children: [
      SizedBox(
        height: 100,
      ),
      /*GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            margin: EdgeInsets.all(10),
            width: w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text("Buscar por nombre o ID", 12.0, Colors.black,
                    FontWeight.normal),
                Icon(Icons.search),
              ],
            )),
      ),*/
      card(
          "assets/images/r.jpg",
          "Ver Registro de Pacientes",
          Colors.orange.shade300,
          w,
          160.0,
          50.0,
          0.0,
          50.0,
          20.0,
          Pacientes(
            idDoc: idDoc,
            list: pacDoctor(),
          ),
          Alignment.bottomRight),
      /* Row(
        children: [
          //Column(
          // children: [
          card2(
              "assets/images/nro.jpg",
              "2000",
              "Numero de pacientes",
              Colors.blueGrey.shade300,
              w / 2 - 20,
              220.0,
              50.0,
              20.0,
              0.0,
              50.0),
          /*card2(
                  "assets/images/not.jpg",
                  "5",
                  "Numero de notificaciones",
                  Colors.blueGrey.shade300,
                  w / 2 - 20,
                  100.0,
                  0.0,
                  20.0,
                  0.0,
                  0.0),*/
          // ],
          //),*/
      card(
          "assets/images/pa.jpg",
          "Adicionar Paciente",
          Colors.red.shade300,
          w,
          160.0,
          00.0,
          50.0,
          20.0,
          50.0,
          RegPaciente(idDoc),
          Alignment.bottomLeft),
      // ],
      //),
      SizedBox(
        height: 20,
      ),
      /*text("Promedio Monitoreo de Pacientes", 16.0,
          Colors.white.withOpacity(0.8), FontWeight.w600),
      Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        height: 250,
        child: charts.TimeSeriesChart(
          _createSampleData(),
          /*defaultRenderer: charts.BarRendererConfig<DateTime>(
              barRendererDecorator: charts.BarLabelDecorator<DateTime>()),*/
          //domainAxis: new charts.DateTimeAxisSpec(
          // showAxisLine: true,
          // tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          /*day: new charts.TimeFormatterSpec(
                format: 'dd',
                transitionFormat: 'dd MMM',
              ),*/
          //),
          //    ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                desiredMinTickCount: 4, desiredTickCount: 5, zeroBound: true)),
            renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                    fontSize: 12, color: charts.MaterialPalette.white.darker),
                lineStyle: charts.LineStyleSpec(
                    dashPattern: [2, 2],
                    color: charts.ColorUtil.fromDartColor(Colors.green))),
          ),
          /* domainAxis: charts.NumericAxisSpec(
            tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                desiredMinTickCount: 4,
                desiredTickCount: 5,
                dataIsInWholeNumbers: true,
                zeroBound: true)),
            renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                    fontSize: 20, color: charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(
                    dashPattern: [2, 2],
                    color: charts.ColorUtil.fromDartColor(Colors.cyan))),
          ),*/
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          animate: true,
          animationDuration: Duration(seconds: 1),
        ),
      ),
      text("Pacientes por edad", 16.0, Colors.white.withOpacity(0.8),
          FontWeight.w600),
      Container(
          margin: EdgeInsets.only(top: 20),
          height: 500,
          color: Colors.transparent,
          child: charts.PieChart(
            _seriesPieData,
            animate: true,
            animationDuration: Duration(seconds: 2),
            behaviors: [
              new charts.DatumLegend(
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding: new EdgeInsets.only(right: 6.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.white.darker,
                    fontFamily: 'Kanit',
                    fontSize: 12),
              )
            ],
          )),*/
    ])));
  }

  Widget card(image, title, color, w, h, tl, tr, bl, br, page, align) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        shadowColor: Colors.purple.shade400,
        color: Colors.blue.shade900,
        elevation: 20,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: w,
                    height: h,
                  ),
                )),
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Align(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return page;
                      }));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(tr),
                                bottomRight: Radius.circular(br),
                                topLeft: Radius.circular(tl),
                                bottomLeft: Radius.circular(bl))),
                        width: 100,
                        height: 100,
                        child: Align(
                            child: text(
                                title, 13.5, Colors.black, FontWeight.w700))),
                  ),
                  alignment: align,
                )
              ],
            )
          ],
        ));
  }

  Widget card2(image, nro, title, color, w, h, t, l, r, b) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(top: t, left: l, right: r, bottom: b),
        shadowColor: Colors.black,
        color: Colors.white.withOpacity(0.0),
        elevation: 10,
        child: Center(
            child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: w,
                    height: 220,
                  ),
                )),
            Container(
                width: w,
                height: h,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Align(
                        child: text(nro, 25.0, Colors.white.withOpacity(0.7),
                            FontWeight.w800),
                        alignment: Alignment.bottomCenter,
                      ),
                      Align(
                        child: text(title, 12.0, Colors.white.withOpacity(0.9),
                            FontWeight.w600),
                        alignment: Alignment.bottomCenter,
                      )
                    ],
                  ),
                ))
          ],
        )));
  }

  Widget text(title, size, color, font) {
    return Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: font, fontFamily: "Kanit"),
    );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  DateTime yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
