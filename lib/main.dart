import 'package:flutter/material.dart';
import 'package:college_alert_app/AddAlertScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CollegeAlertApp());
}

class CollegeAlertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Alert App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeScreen(),
    );
  }
}

final Map<String, Color> typeColors = {
  'Seminar': Colors.blue,
  'Exam': Colors.red,
  'Fest': Colors.orange,
  'Notice': Colors.green,
};

class Alert {
  final String title;
  final String description;
  final String type;
  final DateTime date;

  Alert({
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });

  Color get color => typeColors[type] ?? Colors.grey;
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedType;
  bool _sortByDateDesc = true;
  final ValueNotifier<String?> _selectedTypeNotifier = ValueNotifier(null);

  void _addAlert(
    String title,
    String description,
    String type,
    DateTime date,
  ) async {
    await FirebaseFirestore.instance.collection('alerts').add({
      'title': title,
      'description': description,
      'type': type,
      'date': Timestamp.fromDate(date),
    });
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: _selectedTypeNotifier,
            builder: (context, value, _) {
              return DropdownButton<String?>(
                hint: Text("Filter Type"),
                value: value,
                onChanged: (val) => _selectedTypeNotifier.value = val,
                items: [null, ...typeColors.keys].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type ?? "All"),
                  );
                }).toList(),
              );
            },
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              _sortByDateDesc ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            onPressed: () => setState(() => _sortByDateDesc = !_sortByDateDesc),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance.collection('alerts');
    final filteredQuery = _selectedType != null
        ? query.where('type', isEqualTo: _selectedType)
        : query;

    return Scaffold(
      appBar: AppBar(
        title: Text("College Alerts"),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: "College Alert App",
                applicationLegalese: "Copyright © 2023 Omar Ahmed Sami",
                applicationVersion: "1.0.0",
                children: [
                  Text("Created by Omar Ahmed Sami\nFor CodeAlpha Internship"),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ValueListenableBuilder<String?>(
              valueListenable: _selectedTypeNotifier,
              builder: (context, selectedType, _) {
                final baseQuery = FirebaseFirestore.instance.collection(
                  'alerts',
                );
                final filteredQuery = selectedType != null
                    ? baseQuery.where('type', isEqualTo: selectedType)
                    : baseQuery;

                return StreamBuilder<QuerySnapshot>(
                  stream: filteredQuery
                      .orderBy('date', descending: _sortByDateDesc)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No alerts yet."));
                    }

                    final alerts = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'alert': Alert(
                          title: data['title'] ?? '',
                          description: data['description'] ?? '',
                          type: data['type'] ?? '',
                          date: (data['date'] as Timestamp).toDate(),
                        ),
                        'docId': doc.id,
                      };
                    }).toList();

                    return ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alertData = alerts[index];
                        final alert = alertData['alert'] as Alert;
                        final docId = alertData['docId'] as String;

                        return Dismissible(
                          key: Key(alert.title + alert.date.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) async {
                            await FirebaseFirestore.instance
                                .collection('alerts')
                                .doc(docId)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Alert deleted.")),
                            );
                          },
                          child: Card(
                            color: alert.color.withAlpha(25),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: alert.color,
                                child: Icon(Icons.event, color: Colors.white),
                              ),
                              title: Text(
                                alert.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${alert.type} • ${alert.date.toLocal().toString().split(' ')[0]}",
                              ),
                              trailing: Icon(
                                Icons.notifications_active,
                                color: alert.color,
                              ),
                            ),
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
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Alert"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlertScreen(onAdd: _addAlert),
            ),
          );
        },
      ),
    );
  }
}
