class Wilayah {
  final String id;
  final String propinsi;
  final String kota;
  final String kecamatan;
  final double lat;
  final double lon;
  double jarak;

  Wilayah({
    required this.id,
    required this.propinsi,
    required this.kota,
    required this.kecamatan,
    required this.lat,
    required this.lon,
    this.jarak = 0,
  });

  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['id'],
      propinsi: json['propinsi'],
      kota: json['kota'],
      kecamatan: json['kecamatan'],
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
    );
  }
}

class Weather {
  final String kodeCuaca;
  final String cuaca;
  final String jamCuaca;

  Weather({
    required this.kodeCuaca,
    required this.cuaca,
    required this.jamCuaca,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      kodeCuaca: json['kodeCuaca'],
      cuaca: json['cuaca'],
      jamCuaca: json['jamCuaca'],
    );
  }
}
