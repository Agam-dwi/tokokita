import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;

  ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController =
      TextEditingController();

  final _namaProdukTextboxController =
      TextEditingController();

  final _hargaProdukTextboxController =
      TextEditingController();

  final _stokTextboxController =
      TextEditingController();

  final _satuanTextboxController =
      TextEditingController();

  final _penerimaTextboxController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";

        _kodeProdukTextboxController.text =
            widget.produk!.kodeProduk!;

        _namaProdukTextboxController.text =
            widget.produk!.namaProduk!;

        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();

        _stokTextboxController.text =
            widget.produk!.stok.toString();

        _satuanTextboxController.text =
            widget.produk!.satuan!;

        _penerimaTextboxController.text =
            widget.produk!.penerima!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                    
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Lengkapi data produk dengan benar",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .cardColor,

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    _kodeProdukTextField(),
                    const SizedBox(height: 16),

                    _namaProdukTextField(),
                    const SizedBox(height: 16),

                    _hargaProdukTextField(),
                    const SizedBox(height: 16),

                    _stokTextField(),
                    const SizedBox(height: 16),

                    _satuanTextField(),
                    const SizedBox(height: 16),

                    _penerimaTextField(),
                    const SizedBox(height: 30),

                    _buttonSubmit(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,


      filled: true,

      fillColor:
          Theme.of(context).brightness ==
                  Brightness.dark
              ? Colors.grey.shade900
              : Colors.grey.shade100,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),

        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),

        borderSide: BorderSide(
          color: Colors.orange.shade400,
          width: 2,
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      controller:
          _kodeProdukTextboxController,

      decoration: customInputDecoration(
        "Kode Produk",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      controller:
          _namaProdukTextboxController,

      decoration: customInputDecoration(
        "Nama Produk",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      controller:
          _hargaProdukTextboxController,

      keyboardType: TextInputType.number,

      decoration: customInputDecoration(
        "Harga",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        return null;
      },
    );
  }

  Widget _stokTextField() {
    return TextFormField(
      controller: _stokTextboxController,

      keyboardType: TextInputType.number,

      decoration: customInputDecoration(
        "Stok",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Stok harus diisi";
        }
        return null;
      },
    );
  }

  Widget _satuanTextField() {
    return TextFormField(
      controller:
          _satuanTextboxController,

      decoration: customInputDecoration(
        "Satuan",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Satuan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _penerimaTextField() {
    return TextFormField(
      controller:
          _penerimaTextboxController,

      decoration: customInputDecoration(
        "Penerima",
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return "Penerima harus diisi";
        }
        return null;
      },
    );
  }


  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 55,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),

        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                tombolSubmit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),

        onPressed: () {
          var validate =
              _formKey.currentState!.validate();

          if (validate) {
            if (!_isLoading) {
              if (widget.produk != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  void simpan() {

    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(id: null);

    createProduk.kodeProduk =
        _kodeProdukTextboxController.text;

    createProduk.namaProduk =
        _namaProdukTextboxController.text;

    createProduk.hargaProduk = double.parse(
      _hargaProdukTextboxController.text,
    );

    createProduk.stok = int.parse(
      _stokTextboxController.text,
    );

    createProduk.satuan =
        _satuanTextboxController.text;

    createProduk.penerima =
        _penerimaTextboxController.text;

    ProdukBloc.addProduk(
      produk: createProduk,
    ).then(
      (value) {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (BuildContext context) =>
                    ProdukPage(
              onThemeChanged: () {},
            ),
          ),
        );
      },

      onError: (error) {

        showDialog(
          context: context,

          builder:
              (BuildContext context) =>
                  const WarningDialog(
            description:
                "Simpan gagal, silahkan coba lagi",
          ),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {

    setState(() {
      _isLoading = true;
    });

    Produk updateProduk = Produk(id: null);

    updateProduk.id = widget.produk!.id;

    updateProduk.kodeProduk =
        _kodeProdukTextboxController.text;

    updateProduk.namaProduk =
        _namaProdukTextboxController.text;

    updateProduk.hargaProduk = double.parse(
      _hargaProdukTextboxController.text,
    );

    updateProduk.stok = int.parse(
      _stokTextboxController.text,
    );

    updateProduk.satuan =
        _satuanTextboxController.text;

    updateProduk.penerima =
        _penerimaTextboxController.text;

    ProdukBloc.updateProduk(
      produk: updateProduk,
    ).then(
      (value) {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (BuildContext context) =>
                    ProdukPage(
              onThemeChanged: () {},
            ),
          ),
        );
      },

      onError: (error) {

        showDialog(
          context: context,

          builder:
              (BuildContext context) =>
                  const WarningDialog(
            description:
                "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      },
    );

    setState(() {
      _isLoading = false;
    });
  }
}