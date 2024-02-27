import 'package:animation_list/animation_list.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/top_to_bottom_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubuckettask/modelos/proyectos.dart';
import 'package:ubuckettask/modelos/tareas.dart';
import 'package:ubuckettask/paginas/crear_proyecto_page.dart';
import 'package:ubuckettask/paginas/crear_tarea.dart';
import 'package:ubuckettask/paginas/detalle_proyecto_page.dart';
import 'package:ubuckettask/paginas/login_page.dart';
import 'package:ubuckettask/proveedores/proyecto_provider.dart';
import 'package:ubuckettask/proveedores/sistema_provider.dart';
import 'package:ubuckettask/proveedores/tareas_provider.dart';
import 'package:ubuckettask/widgets/dialog_pregunta.dart';
import 'package:ubuckettask/widgets/my_custom_animation.dart';
import '../globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isShowDial = false;
  bool mostrarMenu = false;
  Future? proyectos;
  Future? proyectosActivos;
  bool canastaAbiera = false;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => asyncInitState());
  }

  void asyncInitState() async {
    mostrarMenu = true;
    obtenerProyectos();
    obtenerProyectosAsignados();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  obtenerProyectos() {
    proyectos = ProyectoProvider().obtenerProyecosConTarea(globals.pkUsuario);
    setState(() {});
  }

  obtenerProyectosAsignados() {
    proyectosActivos = ProyectoProvider()
        .obtenerProyectosAsignadosPorFecha(globals.pkUsuario, dateTime);
    setState(() {});
  }

  double cartBarHeight = 80;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButton:
            mostrarMenu ? _getFloatingActionButton() : Container(),
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
                top: canastaAbiera
                    ? -(MediaQuery.sizeOf(context).height - cartBarHeight * 5)
                    : 0,
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title(),
                        const SizedBox(height: 10),
                        body(),
                        SizedBox(
                          height: cartBarHeight - 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  height: canastaAbiera
                      ? (MediaQuery.sizeOf(context).height - cartBarHeight)
                      : cartBarHeight,
                  width: MediaQuery.sizeOf(context).width,
                  bottom: 0,
                  child: BlurryContainer(
                    color: const Color.fromARGB(158, 0, 0, 0),
                    blur: 20,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: canastaAbiera ? barraAbierta() : barra(),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return FutureBuilder(
        future: proyectosActivos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data.mensaje;
            if (data.isNotEmpty) {
              return AnimationList(
                  padding: EdgeInsets.zero,
                  duration: 1000,
                  addRepaintBoundaries: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: data.map((e) => cartProyecto(e)).toList());
            } else {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * .50,
                child: Center(
                  child: Text(
                    dateTime.isBefore(DateTime.now())
                        ? "No hubo actividad este día"
                        : "Todavía no hay actividad para este día",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Galano',
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }

  Widget barraAbierta() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! < -0.7) {
                canastaAbiera = true;
                setState(() {});
              } else if (details.primaryDelta! > 12) {
                canastaAbiera = false;
                setState(() {});
              }
            },
            child: const Column(
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  "CANASTA DE TAREAS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Galano',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: proyectos,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data.mensaje;
                    return AnimationList(
                        padding: EdgeInsets.zero,
                        duration: 1000,
                        addRepaintBoundaries: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: data.map((e) => cartProyecto(e)).toList());
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget cartProyecto(Proyecto data) {
    return GestureDetector(
      onTapDown: (details) {
        double x = details.globalPosition.dx;
        double y = details.globalPosition.dy;
        double relativeX = (x / MediaQuery.of(context).size.width) * 2 - 1;
        double relativeY = (y / MediaQuery.of(context).size.height) * 2 - 1;
        Navigator.of(context)
            .push(
          MyCustomAnimatedRoute(
            coordenadaX: relativeX,
            coordenadaY: relativeY,
            enterWidget: DetalleProyectoPage(proyecto: data),
          ),
        )
            .then((value) {
          globals.estaCargando = false;
          if (value) {
            obtenerProyectos();
            obtenerProyectosAsignados();
          } else {
            setState(() {});
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 0),
            color: Color(int.parse("0xff${data.color}")),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.nombre!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Galano',
                  ),
                ),
                const Icon(Icons.arrow_outward_rounded)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              children: data.tareas!
                  .map((e) => canastaAbiera
                      ? tarea(e, () {
                          data.tareas!.removeWhere((element) => e == element);
                          setState(() {});
                        })
                      : GestureDetector(
                          onTap: () {
                            if (e.completada) {
                              TareasProvider()
                                  .asignarFecha(e.pkTarea!, dateTime);
                            } else {
                              TareasProvider().completarTarea(e.pkTarea!);
                            }
                            e.completada = !e.completada;
                            data.tareas!.sort((a, b) {
                              if (a.completada && !b.completada) {
                                return 1;
                              } else if (!a.completada && b.completada) {
                                return -1;
                              } else {
                                return 0;
                              }
                            });
                            setState(() {});
                          },
                          child: tareaCheck(e, () {
                            TareasProvider()
                                .liberarTarea(e.pkTarea!)
                                .then((value) => obtenerProyectos());

                            data.tareas!.removeWhere((element) => e == element);
                            setState(() {});
                          })))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget tarea(Tarea tarea, Function quitarTarea) {
    return GestureDetector(
      onTap: () {
        quitarTarea();
        TareasProvider().asignarFecha(tarea.pkTarea!, dateTime).then((value) {
          if (value["estado"]) {
            obtenerProyectosAsignados();
          } else {
            Fluttertoast.showToast(
                msg: value["mensaje"],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        });
      },
      child: Container(
          margin: const EdgeInsets.only(right: 5, top: 5),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
              color: const Color.fromARGB(117, 255, 255, 255),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            tarea.tarea!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Galano',
            ),
          )),
    );
  }

  Widget tareaCheck(Tarea tarea, Function eliminarArray) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            height: 23,
            width: 23,
            decoration: BoxDecoration(
                color: tarea.completada
                    ? const Color.fromARGB(157, 90, 90, 90)
                    : const Color.fromARGB(157, 255, 255, 255),
                borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 3,
            child: Text(tarea.tarea!,
                style: TextStyle(
                    decoration: tarea.completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 15,
                    overflow: TextOverflow.clip,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Container()),
          GestureDetector(
              onTap: () => eliminarArray(), child: const Icon(Icons.close))
        ],
      ),
    );
  }

  Widget barra() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -0.7) {
          canastaAbiera = true;
          setState(() {});
        } else if (details.primaryDelta! > 12) {
          canastaAbiera = false;
          setState(() {});
        }
      },
      child: Column(
        key: UniqueKey(),
        children: const [
          Icon(
            Icons.keyboard_arrow_up_rounded,
            color: Colors.white,
            size: 40,
          ),
          Text(
            "CANASTA DE TAREAS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Galano',
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      isShowSpeedDial: _isShowDial,
      updateSpeedDialStatus: (isShow) {
        _isShowDial = isShow;
      },
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          backgroundColor: Colors.white,
          mini: true,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {},
          closeMenuChild: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          closeMenuForegroundColor: Colors.white,
          closeMenuBackgroundColor: Colors.white),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        FloatingActionButton(
          heroTag: "uno",
          key: UniqueKey(),
          mini: false,
          onPressed: () {
            _isShowDial = false;
            setState(() {});
            Navigator.of(context)
                .push(
              CupertinoBottomSheetRoute(
                args: const CupertinoBottomSheetRouteArgs(
                  maintainState: true,
                  scaffoldBackgroundColor: Colors.black,
                  shadeColor: Colors.black,
                  swipeSettings: SwipeSettings(
                    canCloseBySwipe: false,
                    onlySwipesFromEdges: false,
                  ),
                ),
                builder: (context) {
                  return const CrearTareaPage();
                },
              ),
            )
                .then((value) {
              globals.estaCargando = false;
              obtenerProyectos();
            });
          },
          backgroundColor: Colors.white,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                color: Colors.black,
              ),
              Text(
                "Nueva tarea",
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        FloatingActionButton(
          heroTag: "dos",
          key: UniqueKey(),
          mini: false,
          onPressed: () {
            _isShowDial = false;
            setState(() {});
            Navigator.of(context)
                .push(
              CupertinoBottomSheetRoute(
                args: const CupertinoBottomSheetRouteArgs(
                  maintainState: true,
                  scaffoldBackgroundColor: Colors.black,
                  shadeColor: Colors.black,
                  swipeSettings: SwipeSettings(
                      canCloseBySwipe: true,
                      interactiveEdgeWidth: 500,
                      onlySwipesFromEdges: true,
                      velocityThreshhold: 1),
                ),
                builder: (context) {
                  return const CrearProyectoPage();
                },
              ),
            )
                .then((value) {
              globals.estaCargando = false;
              obtenerProyectos();
            });
          },
          backgroundColor: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.black,
                ),
                Text(
                  "Nuevo proyecto",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
      isSpeedDialFABsMini: false,
      isEnableAnimation: false,
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: PopupMenuButton<String>(
                iconSize: 20,
                onSelected: (value) {
                  if (value == 'Cerrar sesión') {
                    CustomDialogPreguntaEliminar.show(
                        context, "¿Deseas cerrar sesión?", () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      globals.userName = '';
                      globals.correo = '';
                      globals.pkUsuario = 0;
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(PageAnimationTransition(
                          page: const LoginPage(),
                          pageAnimationType: TopToBottomTransition()));
                    });
                  } else if (value == 'Eliminar cuenta') {
                    CustomDialogPreguntaEliminar.show(
                        context, "¿Deseas eliminar tu cuenta ?", () async {
                      SitemaProvider()
                          .eliminarCuenta(globals.pkUsuario)
                          .then((value) async {
                        if (value["estado"]) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          globals.userName = '';
                          globals.correo = '';
                          globals.pkUsuario = 0;
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(PageAnimationTransition(
                              page: const LoginPage(),
                              pageAnimationType: TopToBottomTransition()));
                        } else {
                          Fluttertoast.showToast(
                              msg: value["mensaje"],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      });
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Cerrar sesión', 'Eliminar cuenta'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: const TextStyle(
                          fontFamily: 'Galano',
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hola 👋 ${globals.userName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Galano',
                ),
              ),
              const Text(
                "¿Cuál es el plan de hoy?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Galano',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      dateTime = dateTime.subtract(const Duration(days: 1));
                      obtenerProyectosAsignados();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('EEEE d MMMM ', 'es')
                          .format(dateTime)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      dateTime = dateTime.add(const Duration(days: 1));
                      obtenerProyectosAsignados();
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
