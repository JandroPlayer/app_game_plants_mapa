import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/models.dart';
import 'package:flutter_loggin/pagines/items/defensa_buy_page.dart';
import 'package:flutter_loggin/pagines/items/food_buy_page.dart';
import 'package:flutter_loggin/pagines/items/water_buy_page.dart';
import 'package:flutter_loggin/pagines/paginaGame/batalla.dart';
import 'package:flutter_loggin/pagines/pagines.dart';
import 'package:flutter_loggin/pagines/loggings_logouts_register/login.dart';
import 'package:flutter_loggin/pagines/loggings_logouts_register/registre.dart';
import 'package:flutter_loggin/pagines/shop.dart';
import 'package:flutter_loggin/widgets/widgets.dart';
import 'package:flutter_loggin/pagines/game_individual.dart';
import 'package:flutter_loggin/pagines/mapa_plants.dart';

class Rutes {
  static const String paginaPrincipal = '/';
  static const String paginaLoggin = '/Loggin';
  static const String paginaRegistre = '/Registre';
  static const String home = '/Home';
  static const String perfilUsuari = '/Perfil';
  static const String game = '/Game';
  static const String plantaDetail = '/PlantaDetail'; // Nueva ruta
  static const String batalla = '/batalla';
  static const String shop = '/Shop';
  static const String gameTEST = '/gameTEST';
  static const String buywater = '/Buywaterpage';
  static const String buyfood = '/buyfood';
  static const String buydefensa = '/buydefensa';
  static const String mapa = '/mapa';

  // Definimos las rutas sin pasar parámetros aquí
  static Map<String, WidgetBuilder> obtenerRutas() {
    return {
      paginaPrincipal: (BuildContext context) => const Paginaprincipal(),
      paginaLoggin: (BuildContext context) => Loggin(),
      paginaRegistre: (BuildContext context) => const Registre(),
      home: (BuildContext context) => const Home(),
      perfilUsuari: (BuildContext context) => const PerfilUsuari(),
      game: (BuildContext context) => const Game(),
      batalla: (BuildContext context) => const Batalla(),
      shop: (BuildContext context) => const ShopPage(),
      gameTEST: (BuildContext context) => const Gametest(),
      buywater: (BuildContext context) => BuyWaterPage(),
      buyfood: (BuildContext context) => BuyFoodPage(),
      buydefensa: (BuildContext context) => BuyDefensaPage(),
      plantaDetail: (BuildContext context) => Plantadetall(
          planta: ModalRoute.of(context)!.settings.arguments as Planta),
          mapa: (BuildContext context) => MapaPlants(
          usuari: ModalRoute.of(context)!.settings.arguments as Usuari), // Nueva ruta
    };
  }

  // Definimos las rutas con parámetros aquí
  static void navegarHome(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      home,
      arguments: usuari,
    );
  }

  static void navegarPerfilUsuari(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      perfilUsuari,
      arguments: usuari,
    );
  }

  static void navegarGame(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      game,
      arguments: usuari,
    );
  }

  // Nueva función para navegar a PlantaDetailPage
  static void navegarPlantaDetail(BuildContext context, Planta planta) {
    Navigator.pushNamed(
      context,
      plantaDetail,
      arguments: planta,
    );
  }

  static void navegarShop(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      shop,
      arguments: usuari,
    );
  }

  static void naveegarGameTEST(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      gameTEST,
      arguments: usuari, // ✅ Passar el Usuari correctament
    );
  }

  static void navegarBuyWater(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      buywater,
      arguments: usuari,
    );
  }

  static void navegarBuyFood(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      buyfood,
      arguments: usuari,
    );
  }

  static void naveegarBuyDefensa(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      buydefensa,
      arguments: usuari,
    );
  }

   // Nueva función para navegar a MapaPage
  static void navegarMapa(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      mapa,
      arguments: usuari,
    );
  }
}
