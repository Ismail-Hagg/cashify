import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

void main() {
  // Create a window manager instance.

  // Set the minimum and maximum size of the window.
  // WindowManager.instance.setMinimumSize(const Size(200, 200));
  // WindowManager.instance.setMaximumSize(const Size(400, 400));

  runApp(const MyApp());

  // doWhenWindowReady(() {
  //   const initialSize = Size(600, 450);
  //   appWindow.minSize = initialSize;
  //   appWindow.size = initialSize;
  //   appWindow.alignment = Alignment.center;
  //   appWindow.show();
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void sheeting() async {
    var cred = {
      "type": "service_account",
      "project_id": "flutter-sheets-399309",
      "private_key_id": "7635b7d4515986f3efe1147f4f98d71ec57b2a15",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkxEmHJU8Zn1M5\nbZSLifAuI4OLXWXTBIWlVtrih0QT5mouPRiTzdrEL5gVlroqO1FsHmb29gNP13Cc\nm3MeDFRZd3TITyYV84awNw3tAqzz6KTowEAvS3fj3NHliLonJg6zW4Qxh5NReWSe\n+7TVCavzgwDDkUSp+LNJdVzu0MOoy3PVU/kOC8nWwNgUyFlC2+cwcEmFTWzUlsO/\nG9TAQKEe6O3wm02vDUw6q/ZGnFi4W9waWs/PcCn15z9u+PWE3UO2wkkpkY9jf5Fg\nDJc4HqaPQyXikKia8kj/kyQcCzBB0ztkHnPOwRZktIKz6wCcWprZKHBv6J4JNb5q\nSqwZxVXfAgMBAAECggEAOZOkFBdsCEqeRQuvZIGbziu33JwTKIXEhA4RaCaXmhKj\nGSxdacz+PR9amHS28moPHmaTWYqHhr+EyR0jQaVSVn9BbnwGFZangu2CLsgIEyXB\ndtozs7M+HoC8UmcQkfyhF3kL/VjgmJCAonPX8bgy/+HQAwdBBNp1IF7kTknijZmW\n0geQiBrv2r+K9xa2ySDy6HFkPZc1g2dvjmt2oBxEOEx+bIStA2+VHUUH1EZDHJQO\n2/LsbazuRmRiLuXl6u43Wcs+8yBT/+s9jD/Yg1iafE1ZnkXYPAoBFVY9fpciG24v\n8XAAmaLkFmYcBqn5GZObyjTJ3TS6nPTBGfqRfDj0gQKBgQDikhE9snGSvJ7+jAjh\nk9Xtm5wJrFvH0CzCw8cEcj0jwXK1VbCEV/CEKC7QULigoOnS3ini51hykgr+OXal\no3/sC1kaBxa7uHNtcxmb+j1jcRRy0vpdYSr6udZbS4IcjewAa/nAJ7wdjAGl5Omp\n3RgcE+Ad6wzNZ8uiJoObIoc6gQKBgQC6Kx3nfOW4NZ7uv8bXTJFZ6s8tkMWRP0S4\nEqeVPNyaLpmWN7346Ieq/ladlO2I8Xn3wI5OBcuDr9Ie6SvlBINoM8HXlm3kYe7a\nga7syTjI3J+cx/lCyv+0XC4LgCxVfILtxq+AnFgf/slcFlyppRbIrwUg9cOcQKPI\nxAqLZgagXwKBgFPdASi3HjbUPn2106u7jtnOWWlzNN22/npxAP9yUZMkjZL1TssN\nyecBAKL23gAGz8XPme10+FYgHJWRK4uQA0+Zu7dYnF+LnJ4MlpQXghWGy6zczvM1\nfjUkCGXugxCSr6JQVTd8/bJqGkoPezX2sm/iI3ivgiOdodA5NUl89FUBAoGBAIb8\n/JH9XhRTzQoQxH0YZ8xrFg5UCu1mks1luV3c45hocbUadgUlljnGcceRVSsW7PlY\nBddNHGQ/+HuxVsKYoy/LV6Ka0NPoruiBX/URcrsyPgnQdkyYJRECReDQ71SNE+KV\nTmxS8RNCC39aN5ZKvlqFjZJ4oX2K4TeR7pNlRyjBAoGACQVsHmn6ZCUZZkXwhUCN\nr7BSaAsQT7ZVoUPjc+ei749NDJmYAn66GtJAJm3tqQMVxTlQNDAsFS4LFbZYQr06\niILroHWt5JP1NBk1Ff4Ja5DI62Y4edVvdErXDI+ZDTTPSVgqHBtjc90Qj51TXdBF\nEniccQZGDYlyY2UHzwCatR8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "flutter-sheets@flutter-sheets-399309.iam.gserviceaccount.com",
      "client_id": "104817425876878210036",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/flutter-sheets%40flutter-sheets-399309.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    var spreadId = '1DAUZ7de9U0qISiqWZOZG8vVTcQ8PtxVZzuXQHU8uIPc';
    print('thing');
    try {
      print('try');
      final GSheets gsheet = GSheets(cred);
      final ss = await gsheet.spreadsheet(spreadId);
      var sheet = ss.worksheetByTitle('money');
      await sheet!.values.allColumns().then((value) => print(value));

      //await sheet!.values.insertValue('thing', column: 1, row: 1);
    } catch (e) {
      print('catch');
      print('==========$e=========');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        // WindowManager.instance.setMinimumSize(const Size(200, 200));
        // WindowManager.instance.setMaximumSize(const Size(400, 400));
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              defaultTargetPlatform.toString(),
            ),
            const Flexible(
                child: FractionallySizedBox(
              heightFactor: 0.2,
            )),
            Text(
              'width is : ${constraints.maxWidth}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'height is : ${constraints.maxHeight}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: sheeting,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
