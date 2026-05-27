import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({
    Key? key,
    this.produk,
  }) : super(key: key);

  @override
  State<ProdukDetail> createState() =>
      _ProdukDetailState();
}

class _ProdukDetailState
    extends State<ProdukDetail> {
  final _jumlahController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Detail Produk',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color:
                      Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(
                        0.05,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),

                      child: Icon(
                        Icons.inventory_2,
                        size: 50,
                        color:
                            Colors.orange.shade800,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      widget.produk!.namaProduk!,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _itemDetail(
                      "Kode Produk",
                      widget.produk!
                          .kodeProduk!,
                    ),

                    _itemDetail(
                      "Harga",
                      "Rp ${widget.produk!.hargaProduk!.toStringAsFixed(2)}",
                    ),

                    _itemDetail(
                      "Stok",
                      "${widget.produk!.stok}",
                    ),

                    _itemDetail(
                      "Satuan",
                      widget.produk!.satuan!,
                    ),

                    _itemDetail(
                      "Penerima",
                      widget.produk!.penerima!,
                    ),

                    _itemDetail(
                      "Dibuat",
                      widget.produk!
                          .createdAt!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _tombolAksi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemDetail(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolAksi() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("EDIT"),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProdukForm(
                        produk:
                            widget.produk!,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text("DELETE"),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onPressed: () =>
                    confirmHapus(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.arrow_upward,
                ),

                label: const Text(
                  "KIRIM",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  dialogKirim();
                },
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.arrow_downward,
                ),
                label: const Text(
                  "TERIMA",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  dialogTerima();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: const Text(
            "Konfirmasi",
          ),
          content: const Text(
            "Yakin ingin menghapus produk ini?",
          ),
          actions: [
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Hapus"),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ProdukBloc.deleteProduk(
                  id: widget.produk!.id!,
                ).then((value) {
                  Navigator
                      .pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProdukPage(
                        onThemeChanged:
                            () {},
                      ),
                    ),
                    (route) => false,
                  );
                }, onError: (error) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const WarningDialog(
                      description:
                          "Hapus gagal, silakan coba lagi",
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void dialogKirim() {
    _jumlahController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: const Text(
            "Kirim Barang",
          ),

          content: TextField(
            controller: _jumlahController,
            keyboardType:
                TextInputType.number,
            decoration: InputDecoration(
              labelText: "Jumlah",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),

          actions: [
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Kirim"),

              onPressed: () {
                ProdukBloc.kirimBarang(
                  id: widget.produk!.id!,
                  jumlah: int.parse(
                    _jumlahController.text,
                  ),
                ).then((value) {
                  Navigator
                      .pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProdukPage(
                        onThemeChanged:
                            () {},
                      ),
                    ),

                    (route) => false,
                  );
                }, onError: (error) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const WarningDialog(
                      description:
                          "Stok tidak mencukupi",
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void dialogTerima() {
    _jumlahController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: const Text(
            "Terima Barang",
          ),
          content: TextField(
            controller: _jumlahController,
            keyboardType:
                TextInputType.number,
            decoration: InputDecoration(
              labelText: "Jumlah",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),

          actions: [
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Terima"),
              onPressed: () {
                ProdukBloc.terimaBarang(
                  id: widget.produk!.id!,
                  jumlah: int.parse(
                    _jumlahController.text,
                  ),
                ).then((value) {
                  Navigator
                      .pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProdukPage(
                        onThemeChanged:
                            () {},
                      ),
                    ),

                    (route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}