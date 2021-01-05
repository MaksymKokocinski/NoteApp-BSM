import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'homescreen.dart';

class BiometricPage extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

          if (weCanCheckBiometrics) {
            bool authenticated = await localAuth.authenticateWithBiometrics(
              localizedReason: "Authenticate to see your notes.",
            );

            if (authenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.fingerprint,
              color: Colors.lightBlue,
              size: 124.0,
            ),
            Text(
              "Touch to Login",
              style: TextStyle(color: Colors.lightBlue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
