import 'package:app_feb18/user_page/bloc/listacuenta_bloc.dart';
import 'package:app_feb18/user_page/bloc/picture_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'circular_button.dart';
import 'cuenta_item.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  ScreenshotController screenshotController = ScreenshotController();
  var featureOverflowMode = OverflowMode.clipContent;
  var featureEnablePulsingAnimation = false;

  Future _captureAndShare() async {
    screenshotController.capture().then((image) async {
      if (image != null){
        final directory = await getTemporaryDirectory();
        // File path = await File('${directory.path}/capture.jpg').create();

        Share.shareFiles(['${directory.path}/capture.jpg']);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: 'feature_screenshot',
              tapTarget: const Icon(Icons.share),
              title: Text('Captura de pantalla'),
              description: Text('Pulsa este boton para tomar una screenshot de la pantalla'),
              backgroundColor: Color.fromARGB(255, 110, 175, 231),
              targetColor: Colors.white,
              textColor: Colors.white,
              overflowMode: OverflowMode.extendBackground,
              contentLocation: ContentLocation.below,
              onComplete: () async {
                print("screenShot presionado");
                return true;
              },
              onDismiss: () async {
                print("screenShot dismissed");
                return false;
              },
              onOpen: () async {
                print("screenShot sera abierto");
                return true;
              },
              child: IconButton(
                tooltip: "Compartir pantalla",
                onPressed: () async {
                  await _captureAndShare();
                },
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlocConsumer<PictureBloc, PictureState>(
                listener: (context, state) {
                  if (state is PictureErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${state.errorMsg}"),
                          backgroundColor: Colors.red,));
                  }
                },
                builder: (context, state) {
                  if (state is PictureSelectedState) {
                    return CircleAvatar(
                      backgroundImage: FileImage(state.picture),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else if (state is PictureErrorState) {
                    return CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.black,
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                "Bienvenido",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text("Usuario${UniqueKey()}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DescribedFeatureOverlay(
                    featureId: 'feature_ver_tarjeta',
                    tapTarget: const Icon(Icons.credit_card),
                    title: Text('Ver tarjetas'),
                    description: Text('Pulsa este boton para ver informacion sobre la tarjeta'),
                    backgroundColor: Color.fromARGB(255, 29, 93, 150),
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    overflowMode: OverflowMode.extendBackground,
                    contentLocation: ContentLocation.above,
                    onComplete: () async {
                      print("ver tarjeta presionado");
                      return true;
                    },
                    onDismiss: () async {
                      print("ver tarjeta dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("Ver tarjeta sera abierto");
                      return true;
                    },
                    child: CircularButton(
                      textAction: "Ver tarjeta",
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action:null,
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'feature_cambiar_foto',
                    tapTarget: const Icon(Icons.camera_alt),
                    title: Text("Cambiar la foto"),
                    description: Text("Pulsa este boton para cambiar la foto"),
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    overflowMode: OverflowMode.extendBackground,
                    contentLocation: ContentLocation.trivial,
                    onComplete: () async {
                      print("ver foto presionado");
                      return true;
                    },
                    onDismiss: () async {
                      print("ver foto dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("Ver foto sera abierto");
                      return true;
                    },
                    child: CircularButton(
                      textAction: "Cambiar foto",
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'feature_ver_video',
                    backgroundColor: Colors.green,
                    contentLocation: ContentLocation.below,
                    title: const Text("Video tutorial de la app"),
                    tapTarget: const Icon(Icons.add),
                    overflowMode: OverflowMode.extendBackground,
                    onComplete: () async {
                      print("ver tutorial presionado");
                      return true;
                    },
                    onDismiss: () async {
                      print("ver tutorial dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("Ver tutorial sera abierto");
                      return true;
                    },
                    child: CircularButton(
                      textAction: "Ver tutorial",
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: (){
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String> {
                            'feature_ver_video',
                            'feature_cambiar_foto',
                            'feature_ver_tarjeta',
                            'feature_screenshot'
                          }
                        );
                      },
                      
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),
              BlocConsumer<ListacuentaBloc, ListacuentaState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is ListcuentaReady){
                    // return Text("aaaaaaa");
                    //ListView dentro de una columna 
                    return Expanded(
                      child: ListView.builder(
                      itemCount: (state.mapaCuenta["cuentas"] as List).length,
                      itemBuilder: (BuildContext context, int index) {
                        return CuentaItem(
                          tipoCuenta: state.mapaCuenta["cuentas"][index]["cuenta"].toString(),
                          terminacion: (state.mapaCuenta["cuentas"][index]["tarjeta"]).toString().substring(5),
                          saldoDisponible: (state.mapaCuenta["cuentas"][index]["dinero"]).toString(),
                          );
                          
                      },
                                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
    
                  }
                  
                },
              ),
              
            ],
          ),
          
        ),
      ),
    );
  }
}
