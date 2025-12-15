import 'dart:math';

class QuoteUtils {
  static final List<String> quotes = [
    "Yêu không cần lý do ❤️",
    "Mỗi ngày bên nhau là một món quà",
    "Cảm ơn vì đã đến bên nhau",
    "Nguyên Khôi & Khánh Vy mãi bên nhau",
    "Cùng nhau đi hết thanh xuân 💕",
  ];

  static String randomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
