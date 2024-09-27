import 'package:flutter/material.dart';
import 'package:final65120479/backbone/model.dart';
import 'package:final65120479/screens/land_use_screen.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.plantName),
      ),
      body: PlantDetailContent(plant: plant),
    );
  }
}

class PlantDetailContent extends StatelessWidget {
  final Plant plant;

  const PlantDetailContent({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              plant.plantName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          PlantImage(imagePath: plant.plantImage),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.plantScientific,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Color(0xFF54595D)),
                ),
                const SizedBox(height: 16),
                // const PlantDescription(),
                const SizedBox(height: 16),
                // const ContentTable(),
                const SizedBox(height: 16),
                LandUseButton(plantId: plant.plantID),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlantImage extends StatelessWidget {
  final String imagePath;

  const PlantImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: const Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Image caption',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

// ... (rest of the code remains the same)

// class PlantDescription extends StatelessWidget {
//   const PlantDescription({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Description',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'This section would contain a detailed description of the plant. '
//           'It would include information about its characteristics, habitat, and other relevant details.',
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
// }

// class ContentTable extends StatelessWidget {
//   const ContentTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFA2A9B1)),
//         borderRadius: BorderRadius.circular(2),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             color: const Color(0xFFEAECF0),
//             child: const Row(
//               children: [
//                 Icon(Icons.list, size: 16, color: Color(0xFF54595D)),
//                 SizedBox(width: 8),
//                 Text(
//                   'Contents',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildContentItem('1', 'Description'),
//                 _buildContentItem('2', 'Habitat'),
//                 _buildContentItem('3', 'Uses'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContentItem(String number, String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text('$number. ', style: const TextStyle(color: Color(0xFF3366CC))),
//           Text(title, style: const TextStyle(color: Color(0xFF3366CC))),
//         ],
//       ),
//     );
//   }
// }

class LandUseButton extends StatelessWidget {
  final int plantId;

  const LandUseButton({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandUseScreen(plantId: plantId),
          ),
        );
      },
      child: const Text('View Land Uses'),
    );
  }
}