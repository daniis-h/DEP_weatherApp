import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../service/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = '4e3ce2c2e34dd70bc45ae38b3d0effd1';
  final WeatherService weatherService = WeatherService('4e3ce2c2e34dd70bc45ae38b3d0effd1');
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current city name
      String cityName = await weatherService.getCurrentCity();
      // Fetch weather data
      Weather weather = await weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    } else if (_weather != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _weather!.cityName,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_weather!.temperature}°C',
            style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
          ),
        //   Text(
        //     _weather!.description,
        //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        //   ),
        //   SizedBox(height: 20),
        //   _buildWeatherAnimation(_weather!.description),
        ],
      );
    } else {
      return Center(child: Text('No weather data available.'));
    }
  }

  Widget _buildWeatherAnimation(String description) {
    String animationPath;

    if (description.contains('rain')) {
      animationPath = 'assets/animations/rain.json';
    } else if (description.contains('cloud')) {
      animationPath = 'assets/animations/cloud.json';
    } else if (description.contains('clear')) {
      animationPath = 'assets/animations/sunny.json';
    } else {
      animationPath = 'assets/animations/unknown.json';
    }

    return Lottie.asset(animationPath, width: 200, height: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildWeatherContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
