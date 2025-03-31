import 'package:flutter/material.dart';
import 'animate_gradient.dart';
import 'dart:async';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/wallpaper1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Title positioned lower
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Text(
              'Workout Tracker',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 98, 88, 88),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Settings button at the top right
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
          // Subtitle and buttons
          Column(
            children: [
              SizedBox(height: 190), // Space below the title and settings icon
              Text(
                'Track your workouts and progress.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 98, 88, 88),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 450), // Adjust this space to move buttons lower on the page
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FitnessButton(label: 'Workouts', page: WorkoutTrackerPage()), 
                      FitnessButton(label: 'Cooldown', page: CooldownPage()), 
                      FitnessButton(label: 'Progress', page: ProgressTrackerPage()), 
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FitnessButton(label: 'Calories', page: CaloriesTrackerPage()), 
                      FitnessButton(label: 'Meals', page: MealPlannerPage()), 
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}

class FitnessButton extends StatelessWidget {
  final String label;
  final Widget page;

  FitnessButton({required this.label, required this.page});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(label),
    );
  }
}



class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _gender;
  double? _bmi;

  void _calculateBMI() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/lightblue.jpg'), // Use your image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content with AppBar and form fields
          Column(
            children: [
              // Transparent AppBar with back button
              AppBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Form content with scrollable view
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        value: _gender,
                        items: ['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_ageController, 'Age'),
                      SizedBox(height: 20),
                      _buildTextField(_heightController, 'Height (cm)'),
                      SizedBox(height: 20),
                      _buildTextField(_weightController, 'Weight (kg)'),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _calculateBMI,
                          child: Text('Calculate BMI'),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_bmi != null)
                        Center(
                          child: Text(
                            'Your BMI is: ${_bmi!.toStringAsFixed(1)}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }
}

  

  
// Workout tracker page

class WorkoutTrackerPage extends StatefulWidget {
  @override
  _WorkoutTrackerPageState createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> {
  final List<Map<String, String>> _workouts = [];

  final _dateController = TextEditingController();
  final _activityController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _timeController = TextEditingController();
  final _distanceController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _activityController.dispose();
    _caloriesController.dispose();
    _timeController.dispose();
    _distanceController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _addWorkout() {
    setState(() {
      _workouts.add({
        'Date': _dateController.text,
        'Activity': _activityController.text,
        'Calories': _caloriesController.text,
        'Time': _timeController.text,
        'Distance': _distanceController.text,
        'Sets': _setsController.text,
        'Reps': _repsController.text,
        'Weight': _weightController.text,
      });
    });

    _dateController.clear();
    _activityController.clear();
    _caloriesController.clear();
    _timeController.clear();
    _distanceController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/workouttracker2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content with AppBar and workout tracker
          Column(
            children: [
              AppBar(
                title: Text(
                  'Workout Tracker',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold title
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Row with GIFs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/gym2.gif',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'images/running.gif',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Track your workouts here!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildInputForm(),
                        SizedBox(height: 20),
                        _buildWorkoutTable(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Column(
      children: [
        _buildTextField(_dateController, 'Date (e.g., 2024-10-27)'),
        _buildTextField(_activityController, 'Activity'),
        _buildTextField(_caloriesController, 'Calories'),
        _buildTextField(_timeController, 'Time (e.g., 30 mins)'),
        _buildTextField(_distanceController, 'Distance (e.g., 5 km)'),
        _buildTextField(_setsController, 'Sets'),
        _buildTextField(_repsController, 'Reps'),
        _buildTextField(_weightController, 'Weight (e.g., 135 lbs)'),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addWorkout,
          child: Text('Add Workout'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.black),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold, // Bolden label text
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold, // Bolden input text
      ),
      enableSuggestions: false, // Disables suggestions and toolbar
      autocorrect: false, // Disables autocorrection
    ),
  );
}


  Widget _buildWorkoutTable() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Activity', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Calories', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Distance', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Sets', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Reps', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _workouts.map((workout) {
            return DataRow(cells: [
              DataCell(Text(workout['Date'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Activity'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Calories'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Time'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Distance'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Sets'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Reps'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(workout['Weight'] ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}



// Cooldown page with breathing exercise
class CooldownPage extends StatefulWidget {
  @override
  _CooldownPageState createState() => _CooldownPageState();
}

class _CooldownPageState extends State<CooldownPage> {
  int count = 3; // Initial countdown value for inhale
  bool isInhale = true; // To track if it's inhale or exhale
  bool hasStarted = false; // To check if countdown started
  bool isPaused = false; // To track if countdown is paused
  Timer? timer;

  void startCooldown() {
    timer?.cancel(); // Cancel any previous timer if active
    setState(() {
      hasStarted = true; // Set the start state to true when button is pressed
      isPaused = false; // Ensure it's not in paused state
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isInhale && count > 0) {
          count--; // Decrease inhale count
        } else if (isInhale && count == 0) {
          isInhale = false; // Switch to exhale
          count = 10; // Reset for exhale countdown
        } else if (!isInhale && count > 1) {
          count--; // Decrease exhale count
        } else if (!isInhale && count == 1) {
          count = 0; // Stop countdown and show "Well Done!"
          timer.cancel();
        }
      });
    });
  }

  void pauseCooldown() {
    timer?.cancel(); // Pause the timer
    setState(() {
      isPaused = true; // Indicate that the countdown is paused
    });
  }

  void resetCooldown() {
    timer?.cancel(); // Cancel any active timer
    setState(() {
      count = 3; // Reset count to 3 for inhale
      isInhale = true; // Reset to inhale phase
      hasStarted = false; // Indicate that it is not started yet
      isPaused = false; // Indicate that it is not paused
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimateGradient(
        primaryColors: [Colors.blue, const Color.fromARGB(255, 39, 176, 60)],
        secondaryColors: [const Color.fromARGB(255, 48, 176, 208), const Color.fromARGB(255, 164, 151, 193)],
        duration: Duration(seconds: 4),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Navigate back to HomePage
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80), // Adjust height to move title up closer to app bar
                  Text(
                    'Cooldown', // Title text
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Reduce space below the title
                  Text(
                    'Press start to begin cooldown breathing exercise.', // Subtitle text
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  if (hasStarted)
                    Text(
                      isInhale ? 'Inhale' : 'Exhale', // Display "Inhale" or "Exhale" depending on phase
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  SizedBox(height: 20),
                  if (hasStarted)
                    Text(
                      count == 0 && !isInhale
                          ? 'Well Done!' // Show "Well Done!" only at the end of exhale
                          : '$count', // Show countdown
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: hasStarted && !isPaused ? pauseCooldown : startCooldown,
                        child: Text(hasStarted && !isPaused ? 'Pause' : 'Start'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: resetCooldown,
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'This breathing exercise is the perfect tool to calm your body, slow your heart rate, and reduce stress after a vigorous workout. Simply breathe in for 3 seconds then exhale slowly for 10 seconds!',
                      style: TextStyle(fontSize: 17, color: Colors.white), // Text color set to white to match gradient
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel(); // Ensure to cancel the timer when the widget is disposed
    super.dispose();
  }
}

// Progress tracker page


class ProgressTrackerPage extends StatefulWidget {
  @override
  _ProgressTrackerPageState createState() => _ProgressTrackerPageState();
}

class _ProgressTrackerPageState extends State<ProgressTrackerPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _bodyWeightController = TextEditingController();
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newMaxController = TextEditingController();

  final List<Map<String, String>> _progressEntries = [];

  void _addProgress() {
    setState(() {
      _progressEntries.add({
        'Date': _dateController.text,
        'Body Weight': _bodyWeightController.text,
        'Workout': _workoutController.text,
        'Time': _timeController.text,
        'New Max': _newMaxController.text,
      });

      // Clear the fields after adding
      _dateController.clear();
      _bodyWeightController.clear();
      _workoutController.clear();
      _timeController.clear();
      _newMaxController.clear();
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/progresstracker.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content with AppBar and workout tracker
          Column(
            children: [
              AppBar(
                title: Text(
                  'Progress Tracker',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(_dateController, 'Date'),
                      _buildTextField(_bodyWeightController, 'Body Weight'),
                      _buildTextField(_workoutController, 'Workout'),
                      _buildTextField(_timeController, 'Time'),
                      _buildTextField(_newMaxController, 'New Max (e.g., 200 lbs)'),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addProgress,
                          child: Text('Add Progress'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _progressEntries.length,
                          itemBuilder: (context, index) {
                            final entry = _progressEntries[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: ${entry['Date']}'),
                                  Text('Body Weight: ${entry['Body Weight']}'),
                                  Text('Workout: ${entry['Workout']}'),
                                  Text('Time: ${entry['Time']}'),
                                  Text('New Max: ${entry['New Max']}'),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

  


// Calories tracker page

class CaloriesTrackerPage extends StatefulWidget {
  @override
  _CaloriesTrackerPageState createState() => _CaloriesTrackerPageState();
}

class _CaloriesTrackerPageState extends State<CaloriesTrackerPage> {
  final List<Map<String, dynamic>> _activities = []; // Start with an empty list
  DateTime? _selectedDate;

  void _addCalories() {
    // Opens a dialog for adding new activity data
    showDialog(
      context: context,
      builder: (context) {
        String activity = '';
        String calories = '';

        return AlertDialog(
          title: Text('Add Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date picker
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: _selectedDate == null ? 'Select Date' : _selectedDate!.toLocal().toString().split(' ')[0],
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedDate)
                        setState(() {
                          _selectedDate = picked;
                        });
                    },
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Activity'),
                onChanged: (value) {
                  activity = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Calories Burned'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calories = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (activity.isNotEmpty && calories.isNotEmpty && _selectedDate != null) {
                  setState(() {
                    _activities.add({
                      'date': _selectedDate!,
                      'activity': activity,
                      'calories': int.tryParse(calories) ?? 0,
                    });
                    _selectedDate = null; // Reset the date after adding
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories Tracker'),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/calories.jpg'), // Replace with your image path
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Table for displaying activities and calories burned
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blueGrey.shade100),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Activity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Calories Burned',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Dynamically generated rows from _activities list
                    ..._activities.map((activity) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(activity['date']?.toLocal().toString().split(' ')[0] ?? '-'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(activity['activity']),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${activity['calories']}'),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Button to add new activity
              ElevatedButton(
                onPressed: _addCalories,
                child: Text('Add Calories'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Meal planner page

class MealPlannerPage extends StatefulWidget {
  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  final List<Map<String, dynamic>> _meals = []; // Start with an empty list
  DateTime? _selectedDate;

  void _addMeal() {
    // Opens a dialog for adding new meal data
    showDialog(
      context: context,
      builder: (context) {
        String breakfast = '';
        String lunch = '';
        String dinner = '';
        String snacks = '';

        return AlertDialog(
          title: Text('Add Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date picker
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: _selectedDate == null ? 'Select Date' : _selectedDate!.toLocal().toString().split(' ')[0],
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedDate)
                        setState(() {
                          _selectedDate = picked;
                        });
                    },
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Breakfast'),
                onChanged: (value) {
                  breakfast = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Lunch'),
                onChanged: (value) {
                  lunch = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Dinner'),
                onChanged: (value) {
                  dinner = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Snacks'),
                onChanged: (value) {
                  snacks = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedDate != null) {
                  setState(() {
                    _meals.add({
                      'date': _selectedDate!,
                      'breakfast': breakfast,
                      'lunch': lunch,
                      'dinner': dinner,
                      'snacks': snacks,
                    });
                    _selectedDate = null; // Reset the date after adding
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/meal.jpg'), // Path to your background image
            fit: BoxFit.cover, // Cover the whole screen
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.black.withOpacity(0.1), // Semi-transparent black background for AppBar
              child: AppBar(
                title: Text('Meal Tracker'),
                backgroundColor: Colors.transparent, // Make AppBar transparent
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Table for displaying meals
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.blueGrey.shade100),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Breakfast',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Lunch',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Dinner',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Snacks',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Dynamically generated rows from _meals list
                          ..._meals.map((meal) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meal['date']?.toLocal().toString().split(' ')[0] ?? '-'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meal['breakfast'] ?? '-'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meal['lunch'] ?? '-'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meal['dinner'] ?? '-'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meal['snacks'] ?? '-'),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Button to add new meal
                    ElevatedButton(
                      onPressed: _addMeal,
                      child: Text('Add Meal'),
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
