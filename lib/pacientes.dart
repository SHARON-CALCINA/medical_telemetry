import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_telemetry/gauges.dart';
import 'menu.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Pacientes extends StatefulWidget {
  final String idDoc;
  final Future<List<String>> list;
  Pacientes({Key key, @required this.idDoc, @required this.list})
      : super(key: key);
  @override
  _PacientesState createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  final key = GlobalKey<FormState>();
  TextEditingController bracelet = TextEditingController();
  List<String> k;
  int count;
  Future<List<String>> getP() async {
    var url = Uri.parse('https://teracorp.ga/get_health_detail.php');
    http.Response response = await http.get(url);
    print("----------infoooooooooo----");
    print(response.body.toString());

    var jsonResponse = convert.jsonDecode(response.body.toString());
    print(jsonResponse.toString());
    k = jsonResponse.toString().split("},");

    /*var jsonResponse = convert.jsonDecode(response.body);
    print(jsonResponse);
    k = jsonResponse.toString().split("},");
    print(k.toString());*/
    //k = jsonResponse.toString().split("},");
    //count = k.length;
    return k;
  }

  String messagelog = "";
  Future pacDoctor() async {
    final response = await http
        .post(Uri.parse('https://teracorp.ga/patient_doc.php'), body: {
      'd_idDoctor': widget.idDoc,
    });
    var dataUser = jsonDecode(response.body);
    String resp = dataUser.toString();
    //messagelog = resp[resp.length - 1];
    print("meeeeeeeeeeeeeeeeeeeeeeeeeeeeeesssssssssssss$resp");
  }

  Future<List<String>> pacInfo(String id, String doc) async {
    final response = await http.post(
        Uri.parse('https://teracorp.ga/patient_info.php'),
        body: {'d_idDoctor': widget.idDoc, 'd_idPaciente': '71111117'});
    //"71111117"
    var dataUser = jsonDecode(response.body);
    String resp = dataUser.toString();
    setState(() {
      k = resp.split("},");
    });

    //messagelog = resp[resp.length - 1];
    print("--------------------------$resp");
    return k;
  }

  String kk = "";
  Future<String> pacTopic(String id) async {
    final response = await http.post(
        Uri.parse('https://teracorp.ga/patient_topic.php'),
        body: {'d_idPaciente': id});
    //"71111117"
    var dataUser = jsonDecode(response.body);
    String resp = dataUser.toString();
    setState(() {
      kk = resp;
    });
    return kk;
  }

  @override
  void initState() {
    bracelet.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getP();
    //pacDoctor();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 103, 65, 114),
        body: Center(
          child: FutureBuilder<List<String>>(
              future: widget.list,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      background(),
                      Column(
                        children: [
                          Container(
                            decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.6),
                                  Color.fromARGB(255, 25, 25, 112)
                                      .withOpacity(0.5),
                                  Colors.black.withOpacity(0.8),
                                ],
                                    stops: [
                                  0.2,
                                  0.4,
                                  0.6,
                                  0.9
                                ],
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomLeft)),
                          ),
                          /* CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),*/
                          Expanded(
                            child: CustomScrollView(slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.only(top: 42),
                                  margin: EdgeInsets.all(15),
                                  height: 130,
                                  width: MediaQuery.of(context).size.width - 90,
                                ),
                              ),
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.60,
                                  crossAxisCount: 1,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  List<String> k2 = snapshot.data[index]
                                      .toString()
                                      .split(",");

                                  return (k2.length == 5)
                                      ? Card(
                                          margin: EdgeInsets.all(10),
                                          color: Colors.white.withOpacity(0.2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                ),
                                                //height: 100,
                                                width: width / 5,
                                                child: Image.asset(
                                                  "assets/images/person.png",
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 15),
                                                  //height: 100,
                                                  width: width / 1.4,
                                                  child: Column(
                                                    children: [
                                                      text(
                                                          k2[0]
                                                              .toString()
                                                              .substring(2),
                                                          14.0,
                                                          Colors.white
                                                              .withOpacity(0.9),
                                                          FontWeight.normal),
                                                      text(
                                                          "Nombre : ${k2[1].toString().split(":")[1]}",
                                                          14.0,
                                                          Colors.white
                                                              .withOpacity(0.9),
                                                          FontWeight.normal),
                                                      text(
                                                          "Genero :  ${k2[2].toString().split(":")[1]}",
                                                          14.0,
                                                          Colors.white
                                                              .withOpacity(0.9),
                                                          FontWeight.normal),
                                                      text(
                                                          "Edad :  ${k2[3].toString().split(":")[1]}",
                                                          14.0,
                                                          Colors.white
                                                              .withOpacity(0.9),
                                                          FontWeight.normal),
                                                      text(
                                                          "Fecha de registro :  ${k2[4].toString().split(":")[1]}",
                                                          14.0,
                                                          Colors.white
                                                              .withOpacity(0.9),
                                                          FontWeight.normal),
                                                      TextButton(
                                                          onPressed: () async {
                                                            String topic =
                                                                await pacTopic(k2[
                                                                        0]
                                                                    .toString()
                                                                    .substring(
                                                                        13));
                                                            print(
                                                                "*****************************");
                                                            print(topic.split(
                                                                    " ")[1] +
                                                                "ttttttopppic");
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                              return Gauges(
                                                                widget.idDoc,
                                                                k2[0]
                                                                    .toString()
                                                                    .substring(
                                                                        13),
                                                                topic
                                                                    .split(
                                                                        " ")[1]
                                                                    .replaceAll(
                                                                        "}]",
                                                                        ""),
                                                              );
                                                            }));
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0)),
                                                          child: text(
                                                              "Ver datos de monitoreo",
                                                              14.0,
                                                              Colors.amber,
                                                              FontWeight
                                                                  .normal))
                                                    ],
                                                  )),
                                            ],
                                          ))
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 30, left: 25, right: 25),
                                          child: Text(
                                            "No se ha encontrado información relacionada a la búsqueda. Intente de nuevo",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'kanit'),
                                            textAlign: TextAlign.justify,
                                          ));
                                },
                                    childCount: (snapshot.data.length >= 1)
                                        ? snapshot.data.length
                                        : 0),
                              )
                            ]),
                          )
                        ],
                      ),
                      Container(
                          height: 170,
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
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
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return Menu(widget.idDoc);
                                            }));
                                          },
                                          iconSize: 25,
                                          icon: Icon(Icons.arrow_back),
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90,
                                        child: Text(
                                          "Pacientes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "kanit",
                                              fontSize: 16,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  margin: EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Form(
                                            key: key,
                                            child: TextFormField(
                                              controller: bracelet,
                                              validator: (val) {
                                                if (val.isEmpty) {
                                                  return "Ingrese un codigo de pulsera";
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  hoverColor: Colors.white,
                                                  hintText:
                                                      "Buscar por codigo de pulsera",
                                                  errorStyle: TextStyle(
                                                      fontSize: 10.0,
                                                      color:
                                                          Colors.red.shade800,
                                                      fontFamily: "Kanit"),
                                                  //helperText: "Buscar por nombre o ID",
                                                  hintStyle: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontFamily: "Kanit")),
                                            ),
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (key.currentState.validate()) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return Pacientes(
                                                  idDoc: widget.idDoc,
                                                  list: pacInfo(widget.idDoc,
                                                      bracelet.value.text));
                                            }));
                                          }
                                        },
                                        child: Icon(Icons.search),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              }),
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

  Widget header(String idDoc) {
    return Container(
        height: 170,
        color: Colors.black.withOpacity(0.5),
        child: Center(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Menu(idDoc);
                          }));
                        },
                        iconSize: 25,
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white.withOpacity(0.8),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 90,
                      child: Text(
                        "Pacientes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "kanit",
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Form(
                          key: key,
                          child: TextFormField(
                            controller: bracelet,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Ingrese un codigo de pulsera";
                              }
                            },
                            decoration: InputDecoration(
                                hoverColor: Colors.white,
                                hintText: "Buscar por codigo de pulsera",
                                errorStyle: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.red.shade800,
                                    fontFamily: "Kanit"),
                                //helperText: "Buscar por nombre o ID",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontFamily: "Kanit")),
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        if (key.currentState.validate()) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Pacientes(
                                idDoc: widget.idDoc,
                                list: pacInfo(idDoc, bracelet.value.text));
                          }));
                        }
                      },
                      child: Icon(Icons.search),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
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
