// La classe `CryptoSlider` crea un carrousel automàtic per mostrar criptomonedes. Utilitza un `PageView` amb un `PageController` per canviar entre les criptomonedes de manera automàtica cada 3 segons. Cada element del carrousel és un `GestureDetector` que, en ser tocat, redirigeix a la pàgina de detalls de la criptomoneda seleccionada.

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/crypto.dart';
import 'package:flutter_loggin/pagines/crypto_detail_page.dart';

class CryptoSlider extends StatefulWidget {
  final List<Crypto> cryptos;

  const CryptoSlider({Key? key, required this.cryptos}) : super(key: key);

  @override
  _CryptoSliderState createState() => _CryptoSliderState();
}

class _CryptoSliderState extends State<CryptoSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Autoplay
    Future.delayed(Duration(seconds: 3), _autoPlay);
  }

  // Metode de autoplay que mou la pagina de manera automatica
  void _autoPlay() {
    if (_pageController.hasClients) {
      int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
      if (nextPage >= widget.cryptos.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
      Future.delayed(Duration(seconds: 3), _autoPlay); // Continuar el cicle
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cryptos.length,
        itemBuilder: (BuildContext context, int index) {
          final crypto = widget.cryptos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CryptoDetailsPage(crypto: crypto),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        crypto.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      crypto.name,
                      style: const TextStyle(color: Color(0xFF00C4B4)),
                    ),
                    Text(
                      '\$${crypto.currentPrice}',
                      style: const TextStyle(
                        color: Color(0xFF00C4B4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
