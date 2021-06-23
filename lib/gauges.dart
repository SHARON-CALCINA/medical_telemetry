import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_telemetry/historic.dart';
import 'package:medical_telemetry/pacientes.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:http/http.dart' as http;

class Gauges extends StatefulWidget {
  final String idDoc;
  final String idCliente;
  final String idManilla;
  Gauges(this.idDoc, this.idCliente, this.idManilla);
  @override
  _GaugesState createState() =>
      _GaugesState(this.idDoc, this.idCliente, this.idManilla);
}

class _GaugesState extends State<Gauges> {
  _GaugesState(this.idDoc, this.idCliente, this.idManilla);
  String idDoc;
  String idCliente;
  String idManilla;
  List<String> k = [];
  bool vis = false;

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

  String year1 = "";
  String year2 = "";
  String month1 = "";
  String month2 = "";
  String day1 = "";
  String day2 = "";
  String hour1 = "";
  String hour2 = "";
  String minute1 = "";
  String minute2 = "";
  Future<List<String>> pacHistoric(
      String id,
      String yini,
      String mini,
      String dini,
      String hini,
      String minini,
      String yfin,
      String mfin,
      String dfin,
      String hfin,
      String minfin) async {
    final response = await http
        .post(Uri.parse('https://teracorp.ga/patient_historic.php'), body: {
      'd_idPaciente': id,
      'y_ini': yini,
      'm_ini': mini,
      'd_ini': dini,
      'h_ini': hini,
      'min_ini': minini,
      'y_fin': yfin,
      'm_fin': mfin,
      'd_fin': dfin,
      'h_fin': hfin,
      'min_fin': minfin
    });
    //"71111117"
    var dataUser = jsonDecode(response.body);
    String resp = dataUser.toString();
    setState(() {
      k = resp.replaceAll("{", "").split("},");
    });

    //messagelog = resp[resp.length - 1];
    print("--------------------------${k.toString()}");
    return k;
  }

  String broker = '34.95.128.139';
  int port = 1883;
  String clientIdentifier = 'paciente2';
  //String topic = 'pulsera';
  String topic2 = 'iot1/Bmp';
  String topic3 = 'iot1/Spo2';
  MqttServerClient client;
  mqtt.MqttConnectionState connectionState;
  MqttServerClient client2;
  mqtt.MqttConnectionState connectionState2;
  MqttServerClient client3;
  mqtt.MqttConnectionState connectionState3;
  String _temp = 20.toString();
  String _ritmo = 20.toString();
  String _spo = 20.toString();

  StreamSubscription subscription;
  StreamSubscription subscription2;
  StreamSubscription subscription3;
  @override
  void initState() {
    d1.clear();
    d2.clear();
    d3.clear();
    super.initState();
    // _createSampleData();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  void _subscribeToTopic(String topic11) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic11.trim()}');
      client.subscribe(topic11, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _subscribeToTopic2(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic2.trim()}');
      client.subscribe(topic2, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _subscribeToTopic3(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic3.trim()}');
      client.subscribe(topic3, mqtt.MqttQos.exactlyOnce);
    }
  }

  List<Sales> d1 = [];
  List<Sales> d2 = [];
  List<Sales> d3 = [];

  List<charts.Series<Sales, DateTime>> _createSampleData() {
    int y = 2020;
    int m = 4;
    int d = 4;
    int h = 6;
    int mi = 10;

    int c = 1;
    double s = 10;
    //for (var i = 0; i < 5; i++) {
    //d1.add(new Sales(new DateTime(y, m - 1, d, h, mi), 0));
    //d2.add(new Sales(new DateTime(y, m - 2, d, h, mi), 0));
    //d3.add(new Sales(new DateTime(y, m - 3, d, h, mi), 0));
    c++;
    s += 10;
    //}

    List<charts.Series<Sales, DateTime>> _chartLineal = [];
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Temperatura',
      colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: d1,
    ));
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Oxigeno en la Sangre',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: d2,
    ));
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Ritmo cardiaco',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: d3,
    ));
    return _chartLineal;
  }

  int val = 0;
  DateTime _dateTime;
  DateTime _dateTime2;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime2 = TimeOfDay(hour: 00, minute: 00);
  @override
  Widget build(BuildContext context) {
    //pacDoctor();
    double h = MediaQuery.of(context).size.height;

    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 103, 65, 114),
        body: Stack(
          children: [
            background(),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
                SliverToBoxAdapter(
                  child: temperatura(w / 1, h / 2),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    oxigenoSangre(w / 1.5, h / 2),
                    ritmoCardiaco(w / 1.5, h / 2),
                  ],
                )),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                SliverToBoxAdapter(
                  child: text("Telemetria en tiempo real", 14.0, Colors.white,
                      FontWeight.w500),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.linear_scale, color: Colors.yellow),
                        // Icon(Icons.stacked_line_chart_outlined,
                        //   color: Colors.yellow),
                        SizedBox(
                          width: 10,
                        ),
                        text("Temperatura", 14.0, Colors.white.withOpacity(0.6),
                            FontWeight.normal)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.linear_scale, color: Colors.blue),
                        SizedBox(
                          width: 10,
                        ),
                        text("Oxigeno en la sangre", 14.0,
                            Colors.white.withOpacity(0.6), FontWeight.normal)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.linear_scale, color: Colors.red),
                        //Icon(Icons.stacked_line_chart_outlined,
                        //   color: Colors.red),
                        SizedBox(
                          width: 10,
                        ),
                        text("Ritmo cardiaco", 14.0,
                            Colors.white.withOpacity(0.6), FontWeight.normal)
                      ],
                    ),
                  ],
                )),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 50, top: 10),
                    height: 250,
                    child: charts.TimeSeriesChart(
                      _createSampleData(),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                            desiredMinTickCount: 5,
                            desiredTickCount: 5,
                            zeroBound: true)),
                        showAxisLine: false,
                        renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                                fontSize: 12,
                                color: charts.MaterialPalette.white),
                            lineStyle: charts.LineStyleSpec(
                                dashPattern: [2, 2],
                                color: charts.ColorUtil.fromDartColor(
                                    Colors.green))),
                      ),
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: text("Historial de Telemetria", 14.0, Colors.white,
                      FontWeight.w500),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                /*SliverToBoxAdapter(
                  child: DropdownButton(
                      hint: Text(
                        "selecciona un rango de fechas",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontFamily: "kanit",
                          fontSize: 12,
                        ),
                      ),
                      //value: val,
                      items: [
                        DropdownMenuItem(
                          onTap: () {
                            setState(() {
                              val = 0;
                            });
                          },
                          value: 0,
                          child: text(
                              "2000", 14.0, Colors.white, FontWeight.normal),
                        ),
                        DropdownMenuItem(
                          onTap: () {
                            setState(() {
                              val = 1;
                            });
                          },
                          value: 1,
                          child: text(
                              "2001", 14.0, Colors.white, FontWeight.normal),
                        )
                      ]),
                ),*/
                SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: w / 2.5,
                        child: Text(
                          _dateTime == null
                              ? '0000-00-00'
                              : "${_dateTime.year.toString()} - ${_dateTime.month.toString()} - ${_dateTime.day.toString()}",
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        width: w / 2.5,
                        child: Text(
                          _dateTime2 == null
                              ? '0000-00-00'
                              : "${_dateTime2.year.toString()} - ${_dateTime2.month.toString()} - ${_dateTime2.day.toString()}",
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        )),
                  ],
                )),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 5,
                )),
                SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 35,
                      width: 120,
                      child: ElevatedButton(
                          child: text("Fecha Inicial", 12.0, Colors.white,
                              FontWeight.normal),
                          /*Text(
                            "Fecha de inicial",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),*/
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)))),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: _dateTime == null
                                        ? DateTime.now()
                                        : _dateTime,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2022))
                                .then((date) {
                              setState(() {
                                _dateTime = date;
                                year1 = _dateTime.year.toString();
                                month1 = _dateTime.month.toString();
                                day1 = _dateTime.day.toString();
                              });
                            });
                          }),
                    ),
                    Container(
                      height: 35,
                      width: 120,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                          child: text("Fecha final", 12.0, Colors.white,
                              FontWeight.normal),
                          /* overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),*/
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)))),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: _dateTime == null
                                        ? DateTime.now()
                                        : _dateTime,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2022))
                                .then((date) {
                              setState(() {
                                _dateTime2 = date;
                                year2 = _dateTime2.year.toString();
                                month2 = _dateTime2.month.toString();
                                day2 = _dateTime2.day.toString();
                              });
                            });
                          }),
                    ),
                  ],
                )),
                SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: w / 2.5,
                        child: Text(
                          selectedTime == null
                              ? '00 : 00'
                              : "${selectedTime.hour.toString()} : ${selectedTime.minute.toString()}  ",
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        width: w / 2.5,
                        child: Text(
                          selectedTime2 == null
                              ? '00 : 00'
                              : "${selectedTime2.hour.toString()} : ${selectedTime2.minute.toString()}  ",
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        )),
                  ],
                )),
                SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 35,
                        width: 120,
                        child: ElevatedButton(
                          child: text("Tiempo inicial", 12.0, Colors.white,
                              FontWeight.normal),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)))),
                          onPressed: () async {
                            if (selectedTime == null) {
                              final TimeOfDay picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              setState(() {
                                selectedTime = picked;
                              });
                            } else {
                              final TimeOfDay picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              setState(() {
                                selectedTime = picked;
                                hour1 = selectedTime.hour.toString();
                                minute1 = selectedTime.minute.toString();
                              });
                            }
                          },
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 35,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ElevatedButton(
                          child: text("Tiempo final", 12.0, Colors.white,
                              FontWeight.normal),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)))),
                          onPressed: () async {
                            final TimeOfDay picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime2,
                            );
                            setState(() {
                              selectedTime2 = picked;
                              hour2 = selectedTime2.hour.toString();
                              minute2 = selectedTime2.minute.toString();
                            });
                          },
                        ))
                  ],
                )),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 10,
                )),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: text("Ver Historico", 15.0, Colors.white,
                            FontWeight.w600),
                        onPressed: () async {
                          // _dateTime.year.toString()} - ${_dateTime.month.toString()} - ${_dateTime.day.toString();
                          if (year1 != "" &&
                              month1 != "" &&
                              day1 != "" &&
                              hour1 != "" &&
                              minute1 != "" &&
                              year2 != "" &&
                              month2 != "" &&
                              day2 != "" &&
                              hour2 != "" &&
                              minute2 != "") {
                            setState(() {
                              vis = false;
                            });
                            List<String> mm = await pacHistoric(
                                idCliente,
                                year1,
                                month1,
                                day1,
                                hour1,
                                minute1,
                                year2,
                                month2,
                                day2,
                                hour2,
                                minute2);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Historic(
                                  mm,
                                  idDoc,
                                  idCliente,
                                  idManilla,
                                  year1,
                                  year2,
                                  month1,
                                  month2,
                                  day1,
                                  day2,
                                  hour1,
                                  hour2,
                                  minute1,
                                  minute2);

                              /*"2021",
                          "05",
                          "06",
                          "16",
                          "30",
                          "2021",
                          "05",
                          "08",
                          "16",
                          "45"*/
                            }));
                          } else if (year1 == "" ||
                              month1 == "" ||
                              day1 == "" ||
                              hour1 == "" ||
                              minute1 == "" ||
                              year2 == "" ||
                              month2 == "" ||
                              day2 == "" ||
                              hour2 == "" ||
                              minute2 == "") {
                            setState(() {
                              vis = true;
                            });
                          }
                        },
                      ),
                      Visibility(
                        child: text(
                            "Debe seleccionar todos los campos: Fecha inicial , Fecha final, Tiempo inicial y Tiempo final",
                            12.0,
                            Colors.red,
                            FontWeight.normal),
                        visible: vis,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                  ),
                ),

                /* SliverToBoxAdapter(
                    child: Text(
                  d1.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))*/
              ],
            ),
            header(),
          ],
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
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Align(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Pacientes(
                        idDoc: idDoc,
                        list: pacDoctor(),
                      );
                    }));
                  },
                  iconSize: 25,
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white.withOpacity(0.6),
                ),
                alignment: Alignment.centerLeft,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 90,
                child: Text(
                  "Datos de Telemetria",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "kanit",
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget temperatura(w, h) {
    return Container(
        child: Column(children: [
      text("Temperatura", 14.0, Colors.white.withOpacity(0.5), FontWeight.w500),
      SizedBox(
        height: 10,
      ),
      /*text("Temperatura", 15.0, Colors.white.withOpacity(0.5),
          FontWeight.normal),*/
      Container(
          width: w / 1.5,
          height: w / 1.5,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),

                  ///Colors.black.withOpacity(0.4),
                  //Color.fromARGB(0, 0, 40, 200).withOpacity(0.6),
                  //Color.fromARGB(255, 148, 124, 176).withOpacity(0.6),
                  // Color.fromARGB(255, 148, 124, 176).withOpacity(0.4),
                  Color.fromARGB(255, 25, 25, 112).withOpacity(0.5),
                  Colors.black.withOpacity(0.5),
                ],
                stops: [
                  0.0,
                  0.6,
                  //s0.4,
                  0.8,
                  //0.6,
                  1.2
                ],
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              //color: Color.fromARGB(255, 103, 65, 114).withOpacity(0.1),
              //Color.fromARGB(255, 25, 25, 112).withOpacity(0.8),
              shape: BoxShape.rectangle),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: 60,
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                            child: Text(_temp,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8)))),
                        angle: 90,
                        positionFactor: 0.5)
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: double.parse(_temp),
                        needleColor: Colors.blueGrey,
                        needleStartWidth: 0)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        labelStyle: GaugeTextStyle(color: Colors.black),
                        label: "baja",
                        startValue: 0,
                        endValue: 35.9,
                        color: Color.fromARGB(255, 0, 150, 150),
                        startWidth: 10,
                        endWidth: 10),
                    GaugeRange(
                        labelStyle: GaugeTextStyle(color: Colors.black),
                        label: "normal",
                        startValue: 36,
                        endValue: 37.5,
                        color: Color.fromARGB(255, 50, 200, 200),
                        startWidth: 10,
                        endWidth: 10),
                    GaugeRange(
                        labelStyle: GaugeTextStyle(color: Colors.black),
                        label: "alta",
                        startValue: 37.6,
                        endValue: 60,
                        color: Color.fromARGB(255, 100, 250, 250),
                        startWidth: 10,
                        endWidth: 10)
                  ])
            ],
            enableLoadingAnimation: true,
            animationDuration: 1500,
            /*title: GaugeTitle(
                borderWidth: 10,
                text: "Temperatura",
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold))*/
          )),
      Container(
        padding: EdgeInsets.all(4),
        width: w / 1.5,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: text(
            "Fecha: ${DateTime.now().year} / ${DateTime.now().month} / ${DateTime.now().day}",
            14.0,
            Colors.white.withOpacity(0.5),
            FontWeight.w400),
      )
    ]));
  }

  Widget ritmoCardiaco(w, h) {
    return Container(
        child: Column(children: [
      text("Ritmo Cardiaco", 14.0, Colors.white.withOpacity(0.5),
          FontWeight.w500),
      SizedBox(
        height: 10,
      ),
      Container(
          width: w / 1.5,
          height: w / 1.5,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                  Color.fromARGB(255, 25, 25, 112).withOpacity(0.5),
                  Colors.black.withOpacity(0.5),
                ],
                stops: [0.0, 0.6, 0.8, 1.2],
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              shape: BoxShape.rectangle),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: 200,
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                            child: Text(_ritmo,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.8)))),
                        angle: 90,
                        positionFactor: 0.5)
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: double.parse(_ritmo),
                        needleColor: Colors.blueGrey,
                        needleStartWidth: 0)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        labelStyle: GaugeTextStyle(color: Colors.black),
                        label: "baja",
                        startValue: 0,
                        endValue: 60,
                        color: Color.fromARGB(255, 255, 150, 150),
                        startWidth: 10,
                        endWidth: 10),
                    GaugeRange(
                        startValue: 61,
                        endValue: 90,
                        color: Color.fromARGB(255, 255, 200, 200),
                        startWidth: 10,
                        endWidth: 10),
                    GaugeRange(
                        startValue: 91,
                        endValue: 200,
                        color: Color.fromARGB(255, 255, 250, 250),
                        startWidth: 10,
                        endWidth: 10)
                  ])
            ],
            enableLoadingAnimation: true,
            animationDuration: 1500,
          )),
      Container(
        padding: EdgeInsets.all(4),
        width: w / 1.5,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: text(
            "Fecha:  ${DateTime.now().year} / ${DateTime.now().month} / ${DateTime.now().day}",
            14.0,
            Colors.white.withOpacity(0.5),
            FontWeight.w400),
      )
    ]));
  }

  Widget oxigenoSangre(w, h) {
    return Container(
      child: Column(
        children: [
          text("Oxigeno en la sangre", 14.0, Colors.white.withOpacity(0.5),
              FontWeight.w500),
          SizedBox(
            height: 10,
          ),
          Container(
              width: w / 1.5,
              height: w / 1.5,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.6),
                      Color.fromARGB(255, 25, 25, 112).withOpacity(0.5),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.0, 0.6, 0.8, 1.2],
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 0,
                      maximum: 150,
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text(_spo,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.8)))),
                            angle: 90,
                            positionFactor: 0.5)
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                            value: double.parse(_spo),
                            needleColor: Colors.blueGrey,
                            needleStartWidth: 0)
                      ],
                      ranges: <GaugeRange>[
                        GaugeRange(
                            labelStyle: GaugeTextStyle(
                                color: Colors.white, fontSize: 8),
                            label: "baja",
                            startValue: 0,
                            endValue: 50,
                            color: Color.fromARGB(255, 150, 255, 100),
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 50,
                            endValue: 100,
                            color: Color.fromARGB(255, 150, 255, 180),
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 100,
                            endValue: 150,
                            color: Color.fromARGB(255, 150, 255, 50),
                            startWidth: 10,
                            endWidth: 10)
                      ])
                ],
                enableLoadingAnimation: true,
                animationDuration: 1500,
              )),
          Container(
            padding: EdgeInsets.all(4),
            width: w / 1.5,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: text(
                "Fecha:  ${DateTime.now().year} / ${DateTime.now().month} / ${DateTime.now().day}",
                14.0,
                Colors.white.withOpacity(0.5),
                FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget text(title, size, color, font) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: font, fontFamily: "Kanit"),
    );
  }

  void _connect() async {
    client = MqttServerClient(broker, '');
    client.port = port;
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionStatus.state == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionStatus.state;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionStatus.state}');
      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);
    _subscribeToTopic(idManilla);
  }

  void _connect2() async {
    client2 = MqttServerClient(broker, '');
    client2.port = port;
    client2.keepAlivePeriod = 30;
    client2.onDisconnected = _onDisconnected2;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client2.connectionMessage = connMess;

    try {
      await client2.connect();
    } catch (e) {
      print(e);
      _disconnect2();
    }

    /// Check if we are connected
    if (client2.connectionStatus.state == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState2 = client2.connectionStatus.state;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client2.connectionStatus.state}');
      _disconnect2();
    }

    subscription2 = client2.updates.listen(_onMessage2);
    _subscribeToTopic2(topic2);
  }

  void _connect3() async {
    client3 = MqttServerClient(broker, '');
    client3.port = port;
    client3.keepAlivePeriod = 30;
    client3.onDisconnected = _onDisconnected3;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client3.connectionMessage = connMess;

    try {
      await client3.connect();
    } catch (e) {
      print(e);
      _disconnect3();
    }

    /// Check if we are connected
    if (client3.connectionStatus.state == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState3 = client3.connectionStatus.state;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client3.connectionStatus.state}');
      _disconnect3();
    }

    subscription3 = client3.updates.listen(_onMessage3);
    _subscribeToTopic3(topic3);
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _disconnect2() {
    print('[MQTT client] _disconnect()');
    client2.disconnect();
    _onDisconnected2();
  }

  void _disconnect3() {
    print('[MQTT client] _disconnect()');
    client3.disconnect();
    _onDisconnected3();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionStatus.state;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onDisconnected2() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState2 = client2.connectionStatus.state;
      client2 = null;
      subscription2.cancel();
      subscription2 = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onDisconnected3() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState3 = client3.connectionStatus.state;
      client3 = null;
      subscription3.cancel();
      subscription3 = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    if (event[0].topic == idManilla) {
      final mqtt.MqttPublishMessage recMess =
          event[0].payload as mqtt.MqttPublishMessage;
      final String message = mqtt.MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
          'payload is <-- $message -->');
      print(client.connectionStatus.state);
      print("[MQTT client] message with topic: ${event[0].topic}");
      print("[MQTT client] message with message: $message");
      setState(() {
        List<String> data = message.split(",");
        _temp = (double.parse(data[1])).toStringAsFixed(2);
        /*if (d1.length > 6) {
          d1.removeAt(0);
        }*/
        d1.add(Sales(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            double.parse(_temp)));
        _ritmo = (double.parse(data[3])).toStringAsFixed(2);
        /*if (d3.length > 6) {
          d3.removeAt(0);
        }*/
        d3.add(Sales(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            double.parse(_ritmo)));
        _spo = (double.parse(data[2])).toStringAsFixed(2);
        /*if (d2.length > 6) {
          d2.removeAt(0);
        }*/
        d2.add(Sales(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            double.parse(_spo)));
      });
    }
    if (event[0].topic == topic2) {
      final mqtt.MqttPublishMessage recMess =
          event[0].payload as mqtt.MqttPublishMessage;
      final String message = mqtt.MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
          'payload is <-- $message -->');
      print(client.connectionStatus.state);
      print("[MQTT client] message with topic: ${event[0].topic}");
      print("[MQTT client] message with message: $message");
      setState(() {
        _ritmo = message;
      });
    }
    if (event[0].topic == topic3) {
      final mqtt.MqttPublishMessage recMess =
          event[0].payload as mqtt.MqttPublishMessage;
      final String message = mqtt.MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
          'payload is <-- $message -->');
      print(client.connectionStatus.state);
      print("[MQTT client] message with topic: ${event[0].topic}");
      print("[MQTT client] message with message: $message");
      setState(() {
        _spo = message;
      });
    }
  }

  void _onMessage2(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    print(client.connectionStatus.state);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: $message");
    setState(() {
      _ritmo = message;
    });
  }

  void _onMessage3(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    print(client.connectionStatus.state);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: $message");
    setState(() {
      _spo = message;
    });
  }
}

class Sales {
  DateTime yearval;
  double salesval;

  Sales(this.yearval, this.salesval);
}
