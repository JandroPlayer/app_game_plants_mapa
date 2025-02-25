// La classe `CardSwiper` mostra una sèrie de criptomonedes utilitzant un swiper que permet desplaçar-se entre elles. Cada card inclou la imatge de la criptomoneda i la seva variació de preu en les últimes 24 hores. En clicar sobre una card, es navega a la pàgina de detalls de la criptomoneda seleccionada.

import 'package:flutter/material.dart';
import 'package:flutter_loggin/widgets/card_swiper.dart';
import 'package:flutter_loggin/models/crypto.dart';
import 'package:flutter_loggin/pagines/crypto_detail_page.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class CardSwiper extends StatelessWidget {
  final List<Crypto> cryptos;

  const CardSwiper({Key? key, required this.cryptos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: MediaQuery.of(context).orientation == Orientation.portrait
            ? const EdgeInsets.only(
                top: 15.0) // Padding condicional en mode retrat
            : const EdgeInsets.all(8.0), // Padding complet en mode horitzontal
        child: SizedBox(
          height: 300, // Aumentem l'altura per ajustar els elements
          child: Swiper(
            itemCount: cryptos.length,
            layout: SwiperLayout.DEFAULT, // Cambiaem a diseny predeterminatA
            itemWidth: MediaQuery.of(context).size.width * 0.7,
            itemHeight: 250,
            itemBuilder: (BuildContext context, int index) {
              final crypto = cryptos[index];

              // Determinem el color segons la variació de preu en 24 Hores
              final priceChange = crypto.priceChangePercentage24h;
              final priceChangeColor =
                  priceChange > 0 ? Colors.green : Colors.red;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CryptoDetailsPage(crypto: crypto),
                    ),
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(crypto.image),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          // height: MediaQuery.of(context).size.height * 0.3,
                          // Reduït per evitar overflow
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  '${crypto.name}',
                                  style: const TextStyle(
                                    color: Color(0xFF00C4B4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),
                                Text(
                                  '${crypto.currentPrice}\$',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${crypto.priceChangePercentage24h}% 24h',
                                  style: TextStyle(
                                    color: priceChangeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            autoplay: true, // Permitim el desplaçament automatic
            autoplayDelay: 4000,
            curve: Curves.easeInOut, // Apliquem una curva de transició suau
            onIndexChanged: (index) {
              // Podem afegir alguna cosa en cada canvi
            },
          ),
        ),
      ),
    );
  }
}
