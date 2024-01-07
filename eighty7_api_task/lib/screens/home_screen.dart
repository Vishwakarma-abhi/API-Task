import 'package:eighty7_api_task/provider/location_provider.dart';
import 'package:eighty7_api_task/provider/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initLocationWithDelay();
  }

  Future<void> _initLocationWithDelay() async {
    // Introduce a delay of 2 seconds before calling _getLocationAndFetchWeather
    await Future.delayed(Duration(seconds: 2));
    _getLocationAndFetchWeather(context);
  }

  Future<void> _getLocationAndFetchWeather(BuildContext context) async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);

    try {
      LocationProvider locationProvider = LocationProvider();
      Position position = await locationProvider.determinePosition();
      await provider.fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text('Weather App')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.blue.withOpacity(0.8)
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue.withOpacity(0.5),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              // Display weather information
              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, child) {
                    //storing the weather data
                    final weatherData = provider.weatherData;

                    if (weatherData != null) {
                      return Column(
                        children: [
                          // Display city and weather description
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        if (weatherData.icon != null)
                                          Image.network(
                                            'https://openweathermap.org/img/wn/' +
                                                weatherData.icon +
                                                '@2x.png',
                                            height: 60,
                                          ),
                                        Text(
                                          weatherData.weatherDescription,
                                          // style needed
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '  ${weatherData.cityName}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Display temperature
                          Container(
                            height: 300,
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  WeatherIcons.thermometer,
                                  size: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weatherData.temperatureInCelsius
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 90,
                                      ),
                                    ),
                                    Text(
                                      "°C",
                                      style: TextStyle(fontSize: 30),
                                    )
                                  ],
                                ),
                                Text(
                                  'Sunrise: ${getFormattedTime(weatherData.sunrise)}' +
                                      ' am',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'Sunset: ${getFormattedTime(weatherData.sunset)}' +
                                        ' pm',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),

                          // Display wind speed and humidity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  padding: EdgeInsets.all(26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            WeatherIcons.day_windy,
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        weatherData.windSpeed.toString(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("km/hr")
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                  padding: EdgeInsets.all(26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            WeatherIcons.humidity,
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        weatherData.humidity.toString(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Percent")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Show a loading indicator or a message indicating no data
                      return Center(
                        child: Column(
                          children: [
                            Image.asset('assets/indicator.png'),
                            Text('Wait Data is Loading .....')
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedTime(int timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    String formattedTime =
        DateFormat.Hm().format(dateTime.toLocal()); // Format as HH:mm
    return formattedTime;
  }
}
