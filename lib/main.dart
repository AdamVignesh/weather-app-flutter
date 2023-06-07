import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import './Location.dart';
void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(home: GetApi());
  }
}

class GetApi extends StatefulWidget {
  const GetApi({super.key});

  @override
  State<GetApi> createState() => _GetApiState();
}

class _GetApiState extends State<GetApi> {

  Map<String,dynamic>? weatherData;
  bool isDataLoaded = false;

  Future<void> callAPI() async
  {
    var position = await LocationHelper.getCurrentLocation();
    String latt = position.latitude.toString();
    String lng = position.longitude.toString();
    print(latt);
    print(lng);

    print("in call api");
    String apiKey = "b65646526636a68703d3aa4e19d4117a";

    String baseUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${latt}&lon=${lng}&cnt=8&appid=b65646526636a68703d3aa4e19d4117a";
    final response = await http
        .get(Uri.parse(baseUrl));
    print(response.statusCode);
    weatherData = jsonDecode(response.body);
    if(weatherData!=null)
      {
        setState(() {
          // print("state changed");
          isDataLoaded = true;
        });
      }
    // print(weatherData);
  }
  @override
  Widget build(BuildContext context) {
    callAPI();
    // print("hellod $weatherData!['daily']['weather'][0]['icon']");
    String Temp="";
    if(weatherData!=null) {
      try {
        double doubleValue = double.parse(
            weatherData!['main']['temp'].toString());
        Temp = (doubleValue - 273).toStringAsFixed(2);
        print('tympfsdfsdf $Temp');
      }
      catch (err) {
        print('err $err');
      }
    }
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Text('Weather',
                      style: TextStyle(
                      fontSize:30, // Set the text color
              ),),
              centerTitle: true, // Center-align the title text
              backgroundColor: Colors.black, //
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                  // Handle settings button tap
                },
              ),
            ],
          ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(20,0,20,0),
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: Color(0xff706200FF),
              borderRadius: BorderRadius.circular(40), // Set the border radius
            ),
            child:
                isDataLoaded == false? CircularProgressIndicator():
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Text("Temp : $Temp °C"),
                    Text('Humidity: ${weatherData!['main']['humidity']} %'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Text('Description : ${weatherData!['weather'][0]['description']}'),
                    Text('Wind Speed: ${weatherData!['wind']['speed']} KpH'),
                  ],
                ),
                  ],
            ),
          ),
        ),

      ),
    );
  }
}
