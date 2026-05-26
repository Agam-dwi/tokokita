import 'dart:convert';

import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listProduk =
        (jsonObj as Map<String, dynamic>)['data'];

    List<Produk> produks = [];

    for (int i = 0; i < listProduk.length; i++) {
      produks.add(
        Produk.fromJson(listProduk[i]),
      );
    }

    return produks;
  }

  static Future addProduk({
    Produk? produk,
  }) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk!.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
      "stok": produk.stok.toString(),
      "satuan": produk.satuan,
      "penerima": produk.penerima,
    };

    var response = await Api().post(
      apiUrl,
      body,
    );

    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }

  static Future<bool> updateProduk({
    required Produk produk,
  }) async {
    String apiUrl =
        ApiUrl.updateProduk(produk.id!);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
      "stok": produk.stok.toString(),
      "satuan": produk.satuan,
      "penerima": produk.penerima,
    };

    print("Body : $body");

    var response = await Api().put(
      apiUrl,
      body,
    );

    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }

  static Future<bool> deleteProduk({
    int? id,
  }) async {
    String apiUrl =
        ApiUrl.deleteProduk(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return (jsonObj as Map<String, dynamic>)['data'];
  }

  static Future<bool> kirimBarang({
    required int id,
    required int jumlah,
  }) async {

    String apiUrl =
        ApiUrl.kirimBarang(id);

    var body = {
      "jumlah": jumlah.toString(),
    };

    var response =
        await Api().post(apiUrl, body);

    var jsonObj =
        json.decode(response.body);

    return jsonObj['status'];
  }

  static Future<bool> terimaBarang({
    required int id,
    required int jumlah,
  }) async {

    String apiUrl =
        ApiUrl.terimaBarang(id);

    var body = {
      "jumlah": jumlah.toString(),
    };

    var response =
        await Api().post(apiUrl, body);

    var jsonObj =
        json.decode(response.body);

    return jsonObj['status'];
  }
}