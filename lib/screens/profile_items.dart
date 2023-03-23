import 'package:badges/badges.dart';
import 'package:client/screens/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../controllers/product_controller.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileItems extends StatefulWidget {
  const ProfileItems({super.key});

  @override
  State<ProfileItems> createState() => _ProfileItemsState();
}

class _ProfileItemsState extends State<ProfileItems> {
  Future<void> logout() async {
    // await auth.signOut().then((value) => Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const SplashScreen())));
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen())));
  }

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
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;

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
    final cartController = Get.put(CartController());
    return Column(
      children: [
        Container(
          height: 45,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ).copyWith(
            bottom: 20,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade300,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.wallet,
                    size: 25,
                  ),
                  SizedBox(width: 15),
                  Text(
                    cartController.credits.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_bag,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "My Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.badge_rounded,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "My Badges",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.yard,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Badge(
                      position: BadgePosition.topEnd(top: -8, end: -35),
                      badgeStyle: BadgeStyle(
                          shape: BadgeShape.square,
                          badgeColor: Colors.amber,
                          padding: EdgeInsets.all(0),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      badgeContent: Text(
                        " Beta ",
                        style: TextStyle(fontSize: 11),
                      ),
                      child: Text("NFT's"),
                    ),
                    // Text(
                    //   "NFT's",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    // ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.wallet,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Connect Wallet",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            logout();
          },
          child: Container(
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.logout_rounded,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
