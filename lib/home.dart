import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/csv/products.csv");
    List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
    _listData.removeAt(0);
    setState(() {
      products = _listData;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcode() async {
    String code = '', error = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      code = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      error = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {});

    if (code != '') {
      print("Barcode Number " + code);
      _findProductByCode(code);
    }
  }

  void _findProductByCode(String code) {
    if (code != '-1') {
      var index =
          products.indexWhere((product) => product[1].toString() == code);
      if (index > -1) {
        var product = products[index];
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pushNamed(context, '/product', arguments: product);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Product with code " + code + " not found.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products Scanner'),
          actions: [
            SizedBox(
              width: 70.0,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.orangeAccent,
                  size: 30.0,
                ),
                onPressed: () => scanBarcode(),
              ),
            )
          ],
        ),
        body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (_, index) {
              var product = products[index];
              String productName = product[0];
              double productPrice = product[2];
              String productImage = product[3];
              return Container(
                  padding: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/product',
                          arguments: product);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.only(right: 10.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                child: Image.network(productImage,
                                    fit: BoxFit.fill),
                              ),
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 0),
                                      blurRadius: 10.0,
                                    )
                                  ]),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      productName,
                                      style: TextStyle(fontSize: 14.0),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Text('₹ ' + productPrice.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ));
            }));
  }
}
