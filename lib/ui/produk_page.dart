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
  State<ProdukPage> createState() => _ProdukPageState();
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
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'List Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(),
                ),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.orange.shade800,
                ),
              ),
              accountName: const Text(
                "Gudangkita",
              ),
              accountEmail: const Text(
                "Inventory Management System",
              ),
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Produk"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        onThemeChanged:
                            widget.onThemeChanged,
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<List>(
        future: ProdukBloc.getProduks(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi Kesalahan",
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.error,
                ),
              ),
            );
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
                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: searchController,

                      decoration: InputDecoration(
                        hintText: "Cari produk...",
                        prefixIcon:
                            const Icon(Icons.search),

                        filled: true,
                        fillColor:
                            Theme.of(context).cardColor,

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      onChanged: filterProduk,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).cardColor,

                      borderRadius:
                          BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SortType>(
                        value: selectedSort,
                        isExpanded: true,

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
                  ),
                ),

                const SizedBox(height: 10),

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
          (a, b) => b.id!.compareTo(a.id!),
        );
        break;
    }
  }
}

class ListProduk extends StatelessWidget {
  final List? list;

  const ListProduk({
    Key? key,
    this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),

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

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,

                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.inventory_2,
                  color: Colors.orange.shade800,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      produk.namaProduk!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Kode : ${produk.kodeProduk}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Stok : ${produk.stok} ${produk.satuan}",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,

                children: [
                  Text(
                    "Rp ${produk.hargaProduk!.toStringAsFixed(2)}",

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
