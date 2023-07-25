import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/pages/controller.dart';
import 'package:weather_app/utils/models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  String selectedWilayahId = "501234";
  Wilayah? selectedWilayah;
  List<Wilayah> wilayahList = [];
  List<Weather> weatherData = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchWilayahData();
  }

  Future<void> fetchWilayahData() async {
    try {
      final List<Wilayah> wilayahs = await _apiService.fetchWilayahData();
      setState(() {
        wilayahList = wilayahs;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getCuaca(String idWilayah) async {
    try {
      final List<Weather> weathers = await _apiService.getCuaca(idWilayah);
      setState(() {
        weatherData = weathers;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wilayah', // Tambahkan keterangan lat dan lon jika diperlukan
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedWilayahId,
                items: wilayahList.map((wilayah) {
                  return DropdownMenuItem<String>(
                    value: wilayah.id,
                    child: Text(
                      '${wilayah.propinsi}, ${wilayah.kota}',
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWilayahId = newValue!;
                    selectedWilayah = wilayahList.firstWhere(
                      (wilayah) => wilayah.id == selectedWilayahId,
                    );
                    getCuaca(selectedWilayahId);
                  });
                },
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                'Cuaca ${weatherData.isNotEmpty ? weatherData[0].cuaca : ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.network(
                      'https://ibnux.github.io/BMKG-importer/icon/${weatherData.isNotEmpty ? weatherData[0].kodeCuaca : ''}.png',
                      height: 120, // Ukuran gambar ikon cuaca
                      width: 120,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cuaca: ${weatherData.isNotEmpty ? weatherData[0].cuaca : ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                        '${weatherData.isNotEmpty ? weatherData[0].jamCuaca : ''}'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                'Prakiraan Cuaca Berikutnya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Mengatur arah scroll ke vertikal
                  itemCount: weatherData.length,
                  itemBuilder: (context, index) {
                    if (index != 0) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Image.network(
                              'https://ibnux.github.io/BMKG-importer/icon/${weatherData[index].kodeCuaca}.png',
                              height: 50, // Ukuran gambar ikon cuaca
                              width: 50,
                            ),
                            Text('${weatherData[index].jamCuaca}'),
                            Text('Cuaca: ${weatherData[index].cuaca}'),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
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
}
