import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agrum App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyPlantsScreen(),
    );
  }
}

class Plant {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime plantingDate;
  final int wateringIntervalDays;
  final int fertilizingIntervalDays;
  final List<Activity> activities;

  Plant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.plantingDate,
    required this.wateringIntervalDays,
    required this.fertilizingIntervalDays,
    required this.activities,
  });
}

class Activity {
  final String type;
  final DateTime date;

  Activity({
    required this.type,
    required this.date,
  });
}

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Plant> plants = [
      Plant(
        id: '1',
        name: 'Tomat',
        imageUrl: 'https://via.placeholder.com/150',
        plantingDate: DateTime.now().subtract(const Duration(days: 30)),
        wateringIntervalDays: 3,
        fertilizingIntervalDays: 15,
        activities: [
          Activity(
              type: 'Penyiraman',
              date: DateTime.now().subtract(const Duration(days: 1))),
          Activity(
              type: 'Pemupukan',
              date: DateTime.now().subtract(const Duration(days: 5))),
        ],
      ),
      Plant(
        id: '2',
        name: 'Wortel',
        imageUrl: 'https://via.placeholder.com/150',
        plantingDate: DateTime.now().subtract(const Duration(days: 60)),
        wateringIntervalDays: 2,
        fertilizingIntervalDays: 20,
        activities: [
          Activity(
              type: 'Penyiraman',
              date: DateTime.now().subtract(const Duration(days: 2))),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Tanaman Saya'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading Section
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.eco,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hai, Pemilik Tanaman',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Lihat aktivitas tanamanmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Plant List Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plants.length,
              itemBuilder: (ctx, index) {
                final plant = plants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        plant.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      plant.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      "Aktivitas: ${plant.activities.length} kali",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.green),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => PlantDetailsScreen(plant: plant),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({required this.plant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    final int plantAge = DateTime.now().difference(plant.plantingDate).inDays;
    final DateTime nextWatering = plant.activities
            .where((a) => a.type == 'Penyiraman')
            .isNotEmpty
        ? plant.activities
            .lastWhere((a) => a.type == 'Penyiraman')
            .date
            .add(Duration(days: plant.wateringIntervalDays))
        : plant.plantingDate.add(Duration(days: plant.wateringIntervalDays));

    final DateTime nextFertilizing = plant.activities
            .where((a) => a.type == 'Pemupukan')
            .isNotEmpty
        ? plant.activities
            .lastWhere((a) => a.type == 'Pemupukan')
            .date
            .add(Duration(days: plant.fertilizingIntervalDays))
        : plant.plantingDate.add(Duration(days: plant.fertilizingIntervalDays));

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  plant.imageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Progres Tanaman',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('Umur Tanaman: $plantAge hari'),
            Text(
                'Jadwal Penyiraman Berikutnya: ${dateFormat.format(nextWatering)}'),
            Text(
                'Jadwal Pemupukan Berikutnya: ${dateFormat.format(nextFertilizing)}'),
            const SizedBox(height: 16),
            Text(
              'Aktivitas Terakhir',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: plant.activities.length,
                itemBuilder: (ctx, index) {
                  final activity = plant.activities[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      activity.type,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      dateFormat.format(activity.date),
                    ),
                    leading:
                        const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
