import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../controllers/product_controller.dart';

class OrderDetailss extends StatefulWidget {
  OrderDetailss({
    super.key,
  });

  @override
  State<OrderDetailss> createState() => _OrderDetailssState();
}

class _OrderDetailssState extends State<OrderDetailss> {
  @override
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var _session, _uri, _signature;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  // signMessageWithMetamask(BuildContext context, String message) async {
  //   if (connector.connected) {
  //     try {
  //       print("Message received");
  //       print(message);
  //
  //       EthereumWalletConnectProvider provider =
  //           EthereumWalletConnectProvider(connector);
  //       launchUrlString(_uri, mode: LaunchMode.externalApplication);
  //       var signature = await provider.personalSign(
  //           message: message, address: _session.accounts[0], password: "");
  //       print(signature);
  //       setState(() {
  //         _signature = signature;
  //       });
  //     } catch (exp) {
  //       print("Error while signing transaction");
  //       print(exp);
  //     }
  //   }
  // }

  sendingTransaction(BuildContext context) async {
    if (connector.connected) {
      try {
        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(_uri, mode: LaunchMode.externalApplication);
        var res = await provider.sendTransaction(
          to: "0x283b644c319cCa9396c9C8C72bd5B9FdBc0b9f8C",
          from: _session.accounts[0],
          value: BigInt.from(1000000000000000000),
        );
        print(res);
      } catch (exp) {
        print("Error while sending transaction");
        print(exp);
      }
    }
  }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      case 997:
        return 'Fire';
      default:
        return 'Unknown Chain';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loginUsingMetamask(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    String sess = "";
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
                sess = _session.accounts[0];
                print("sessionn Connected:- ${_session}");
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              // print("sessionn Connected );
              print(_session.accounts[0]);
              print(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 252, 240),
      appBar: AppBar(
        title: Text("Order Details",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 300,
                margin: EdgeInsets.only(top: 40, left: 8),
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                    color: Color.fromARGB(26, 135, 135, 42),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: <Widget>[
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartController.ItemLength.length,
                      itemBuilder: (context, index) {
                        String key =
                            cartController.ItemLength.keys.elementAt(index);
                        if (cartController.ItemLength[key] > 0) {
                          return Container(
                            // height: 50,
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              // color: Colors.amber,
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.5,
                                    color: Color.fromARGB(255, 194, 192, 192)),
                              ),
                              // borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  width: 120,
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      color: Colors.green[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                ),
                                Container(
                                  width: 50,
                                  child: Text(
                                      cartController.ItemLength[key].toString(),
                                      style: TextStyle(
                                          color: Colors.green[500],
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 20,
                                  child: Container(),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      // height: 50,

                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 100,
                              child: Text("Total Amount",
                                  style: TextStyle(
                                      color: Colors.green[500],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20))),
                          SizedBox(
                            width: 150,
                          ),
                          Text(cartController.total.toString(),
                              style: TextStyle(
                                  color: Colors.green[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25))
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 8),
            height: 80,
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color: Colors.green[500],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _session != null
                    ? Text(
                        "Account:- " + _session.accounts[0],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    : Text(
                        "Not Connected",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                _session != null
                    ? Text("Chain:- " + getNetworkName(_session.chainId),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500))
                    : Text("Network Not supported",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20, left: 8),
              height: 50,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: (() => {
                      sendingTransaction(context),
                      cartController.increaseCredit(),
                      print(cartController.credits)
                    }),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Pay with 5ire",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
