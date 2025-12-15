class BackgroundUtils {
  static final List<String> backgrounds = [
    'assets/images/img5.jpg',
    'assets/images/img7.jpg',
    'assets/images/img8.jpg',
    'assets/images/img9.jpg',
  ];

  // Lấy ảnh dựa theo ngày
  static String getBackgroundByDay() {
    final day = DateTime.now().day;
    return backgrounds[day % backgrounds.length];
  }
}
