import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_telemetry/pacientes.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:http/http.dart' as http;

class Historic extends StatefulWidget {
  final List<String> k;
  final String idDoc;
  final String idCliente;
  final String idManilla;
  final String year1;
  final String year2;
  final String month1;
  final String month2;
  final String day1;
  final String day2;
  final String hour1;
  final String hour2;
  final String minute1;
  final String minute2;
  Historic(
      this.k,
      this.idDoc,
      this.idCliente,
      this.idManilla,
      this.year1,
      this.year2,
      this.month1,
      this.month2,
      this.day1,
      this.day2,
      this.hour1,
      this.hour2,
      this.minute1,
      this.minute2);
  @override
  _HistoricState createState() => _HistoricState(
      this.k,
      this.idDoc,
      this.idCliente,
      this.idManilla,
      this.year1,
      this.year2,
      this.month1,
      this.month2,
      this.day1,
      this.day2,
      this.hour1,
      this.hour2,
      this.minute1,
      this.minute2);
}

class _HistoricState extends State<Historic> {
  _HistoricState(
      this.k,
      this.idDoc,
      this.idCliente,
      this.idManilla,
      this.year1,
      this.year2,
      this.month1,
      this.month2,
      this.day1,
      this.day2,
      this.hour1,
      this.hour2,
      this.minute1,
      this.minute2);
  String idDoc;
  String idCliente;
  String idManilla;
  List<String> k;
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

  String year1;
  String year2;
  String month1;
  String month2;
  String day1;
  String day2;
  String hour1;
  String hour2;
  String minute1;
  String minute2;

  String broker = '34.95.128.139';
  int port = 1883;
  String clientIdentifier = 'paciente2';
  String topic = 'pulsera';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  void _subscribeToTopic(String topic11) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic11.trim()}');
      client.subscribe(topic11, mqtt.MqttQos.exactlyOnce);
    }
  }

  List<charts.Series<Sales, DateTime>> _createSampleData() {
    List<Sales> d1 = [];
    if (k.length > 0) {
      for (var i = 0; i < k.length; i++) {
        List<String> data = k[i].split(",");
        print("innnnnnnnnnnnnnnnnnnnnnnnnn----------------");
        List<String> fecha = data[3].split(" ")[2].split("-");
        List<String> hora = data[3].split(" ")[3].split(":");
        print(fecha.toString());
        print(hora.toString());
        d1.add(
          new Sales(
            new DateTime(int.parse(fecha[0]), int.parse(fecha[1]),
                int.parse(fecha[2]), int.parse(hora[0]), int.parse(hora[1])),
            double.parse(data[2].split(":")[1]),
          ),
        );
      }
    }

    final data = d1;
    List<charts.Series<Sales, DateTime>> _chartLineal = [];
    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Temperatura',
      colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data,
    ));

    return _chartLineal;
  }

  List<charts.Series<Sales, DateTime>> _createSampleData2() {
    List<Sales> d2 = [];
    if (k.length > 0) {
      for (var i = 0; i < k.length; i++) {
        List<String> data = k[i].split(",");
        print("innnnnnnnnnnnnnnnnnnnnnnnnn----------------");
        List<String> fecha = data[3].split(" ")[2].split("-");
        List<String> hora = data[3].split(" ")[3].split(":");
        print(fecha.toString());
        print(hora.toString());

        d2.add(new Sales(
            new DateTime(int.parse(fecha[0]), int.parse(fecha[1]),
                int.parse(fecha[2]), int.parse(hora[0]), int.parse(hora[1])),
            double.parse(data[0].split(":")[1])));
      }
    }

    final data2 = d2;
    List<charts.Series<Sales, DateTime>> _chartLineal = [];

    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Oxigeno en la Sangre',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data2,
    ));
    return _chartLineal;
  }

  List<charts.Series<Sales, DateTime>> _createSampleData3() {
    List<Sales> d1 = [];
    List<Sales> d2 = [];
    List<Sales> d3 = [];
    if (k.length > 0) {
      for (var i = 0; i < k.length; i++) {
        List<String> data = k[i].split(",");
        print("innnnnnnnnnnnnnnnnnnnnnnnnn----------------");
        List<String> fecha = data[3].split(" ")[2].split("-");
        List<String> hora = data[3].split(" ")[3].split(":");
        print(fecha.toString());
        print(hora.toString());

        d3.add(new Sales(
            new DateTime(int.parse(fecha[0]), int.parse(fecha[1]),
                int.parse(fecha[2]), int.parse(hora[0]), int.parse(hora[1])),
            double.parse(data[1].split(":")[1])));
      }
    }
    final data3 = d3;
    List<charts.Series<Sales, DateTime>> _chartLineal = [];

    _chartLineal.add(charts.Series<Sales, DateTime>(
      id: 'Ritmo cardiaco',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
      data: data3,
    ));
    return _chartLineal;
  }

  int val = 0;
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
                    height: 110,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    height: 250,
                    child: charts.TimeSeriesChart(
                      _createSampleData(),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                            desiredMinTickCount: 4,
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
                  child: Row(
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    height: 250,
                    child: charts.TimeSeriesChart(
                      _createSampleData2(),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                            desiredMinTickCount: 4,
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
                  child: Row(
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    height: 250,
                    child: charts.TimeSeriesChart(
                      _createSampleData3(),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: (charts.BasicNumericTickProviderSpec(
                            desiredMinTickCount: 4,
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
                  "Historial de Telemetria",
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

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
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

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    if (event[0].topic == topic) {
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
        _temp = data[1];
        _ritmo = data[3];
        _spo = data[2];
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
}

class Sales {
  DateTime yearval;
  double salesval;

  Sales(this.yearval, this.salesval);
}
