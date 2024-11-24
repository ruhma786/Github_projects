class WeatherData {
  final String temperature;
  final String weatherDescription;
  final String humidity;
  final String windSpeed;
  final String weatherIcon;

  WeatherData({
    required this.temperature,
    required this.weatherDescription,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: '${json['main']['temp']}°C',  // Changed to Celsius
      weatherDescription:
      '${json['weather'][0]['description'][0].toUpperCase()}${json['weather'][0]['description'].substring(1)}',
      humidity: '${json['main']['humidity']}%',
      windSpeed: '${json['wind']['speed']} m/s',  // Changed to meters per second (m/s)
      weatherIcon: getWeatherIcon(json['weather'][0]['main'].toLowerCase()),
    );
  }

  static String getWeatherIcon(String condition) {
    switch (condition) {
      case 'clear':
        return 'images/sunny.png';
      case 'clouds':
        return 'images/cloudy.png';
      case 'rain':
        return 'images/rain.png';
      default:
        return 'images/light-rain.png';
    }
  }
}