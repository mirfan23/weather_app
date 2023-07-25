import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/models.dart';

class ApiService {
  Future<List<Wilayah>> fetchWilayahData() async {
    final response = await http.get(
        Uri.parse('https://ibnux.github.io/BMKG-importer/cuaca/wilayah.json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Wilayah> wilayahs =
          List<Wilayah>.from(jsonData.map((data) => Wilayah.fromJson(data)));
      wilayahs.sort(urutkanJarak);
      return wilayahs;
    } else {
      throw Exception('Gagal mengambil data wilayah');
    }
  }

  Future<List<Weather>> getCuaca(String idWilayah) async {
    final response = await http.get(Uri.parse(
        'https://ibnux.github.io/BMKG-importer/cuaca/$idWilayah.json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Weather> weathers =
          List<Weather>.from(jsonData.map((data) => Weather.fromJson(data)));
      return weathers;
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }

  int urutkanJarak(Wilayah a, Wilayah b) {
    if (a.jarak == b.jarak) {
      return 0;
    } else {
      return a.jarak < b.jarak ? -1 : 1;
    }
  }
}
