import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as Http;

void main() {
  runApp(RadioIcetopeCatalogApp());
}

class RadioIcetopeCatalogApp extends StatefulWidget {
  @override
  _RadioIcetopeCatalogAppState createState() => _RadioIcetopeCatalogAppState();
}

class _RadioIcetopeCatalogAppState extends State<RadioIcetopeCatalogApp> {
  List<Element> elementList = [];
  String _endpoint = "https://periodic-table-api.herokuapp.com/";

  Future<void> fetch() async {
    Http.Response response = await Http.get(_endpoint);
    List raw = jsonDecode(response.body);

    for (Map<String, dynamic> element in raw) {
      setState(() {
        elementList.add(
          Element(
            mass: element["atomicMass"],
            number: element["atomicNumber"],
            symbol: element["symbol"],
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Element Catalog",
            style: GoogleFonts.inter(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HorizontalLine(),
            elementList.length != 0
                ? SizedBox(
                    height: 400,
                    width: 400,
                    child: Swiper(
                      itemCount: elementList.length,
                      itemBuilder: (context, i) {
                        return elementList[i];
                      },
                    ),
                  )
                : Container,
            SizedBox(),
          ],
        ),
      ),
    );
  }
}

class Element extends StatelessWidget {
  final String number;
  final String mass;
  final String symbol;

  Element({@required this.mass, @required this.number, @required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.width - 100,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: Stack(
        children: [
          Align(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            alignment: Alignment.topLeft,
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  symbol,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 110,
                  ),
                ),
                Text(
                  mass,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 1,
      width: double.infinity,
    );
  }
}
