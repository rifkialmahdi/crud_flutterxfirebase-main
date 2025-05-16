import 'package:flutter/material.dart';
import 'package:praktek_crud/services/firestore.dart';

final FirestoreService firestoreService = FirestoreService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final TextEditingController namaController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController layananController = TextEditingController();

  void openNoteBox () {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan Cucian Anda'),
            const SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama Anda',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: beratController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Berat Cucian (kg)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: layananController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Jenis Layanan',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              firestoreService.addCucian(
                namaController.text,
                beratController.text,
                layananController.text,
              );
              namaController.clear();
              beratController.clear();
              layananController.clear();
              Navigator.pop(context);
            },
            child: 
            const Text('Simpan'),
          ),
          ElevatedButton(
            onPressed: () {
              namaController.clear();
              beratController.clear();
              layananController.clear();
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WashUp',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
          centerTitle: true, 
          backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Agar teks rata kiri
        children: [
        SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(16.0), // Tambahkan padding agar teks tidak menempel ke tepi
            child: Text(
              'Daftar Cucian WashUp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
          Expanded( // Gunakan Expanded agar StreamBuilder mengisi sisa ruang
            child: StreamBuilder(
              stream: firestoreService.getCucian(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final cucian = data[index];
                    return ListTile(
                      title: Text('Customer : ${data[index]['nama']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.grey,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final TextEditingController editNamaController = TextEditingController(text: data[index]['nama']);
                                  final TextEditingController editBeratController = TextEditingController(text: data[index]['berat']);
                                  final TextEditingController editLayananController = TextEditingController(text: data[index]['layanan']);

                                  return AlertDialog(
                                    title: const Text('Edit Cucian'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: editNamaController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nama Anda',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: editBeratController,
                                          decoration: const InputDecoration(
                                            labelText: 'Berat Cucian (kg)',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: editLayananController,
                                          decoration: const InputDecoration(
                                            labelText: 'Jenis Layanan',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          firestoreService.updateCucian(
                                            data[index].id,
                                            editNamaController.text,
                                            editBeratController.text,
                                            editLayananController.text,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Simpan'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Batal'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              firestoreService.deleteCucian(data[index].id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Detail Cucian'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama: ${cucian['nama']}'),
                                const SizedBox(height: 10),
                                Text('Berat Cucian: ${cucian['berat']} kg'),
                                const SizedBox(height: 10),
                                Text('Jenis Layanan: ${cucian['layanan']}'),
                                const SizedBox(height: 10),
                                Text('Waktu: ${cucian['timestamp'].toDate()}'),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }  
}