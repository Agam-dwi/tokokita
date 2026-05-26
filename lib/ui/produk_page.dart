import 'package:flutter/material.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

enum SortType {
  az,
  za,
  newest,
}

class ProdukPage extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const ProdukPage({
    Key? key,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final TextEditingController searchController =
    TextEditingController();

  List produkList = [];
  List filteredList = [];


  SortType selectedSort = SortType.newest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        
        actions: [
          IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: widget.onThemeChanged,
        ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProdukForm(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ),
                  );
                });
              },
            )
          ],
        ),
      ),

      body: FutureBuilder<List>(
      future: ProdukBloc.getProduks(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.hasData) {

          produkList = snapshot.data!;

          if (filteredList.isEmpty &&
              searchController.text.isEmpty) {

            filteredList = List.from(produkList);

            sortProduk(selectedSort);
          }

          return Column(
            children: [

              // SEARCH
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Cari produk...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: filterProduk,
                ),
              ),

              // SORT
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton<SortType>(
                  isExpanded: true,
                  value: selectedSort,

                  items: const [

                    DropdownMenuItem(
                      value: SortType.az,
                      child: Text("A-Z"),
                    ),

                    DropdownMenuItem(
                      value: SortType.za,
                      child: Text("Z-A"),
                    ),

                    DropdownMenuItem(
                      value: SortType.newest,
                      child: Text("Newest"),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {
                      sortProduk(value!);
                    });
                  },
                ),
              ),

              // LIST PRODUK
              Expanded(
                child: ListProduk(
                  list: filteredList,
                ),
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
    );
  }
  

  void filterProduk(String keyword) {

  filteredList = produkList.where((produk) {
    return produk.namaProduk!
        .toLowerCase()
        .contains(keyword.toLowerCase());
  }).toList();

  sortProduk(selectedSort);

  setState(() {});
}

  void sortProduk(SortType type) {

  selectedSort = type;

  switch (type) {

    case SortType.az:
      filteredList.sort(
        (a, b) => a.namaProduk!
            .compareTo(b.namaProduk!),
      );
      break;

    case SortType.za:
      filteredList.sort(
        (a, b) => b.namaProduk!
            .compareTo(a.namaProduk!),
      );
      break;

    case SortType.newest:
      filteredList.sort(
        (a, b) => b.id!
            .compareTo(a.id!),
      );
      break;
  }
}
}


class ListProduk extends StatelessWidget {
  final List? list;

  const ListProduk({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemProduk(
          produk: list![i],
        );
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({
    Key? key,
    required this.produk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk!),

          subtitle: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Rp ${produk.hargaProduk!.toStringAsFixed(2)}",
              ),

              Text(
                "Stok : ${produk.stok} ${produk.satuan}",
              ),
            ],
          ),
        ),
      )
    );
  }

  
}