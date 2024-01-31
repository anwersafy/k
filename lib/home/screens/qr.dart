import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                _buildQrView(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton( onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    }, icon: FutureBuilder(future: controller?.getFlashStatus(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return Icon(
                        snapshot.data == true ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      );

                    },),),

                    SizedBox(width: 16),
                    IconButton(onPressed: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    }, icon: FutureBuilder(
                      future: controller?.getCameraInfo(),

                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data != null) {
                          return Icon(
                            Icons.switch_camera,
                            color: Colors.white, )
                          ;
                        } else {
                          return const Text('loading');
                        }
                      },
                    )
                    ),

                  ],
                ),

              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                  Text(
                    'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                    style: TextStyle(fontSize: 18),
                  )
                else
                  const Text(
                    'Scan a code',
                    style: TextStyle(fontSize: 16,
                      color: Colors.red,


                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

