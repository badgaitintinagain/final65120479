import 'package:flutter/material.dart';
import 'package:final65120479/backbone/database_helper.dart';
import 'package:final65120479/backbone/model.dart';

class LandUseScreen extends StatelessWidget {
  final int plantId;

  const LandUseScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Land Uses'),
      ),
      body: LandUsesList(plantId: plantId),
    );
  }
}

class LandUsesList extends StatelessWidget {
  final int plantId;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  LandUsesList({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LandUse>>(
      future: _databaseHelper.getLandUsesForPlant(plantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading land uses: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No land uses found for this plant.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => LandUseListItem(landUse: snapshot.data![index]),
          );
        }
      },
    );
  }
}

class LandUseListItem extends StatelessWidget {
  final LandUse landUse;

  const LandUseListItem({super.key, required this.landUse});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              landUse.landUseTypeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Component: ${landUse.componentName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF54595D)),
            ),
            const SizedBox(height: 8),
            Text(
              landUse.landUseDescription,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}