import 'package:flutter/material.dart';

class ModelPakaianAdminScreen extends StatefulWidget {
  const ModelPakaianAdminScreen({super.key});

  @override
  State<ModelPakaianAdminScreen> createState() =>
      _ModelPakaianAdminScreenState();
}

class _ModelPakaianAdminScreenState extends State<ModelPakaianAdminScreen> {
  List<String> modelPakaianList = [
    'Seragam',
    'Kaos Oblong',
    'Rok',
    'Celana',
    'Sweater',
    'Kemeja',
  ];

  void _tambahData() {
    String newModel = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Model Pakaian'),
          content: TextField(
            onChanged: (value) {
              newModel = value;
            },
            decoration: const InputDecoration(hintText: 'Nama Model'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Tambah'),
              onPressed: () {
                if (newModel.isNotEmpty) {
                  setState(() {
                    modelPakaianList.add(newModel);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editData(int index) {
    String editedModel = modelPakaianList[index];
    TextEditingController controller = TextEditingController(text: editedModel);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Model Pakaian'),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              editedModel = value;
            },
            decoration: const InputDecoration(hintText: 'Nama Model'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                if (editedModel.isNotEmpty) {
                  setState(() {
                    modelPakaianList[index] = editedModel;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _hapusData(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Model Pakaian'),
          content: Text(
              'Apakah Anda yakin ingin menghapus "${modelPakaianList[index]}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Hapus'),
              onPressed: () {
                setState(() {
                  modelPakaianList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        title: const Text('Model Pakaian Admin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(16.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Model Pakaian',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _tambahData,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Table(
                      border: TableBorder.all(color: Colors.black26),
                      columnWidths: const {
                        0: FlexColumnWidth(0.5),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          children: const [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87))),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Model Pakaian',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87))),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Aksi',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87))),
                          ],
                        ),
                        for (int i = 0; i < modelPakaianList.length; i++)
                          TableRow(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text((i + 1).toString(),
                                      style: TextStyle(color: Colors.black87))),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(modelPakaianList[i],
                                      style: TextStyle(color: Colors.black87))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => _editData(i),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue[100],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4))),
                                        child: const Text('Edit',
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => _hapusData(i),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.red[100],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4))),
                                        child: const Text('Hapus',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
