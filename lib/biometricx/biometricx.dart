import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:local_auth/local_auth.dart';

class biometricxclass {
  biometricxclass._();
  static final biometricxclass Auth = biometricxclass._();
  final LocalAuthentication auth = LocalAuthentication();

  CheckBio() async {
    bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      log(canAuthenticateWithBiometrics.toString());
      log(canAuthenticate.toString());
      log(availableBiometrics.toString());
    }
  }
}

class biometricx extends StatefulWidget {
  const biometricx({Key? key}) : super(key: key);

  @override
  State<biometricx> createState() => _biometricxState();
}

class _biometricxState extends State<biometricx> {
  final TextUtils _textUtils = TextUtils();
  bool _checkBio = false;
  bool _isBioFinger = false;
  LocalAuthentication _authentication = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkbiometricx();
    _listBioAndFindFingerType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:_startAuth,
            icon: Icon(
              Icons.fingerprint,
              size: 50,
            ),
            iconSize: 60,
          ),
          SizedBox(
            height: 10,
          ),
          _textUtils.bold14("Enter Password & Fingerprint", Colors.black)
        ],
      ),
    );
  }

  void checkbiometricx() async {
    try {
      final bio = await _authentication.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
      });
      log("biometricx = $_checkBio");
    } catch (e) {}
  }

  void _listBioAndFindFingerType() async {
    List<BiometricType> _listType = [];
    try {
      _listType = await _authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      log(e.message.toString());
    }
    log("List Of biometricx = $_listType");
    if (_listType.contains(BiometricType.fingerprint) ||
        _listType.contains(BiometricType.strong)) {
      setState(() {
        _isBioFinger = true;
      });
      log("Fingerprint is $_isBioFinger");
    }
  }

  void _startAuth() async {
    bool _isAuthenticated = false;
    try {
      _isAuthenticated = await _authentication.authenticate(
          localizedReason: 'Scan Your Fingerprint',
          options: AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          ));
    } on PlatformException catch (e) {
      log(e.message.toString());
    }
    if (_isAuthenticated) { 
      Navigator.of(context).pop();
      CustomToast().successToast(context: context, text: "Fingerprint is Work = $_isAuthenticated");
    }
  }
}
