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
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  final _jumlahController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk!.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Stok : ${widget.produk!.stok!.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Satuan : ${widget.produk!.satuan!}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Penerima : ${widget.produk!.penerima!}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Dibuat : ${widget.produk!.createdAt!}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk!,
                ),
              ),
            );
          },
        ),

        // Tombol Delete
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),

        OutlinedButton(
        child: const Text("KIRIM"),
        onPressed: () {
          dialogKirim();
        },
      ),

      OutlinedButton(
        child: const Text("TERIMA"),
        onPressed: () {
          dialogTerima();
        },
      ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Yakin ingin menghapus data ini?",
      ),
      actions: [
        // Tombol Ya (Hapus)
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(
              id: widget.produk!.id!,
            ).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukPage(
                    onThemeChanged: () {},
                  ),
                ),
                (route) => false,
              );
            }, onError: (error) {
              showDialog(
                context: context,
                builder: (context) => const WarningDialog(
                  description:
                      "Hapus gagal, silakan coba lagi",
                ),
              );
            });
          },
        ),

        // Tombol Batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  void dialogKirim() {

    _jumlahController.clear();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text(
            "Kirim Barang",
          ),

          content: TextField(
            controller: _jumlahController,
            keyboardType:
                TextInputType.number,

            decoration:
                const InputDecoration(
              labelText: "Jumlah",
            ),
          ),

          actions: [

            OutlinedButton(
              child: const Text("Kirim"),

              onPressed: () {

                ProdukBloc.kirimBarang(
                  id: widget.produk!.id!,
                  jumlah: int.parse(
                    _jumlahController.text,
                  ),
                ).then((value) {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProdukPage(
                    onThemeChanged: () {},
                  ),
                    ),
                    (route) => false,
                  );

                }, onError: (error) {

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => const WarningDialog(
                    description:
                        "Stok tidak mencukupi",
                  ),
                );

              });
              },
            )
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
          title: const Text(
            "Kirim Barang",
          ),

          content: TextField(
            controller: _jumlahController,
            keyboardType:
                TextInputType.number,

            decoration:
                const InputDecoration(
              labelText: "Jumlah",
            ),
          ),

          actions: [

            OutlinedButton(
              child: const Text("Kirim"),

              onPressed: () {

                ProdukBloc.terimaBarang(
                  id: widget.produk!.id!,
                  jumlah: int.parse(
                    _jumlahController.text,
                  ),
                ).then((value) {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProdukPage(
                    onThemeChanged: () {},
                  ),
                    ),
                    (route) => false,
                  );

                });
              },
            )
          ],
        );
      },
    );
  }
}