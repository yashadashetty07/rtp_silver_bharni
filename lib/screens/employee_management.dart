import 'package:flutter/material.dart';
import 'package:rtp_silver/models/employee.dart';
import 'package:rtp_silver/screens/home_page.dart';
import 'package:rtp_silver/screens/work_management.dart';
import 'package:rtp_silver/services/emp_database_service.dart'; // Update database service to handle employee data

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final EmpDatabaseService _empdataBaseService = EmpDatabaseService.instance;
  String? _employeeName;
  String? _employeePhoneNumber;
  bool _isMultiSelectMode = false;
  final Set<int> _selectedEmployees = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
              ),
              child: Text(
                'Navigation Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home Page'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Employees'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EmployeeManagement()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Works Management'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WorkManagement()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode ? _deleteSelectedButton() : _addEmployeeButton(),
      body: _employeesList(),
      backgroundColor: const Color.fromRGBO(248, 244, 225, 0.9),
    );
  }

  Widget _addEmployeeButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Add Employee",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Enter employee name",
                  ),
                  onChanged: (value) {
                    _employeeName = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Enter employee phone number",
                  ),
                  onChanged: (value) {
                    _employeePhoneNumber = value;
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_employeeName == null || _employeeName!.isEmpty || _employeePhoneNumber == null || _employeePhoneNumber!.isEmpty) return;
                    _empdataBaseService.addEmployee(_employeeName!, _employeePhoneNumber!);
                    setState(() {
                      _employeeName = null;
                      _employeePhoneNumber = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Done!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _deleteSelectedButton() {
    return FloatingActionButton(
      onPressed: _deleteSelectedEmployees,
      backgroundColor: Colors.red,
      child: const Icon(Icons.delete),
    );
  }

  Widget _employeesList() {
    return FutureBuilder<List<Employee>>(
      future: _empdataBaseService.getEmployees(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No employees available",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        List<Employee> employees = snapshot.data!;
        return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            Employee employee = employees[index];
            bool isSelected = _selectedEmployees.contains(employee.id);

            return GestureDetector(
              onTap: () {
                if (_isMultiSelectMode) {
                  _toggleSelection(employee.id);
                } else {
                  _showEditEmployeeDialog(employee);
                }
              },
              onLongPress: () {
                if (!_isMultiSelectMode) {
                  setState(() {
                    _isMultiSelectMode = true;
                    _selectedEmployees.add(employee.id);
                  });
                }
              },
              child: Card(
                elevation: 20,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(employee.name),
                  subtitle: Text(employee.phoneNumber),
                  trailing: _isMultiSelectMode
                      ? IconButton(
                    icon: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      _toggleSelection(employee.id);
                    },
                  )
                      : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteEmployeeDialog(employee);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleSelection(int employeeId) {
    setState(() {
      if (_selectedEmployees.contains(employeeId)) {
        _selectedEmployees.remove(employeeId);
      } else {
        _selectedEmployees.add(employeeId);
      }
    });
  }

  void _deleteSelectedEmployees() {
    for (int employeeId in _selectedEmployees) {
      _empdataBaseService.deleteEmployee(employeeId);
    }
    setState(() {
      _isMultiSelectMode = false;
      _selectedEmployees.clear();
    });
  }

  void _showEditEmployeeDialog(Employee employee) {
    final TextEditingController nameController = TextEditingController(text: employee.name);
    final TextEditingController phoneController = TextEditingController(text: employee.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: "Edit employee name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: "Edit employee phone number",
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final updatedName = nameController.text;
              final updatedPhone = phoneController.text;
              if (updatedName.isEmpty || updatedPhone.isEmpty) return;

              _empdataBaseService.updateEmployee(employee.id, updatedName, updatedPhone);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showDeleteEmployeeDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm to delete this employee?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _empdataBaseService.deleteEmployee(employee.id);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const EmployeeManagement(),
    const WorkManagement(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Work',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
