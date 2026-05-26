class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  double? hargaProduk;
  int? stok;
  String? satuan;
  String? penerima;
  String? createdAt;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk, this.stok, this.satuan, this.penerima, this.createdAt});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: int.parse(obj['id'].toString()),
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: double.parse(obj['harga'].toString()),
      stok: int.parse(obj['stok'].toString()),
      satuan: obj['satuan'],
      penerima: obj['penerima'],
      createdAt: obj['created_at'],
    );
  }
}
