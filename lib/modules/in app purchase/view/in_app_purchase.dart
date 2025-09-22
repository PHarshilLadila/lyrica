// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:lyrica/common/widget/app_text.dart';

class InApp extends StatefulWidget {
  const InApp({super.key});

  @override
  _InAppState createState() => _InAppState();
}

class _InAppState extends State<InApp> {
  bool _iapReady = false;

  StreamSubscription? _purchaseUpdatedSubscription;

  late dynamic _purchaseErrorSubscription;
  late dynamic _connectionSubscription;
  final List<String> _productLists =
      Platform.isAndroid
          ? [
            'android.test.purchased',
            'point_1000',
            '5000_point',
            'android.test.canceled',
          ]
          : ['com.cooni.point1000', 'com.cooni.point5000'];

  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (_connectionSubscription != null) {
      _connectionSubscription.cancel();
      _connectionSubscription = null;
    }
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      var result = await FlutterInappPurchase.instance.initialize();
      debugPrint('IAP Initialized: $result');
      _iapReady = true;
    } catch (e) {
      debugPrint('IAP Init Error: $e');
      _iapReady = false;
      return;
    }

    if (!mounted) return;

    try {
      await FlutterInappPurchase.instance.consumeAll();
    } catch (err) {
      debugPrint('consumeAllItems error: $err');
    }

    _connectionSubscription = FlutterInappPurchase.connectionUpdated.listen((
      connected,
    ) {
      debugPrint('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((
      productItem,
    ) {
      debugPrint('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((
      purchaseError,
    ) {
      debugPrint('purchase-error: $purchaseError');
    });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  Future _getProduct() async {
    if (!_iapReady) {
      debugPrint('IAP not ready');
      return;
    }
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(
        _productLists,
      );
      setState(() {
        _items = items;
        _purchases = [];
      });
    } catch (e) {
      debugPrint('Get Products Error: $e');
    }
  }

  Future _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      debugPrint(item.toString());
      _purchases.add(item);
    }

    setState(() {
      _items = [];
      _purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      debugPrint(item.toString());
      _purchases.add(item);
    }

    setState(() {
      _items = [];
      _purchases = items;
    });
  }

  List<Widget> _renderInApps() {
    List<Widget> widgets =
        _items
            .map(
              (item) => Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: AppText(
                        text: item.toString(),
                        fontSize: 18.0,
                        textColor: Colors.black,
                      ),
                    ),
                    MaterialButton(
                      color: Colors.orange,
                      onPressed: () {
                        debugPrint("---------- Buy Item Button Pressed");
                        _requestPurchase(item);
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 48.0,
                              alignment: Alignment(-1.0, 0.0),
                              child: AppText(text: 'Buy Item'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
    return widgets;
  }

  List<Widget> _renderPurchases() {
    List<Widget> widgets =
        _purchases
            .map(
              (item) => Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: AppText(
                        text: item.toString(),
                        fontSize: 18.0,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double buttonWidth = (screenWidth / 3) - 20;

    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AppText(
                text:
                    'Running on: ${Platform.operatingSystem} - ${Platform.operatingSystemVersion}\n',
                fontSize: 18.0,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: buttonWidth,
                        height: 60.0,
                        margin: EdgeInsets.all(7.0),
                        child: MaterialButton(
                          color: Colors.amber,
                          padding: EdgeInsets.all(0.0),
                          onPressed: () async {
                            debugPrint(
                              "---------- Connect Billing Button Pressed",
                            );
                            await FlutterInappPurchase.instance.initialize();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: Alignment(0.0, 0.0),
                            child: AppText(
                              text: 'Connect Billing',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: buttonWidth,
                        height: 60.0,
                        margin: EdgeInsets.all(7.0),
                        child: MaterialButton(
                          color: Colors.amber,
                          padding: EdgeInsets.all(0.0),
                          onPressed: () async {
                            debugPrint(
                              "---------- End Connection Button Pressed",
                            );
                            await FlutterInappPurchase.instance.finalize();
                            if (_purchaseUpdatedSubscription != null) {
                              _purchaseUpdatedSubscription?.cancel();
                              _purchaseUpdatedSubscription = null;
                            }
                            if (_purchaseErrorSubscription != null) {
                              _purchaseErrorSubscription.cancel();
                              _purchaseErrorSubscription = null;
                            }
                            setState(() {
                              _items = [];
                              _purchases = [];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: Alignment(0.0, 0.0),
                            child: AppText(
                              text: 'End Connection',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: buttonWidth,
                        height: 60.0,
                        margin: EdgeInsets.all(7.0),
                        child: MaterialButton(
                          color: Colors.green,
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            debugPrint("---------- Get Items Button Pressed");
                            _getProduct();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: Alignment(0.0, 0.0),
                            child: AppText(text: 'Get Items', fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: buttonWidth,
                        height: 60.0,
                        margin: EdgeInsets.all(7.0),
                        child: MaterialButton(
                          color: Colors.green,
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            debugPrint(
                              "---------- Get Purchases Button Pressed",
                            );
                            _getPurchases();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: Alignment(0.0, 0.0),
                            child: AppText(
                              text: 'Get Purchases',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: buttonWidth,
                        height: 60.0,
                        margin: EdgeInsets.all(7.0),
                        child: MaterialButton(
                          color: Colors.green,
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            debugPrint(
                              "---------- Get Purchase History Button Pressed",
                            );
                            _getPurchaseHistory();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: Alignment(0.0, 0.0),
                            child: AppText(
                              text: 'Get Purchase History',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(children: _renderInApps()),
              Column(children: _renderPurchases()),
            ],
          ),
        ],
      ),
    );
  }
}
