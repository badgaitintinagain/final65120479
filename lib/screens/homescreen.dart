import 'package:flutter/material.dart';
import 'package:final65120479/backbone/database_helper.dart';
import 'package:final65120479/backbone/model.dart';
import 'package:final65120479/screens/plant_detail_screen.dart';
import 'package:final65120479/screens/add_plant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Plant>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPlants();
  }

  void _refreshPlants() {
    setState(() {
      _plantsFuture = DatabaseHelper().getPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantipedia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: PlantsList(plantsFuture: _plantsFuture),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlantScreen()),
          );
          if (result == true) {
            _refreshPlants();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlantsList extends StatelessWidget {
  final Future<List<Plant>> plantsFuture;

  const PlantsList({super.key, required this.plantsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plant>>(
      future: plantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No plants found'));
        } else {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final plant = snapshot.data![index];
              return PlantListTile(plant: plant);
            },
          );
        }
      },
    );
  }
}

class PlantListTile extends StatelessWidget {
  final Plant plant;

  const PlantListTile({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        plant.plantName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        plant.plantScientific,
        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF54595D)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFA2A9B1)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          ),
        );
      },
    );
  }
}