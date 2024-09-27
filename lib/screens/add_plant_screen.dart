import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:final65120479/backbone/database_helper.dart';
import 'package:final65120479/backbone/model.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({Key? key}) : super(key: key);

  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  File? _image;
  List<int> _selectedLandUses = [];

  @override
  void dispose() {
    _nameController.dispose();
    _scientificNameController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Plant'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Plant Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the plant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _scientificNameController,
                  decoration: const InputDecoration(
                    labelText: 'Scientific Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the scientific name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Select Image'),
                ),
                if (_image != null)
                  Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
                const SizedBox(height: 16),
                const Text('Select Land Uses:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                FutureBuilder<List<LandUseType>>(
                  future: DatabaseHelper().getLandUseTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No land use types available');
                    } else {
                      return Column(
                        children: snapshot.data!.map((landUseType) {
                          return CheckboxListTile(
                            title: Text(landUseType.landUseTypeName),
                            value: _selectedLandUses.contains(landUseType.landUseTypeID),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedLandUses.add(landUseType.landUseTypeID);
                                } else {
                                  _selectedLandUses.remove(landUseType.landUseTypeID);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Plant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(_image!.path);
      final String newPath = path.join(directory.path, fileName);
      await _image!.copy(newPath);

      final newPlant = Plant(
        plantID: 0, // The database will auto-increment this
        plantName: _nameController.text,
        plantScientific: _scientificNameController.text,
        plantImage: newPath,
      );

      final dbHelper = DatabaseHelper();
      final plantId = await dbHelper.insertPlant(newPlant);

      // Insert land uses for the plant
      for (int landUseTypeId in _selectedLandUses) {
        await dbHelper.insertLandUse(LandUse(
          landUseID: 0,
          plantID: plantId,
          componentID: 1101, // Default to 'Leaf' for simplicity
          landUseTypeID: landUseTypeId,
          landUseDescription: 'Default description',
          landUseTypeName: '',
          componentName: '',
        ));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant added successfully')),
      );

      Navigator.pop(context, true);
    }
  }
}