int calculateReadingTime(String content) {
  final words = content.trim().split(RegExp(r'\s+')).length; // Split by whitespace
  final wordsPerMinute = 200; // Average reading speed
  return (words / wordsPerMinute).ceil();
}