class WeatherModel {
  final String cityName;
  final double temperatureInKelvin;
  final String weatherDescription;
  final String icon;
  final double windSpeed;
  final double humidity;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.cityName,
    required this.temperatureInKelvin,
    required this.weatherDescription,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
  });

  // Getter to return temperature in Celsius
  double get temperatureInCelsius => temperatureInKelvin - 273.15;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperatureInKelvin: json['main']['temp'].toDouble(),
      weatherDescription: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
