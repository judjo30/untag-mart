import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final alamatController = TextEditingController();
  final catatanController = TextEditingController();

  String metodePembayaran = "Transfer Bank";
  Uint8List? buktiPembayaran;

  String rupiah(double value) {
    return "Rp ${value.toStringAsFixed(0)}";
  }

  Future<void> pilihBuktiPembayaran() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        buktiPembayaran = bytes;
      });
    }
  }

  void bayarSekarang(CartProvider cart) {
    if (alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alamat pengiriman wajib diisi"),
        ),
      );
      return;
    }

    if (buktiPembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Upload bukti pembayaran terlebih dahulu"),
        ),
      );
      return;
    }

    cart.clearCart();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pembayaran Berhasil"),
          content: const Text(
            "Simulasi payment gateway berhasil.\nStok produk berkurang secara simulasi.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text("Tidak ada produk yang di-checkout"),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ringkasan Pembayaran",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text(rupiah(cart.subtotal)),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Diskon"),
                          Text(
                            "- ${rupiah(cart.totalDiscount)}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),

                      const Divider(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Bayar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            rupiah(cart.totalHarga),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      TextField(
                        controller: alamatController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Alamat Pengiriman",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: catatanController,
                        decoration: const InputDecoration(
                          labelText: "Catatan Pesanan",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Metode Pembayaran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      RadioListTile(
                        title: const Text("Transfer Bank"),
                        value: "Transfer Bank",
                        groupValue: metodePembayaran,
                        onChanged: (value) {
                          setState(() {
                            metodePembayaran = value.toString();
                          });
                        },
                      ),

                      RadioListTile(
                        title: const Text("E-Wallet"),
                        value: "E-Wallet",
                        groupValue: metodePembayaran,
                        onChanged: (value) {
                          setState(() {
                            metodePembayaran = value.toString();
                          });
                        },
                      ),

                      RadioListTile(
                        title: const Text("COD"),
                        value: "COD",
                        groupValue: metodePembayaran,
                        onChanged: (value) {
                          setState(() {
                            metodePembayaran = value.toString();
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Upload Bukti Pembayaran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (buktiPembayaran != null)
                        Center(
                          child: Image.memory(
                            buktiPembayaran!,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 130,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Text("Belum ada bukti pembayaran"),
                        ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: pilihBuktiPembayaran,
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Pilih Bukti Pembayaran"),
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => bayarSekarang(cart),
                          icon: const Icon(Icons.payment),
                          label: const Text("Bayar Sekarang"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}