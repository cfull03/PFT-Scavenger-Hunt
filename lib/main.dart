import 'package:flutter/material.dart';

void main() {
  runApp(PFTScavengerHuntApp());
}

class PFTScavengerHuntApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PFT Scavenger Hunt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> locations = [
    "Cambre Atrium",
    "Roy O. Martin Auditorium",
    "Unit Operations Lab",
    "Robotics Lab",
    "Geotech Lab",
    "EE Microgrid + Relay",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PFT Scavenger Hunt")),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(locations[index]),
            trailing: Icon(Icons.play_arrow),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(location: locations[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String location;
  GameScreen({required this.location});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController answerController = TextEditingController();
  String feedbackMessage = "";

  final Map<String, String> locationClues = {
    "Cambre Atrium": "This area has 30 classrooms and a large auditorium.",
    "Roy O. Martin Auditorium": "Holds up to 250 people for events and talks.",
    "Unit Operations Lab": "Where chemical processes are tested at scale.",
    "Robotics Lab": "Home to advanced automation and mechanical design.",
    "Geotech Lab": "Soil and rock behavior are studied here.",
    "EE Microgrid + Relay": "A hub for studying smart grids and power systems.",
  };

  final Map<String, String> correctAnswers = {
    "Cambre Atrium": "atrium",
    "Roy O. Martin Auditorium": "auditorium",
    "Unit Operations Lab": "chemical",
    "Robotics Lab": "robotics",
    "Geotech Lab": "soil",
    "EE Microgrid + Relay": "power",
  };

  void checkAnswer() {
    String userAnswer = answerController.text.trim().toLowerCase();
    if (userAnswer == correctAnswers[widget.location]?.toLowerCase()) {
      setState(() {
        feedbackMessage = "✅ Correct! Well done!";
      });
    } else {
      setState(() {
        feedbackMessage = "❌ Incorrect. Try again!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scavenger Hunt - ${widget.location}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locationClues[widget.location] ?? "Find the hidden clue!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter your answer",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkAnswer,
              child: Text("Submit Answer"),
            ),
            SizedBox(height: 10),
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 16,
                color: feedbackMessage.contains("✅") ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
