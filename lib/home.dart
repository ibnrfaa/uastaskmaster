import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:myapp/sub_task.dart';
import 'profile.dart';

class ToDoItem {
  String title;
  String description;
  DateTime fromDate;
  DateTime toDate;
  String category;
  final List<String> teamMembers;
  String location;
  bool done;

  ToDoItem({
    required this.title,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.category,
    required this.teamMembers,
    required this.location,
    this.done = false,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _tasks = <ToDoItem>[]; // List untuk menyimpan tugas
  final _categories = ['Work', 'Sport', 'Personal']; // Kategori tugas
  String _userName = 'User'; // Nama pengguna
  String _userEmail = 'My Dream'; 

  // Daftar gambar untuk banner
  final List<String> _bannerImages = [
    'assets/karir.png',
    'assets/karir2.jpg',
    'assets/karir3.jpg',
  ];

  late PageController _pageController; // Kontrol untuk PageView
  int _currentBannerIndex = 0; // Indeks banner yang sedang ditampilkan
  late Timer _bannerTimer; // Timer untuk auto-slide

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentBannerIndex); // Inisialisasi PageController
    _startBannerTimer(); // Mulai timer untuk auto-slide
  }

  @override
  void dispose() {
    _pageController.dispose(); // Bersihkan PageController
    _bannerTimer.cancel(); // Hentikan timer
    super.dispose();
  }

  // Memulai timer untuk mengganti banner otomatis
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length; // Pergantian indeks banner
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500), // Durasi animasi perpindahan
          curve: Curves.easeInOut, // Kurva animasi
        );
      });
    });
  }

  // Widget untuk menampilkan banner
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16), // Margin luar banner
      height: 180, // Tinggi banner
      child: PageView.builder(
        controller: _pageController,
        itemCount: _bannerImages.length, // Jumlah banner
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), // Membulatkan sudut banner
              image: DecorationImage(
                image: AssetImage(_bannerImages[index]), // Gambar banner
                fit: BoxFit.cover, // Menyesuaikan ukuran gambar
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index; // Perbarui indeks banner saat digeser
          });
        },
      ),
    );
  }

  // Widget untuk indikator posisi banner
  Widget _buildBannerIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _bannerImages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Durasi animasi indikator
          margin: const EdgeInsets.symmetric(horizontal: 4), // Spasi antar indikator
          width: _currentBannerIndex == index ? 12 : 8, // Lebar indikator aktif dan tidak aktif
          height: 8, // Tinggi indikator
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Bentuk lingkaran
            color: _currentBannerIndex == index
                ? Colors.blue // Warna indikator aktif
                : Colors.grey.withOpacity(0.5), // Warna indikator tidak aktif
          ),
        ),
      ),
    );
  }

  // Widget untuk daftar tugas
// Widget untuk daftar tugas
Widget _buildTaskList() {
  return ListView.builder(
    itemCount: _tasks.length,
    itemBuilder: (context, index) {
      final task = _tasks[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: IntrinsicHeight( // Membatasi tinggi widget agar sesuai konten
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 123, 179, 224), 
                child: Text(task.category[0], style: const TextStyle(color: Colors.white)),
              ),
              title: Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1, // Membatasi jumlah baris untuk title
                overflow: TextOverflow.ellipsis, // Menambahkan elipsis jika teks terlalu panjang
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.description}\n'
                    '${task.fromDate.toLocal().toString().split(' ')[0]} - '
                    '${task.toDate.toLocal().toString().split(' ')[0]}',
                    maxLines: 2, // Membatasi jumlah baris untuk description
                    overflow: TextOverflow.ellipsis, // Menambahkan elipsis jika teks terlalu panjang
                  ),
                ],
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min, // Pastikan ukuran seminimal mungkin
                children: [
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editTask(task),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubTaskScreen(task: task),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}


// Fungsi untuk mengedit tugas
void _editTask(ToDoItem task) {
  // Menampilkan dialog untuk mengedit tugas
  final titleController = TextEditingController(text: task.title);
  final descriptionController = TextEditingController(text: task.description);
  DateTime? fromDate = task.fromDate;
  DateTime? toDate = task.toDate;
  String category = task.category;
  String location = task.location;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        fromDate = await showDatePicker(
                            context: context,
                            initialDate: task.fromDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      child: const Text('From Date'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        toDate = await showDatePicker(
                            context: context,
                            initialDate: task.toDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      child: const Text('To Date'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: category,
                onChanged: (value) => category = value!,
                items: _categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => location = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      fromDate != null &&
                      toDate != null) {
                    setState(() {
                      task.title = titleController.text;
                      task.description = descriptionController.text;
                      task.fromDate = fromDate!;
                      task.toDate = toDate!;
                      task.category = category;
                      task.location = location;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Fungsi untuk menghapus tugas
void _deleteTask(int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeAt(index); // Menghapus tugas dari daftar
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}



  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? fromDate;
    DateTime? toDate;
    String category = _categories.first;
    String location = '';
    final teamMembers = <String>[];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add New Task',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          fromDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        child: const Text('From Date'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          toDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        child: const Text('To Date'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: category,
                  onChanged: (value) => category = value!,
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (value) => location = value,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        fromDate != null &&
                        toDate != null) {
                      _addTask(ToDoItem(
                        title: titleController.text,
                        description: descriptionController.text,
                        fromDate: fromDate!,
                        toDate: toDate!,
                        category: category,
                        teamMembers: teamMembers,
                        location: location,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTask(ToDoItem task) => setState(() => _tasks.add(task));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Master'),
        
        actions: [
           Text(
            _userName, // Menampilkan nama pengguna
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: _navigateToProfile),
        ],
      ),
      body: Column(
        children: [
          _buildBanner(), // Banner dengan auto-slide
          _buildBannerIndicator(), // Indikator posisi banner
          Expanded(child: _buildTaskList()), // Daftar tugas
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userName: _userName,
          userEmail: _userEmail,
          onProfileUpdated: (updatedProfile) {
            setState(() {
              _userName = updatedProfile['name'] ?? '';
              _userEmail = updatedProfile['email'] ?? '';
            });
          },
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }
} 