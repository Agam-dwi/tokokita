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

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  final _stokTextboxController = TextEditingController();
  final _satuanTextboxController = TextEditingController();
  final _penerimaTextboxController = TextEditingController();

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
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _stokTextField(),
                _satuanTextField(),
                _penerimaTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Kode Produk",
      ),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
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
      decoration: const InputDecoration(
        labelText: "Nama Produk",
      ),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
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
      decoration: const InputDecoration(
        labelText: "Harga",
      ),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
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
      decoration: const InputDecoration(
        labelText: "Stok",
      ),
      keyboardType: TextInputType.number,
      controller: _stokTextboxController,
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
      decoration: const InputDecoration(
        labelText: "Satuan",
      ),
      keyboardType: TextInputType.text,
      controller: _satuanTextboxController,
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
      decoration: const InputDecoration(
        labelText: "Penerima",
      ),
      keyboardType: TextInputType.text,
      controller: _penerimaTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Penerima harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();

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
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk = double.parse(_hargaProdukTextboxController.text);
    createProduk.stok = int.parse(_stokTextboxController.text);
    createProduk.satuan = _satuanTextboxController.text;
    createProduk.penerima = _penerimaTextboxController.text;

    ProdukBloc.addProduk(produk: createProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProdukPage(
              onThemeChanged: () {},
            ),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
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
    updateProduk.kodeProduk = _kodeProdukTextboxController.text;
    updateProduk.namaProduk = _namaProdukTextboxController.text;
    updateProduk.hargaProduk = double.parse(_hargaProdukTextboxController.text);
    updateProduk.stok = int.parse(_stokTextboxController.text);
    updateProduk.satuan = _satuanTextboxController.text;
    updateProduk.penerima = _penerimaTextboxController.text;

    ProdukBloc.updateProduk(produk: updateProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProdukPage(
              onThemeChanged: () {},
            ),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
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