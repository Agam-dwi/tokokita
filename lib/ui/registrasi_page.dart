import 'package:flutter/material.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/widget/success_dialog.dart';
import 'package:tokokita/widget/warning_dialog.dart';
import 'package:tokokita/ui/login_page.dart';

class RegistrasiPage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const RegistrasiPage({Key? key, required this.onThemeChanged,}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,


        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Registrasi",
                    style: TextStyle(
                   
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Buat akun baru",
                    style: TextStyle(
                   
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
              
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(30),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          _namaTextField(),
                          _emailTextField(),
                          _passwordTextField(),
                          _passwordKonfirmasiTextField(),

                          const SizedBox(height: 30),

                          _buttonRegistrasi(),

                          const SizedBox(height: 20),

                          _menuLogin(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _namaTextboxController,
        validator: (value) {
          if (value!.length < 3) {
            return "Nama minimal 3 karakter";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Masukkan Nama",
          prefixIcon: const Icon(Icons.person),


          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
         
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
          
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _emailTextboxController,
        keyboardType:
            TextInputType.emailAddress,

        validator: (value) {
          if (value!.isEmpty) {
            return 'Email harus diisi';
          }

          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zAZ]{2,}))$';

          RegExp regex =
              RegExp(pattern.toString());

          if (!regex.hasMatch(value)) {
            return "Email tidak valid";
          }

          return null;
        },

        decoration: InputDecoration(
          hintText: "Masukkan Email",
          prefixIcon: const Icon(Icons.email),

          

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
          
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
       
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller:
            _passwordTextboxController,
        obscureText: true,

        validator: (value) {
          if (value!.length < 6) {
            return "Password minimal 6 karakter";
          }
          return null;
        },

        decoration: InputDecoration(
          hintText: "Masukkan Password",
          prefixIcon: const Icon(Icons.lock),


          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
        
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(

              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordKonfirmasiTextField() {
  return Container(
    margin: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        obscureText: true,

        validator: (value) {
          if (value !=
              _passwordTextboxController.text) {
            return "Konfirmasi Password tidak sama";
          }
          return null;
        },

        decoration: InputDecoration(
          hintText: "Konfirmasi Password",
          prefixIcon:
              const Icon(Icons.lock_outline),

          

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
    
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
            
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      height: 50,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),

        child: _isLoading
            ? const CircularProgressIndicator(
               
              )
            : const Text(
                "REGISTRASI",
                style: TextStyle(
              
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

        onPressed: () {
          var validate =
              _formKey.currentState!.validate();

          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  Widget _menuLogin() {
    return Center(
      child: InkWell(
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(onThemeChanged: widget.onThemeChanged),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }
}