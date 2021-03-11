import 'dart:async';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final dynamic product;

  ProductPage({Key key, @required this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String productName = widget.product[0];
    String productBarcode = widget.product[1].toString();
    String productPrice = widget.product[2].toString();
    String productImage = widget.product[3];

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: Row(
            children: [
              Expanded(
                  child: Text(
                productName,
                style: TextStyle(fontSize: 16.0),
              )),
              SizedBox(
                width: 5.0,
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          child: Image.network(productImage, fit: BoxFit.fill),
                        ),
                        width: 100.0,
                        height: 100.0,
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
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: SelectableText(
                          productName,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          '₹ ' + productPrice,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      productBarcode != ''
                          ? Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: Colors.orangeAccent,
                                    size: 24.0,
                                  ),
                                  SizedBox(width: 5.0),
                                  SelectableText(
                                    productBarcode,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
