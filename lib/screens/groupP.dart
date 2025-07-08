// groupP.dart (Potato Group Page)
import 'package:flutter/material.dart';

class GroupPotatoPage extends StatefulWidget {
  @override
  _GroupPotatoPageState createState() => _GroupPotatoPageState();
}

class _GroupPotatoPageState extends State<GroupPotatoPage> {
  final List<Map<String, String>> posts = [
    {
      'title': 'Potato Late Blight Warning',
      'desc': 'Potato late blight is a serious fungal-like disease caused by Phytophthora infestans that affects potato plants, especially in cool, wet conditions. It appears as dark, water-soaked lesions on leaves and stems, eventually leading to rapid plant decay. If not controlled, it can cause significant crop loss.',
      'image': 'assets/lateblight.jpeg'
    },
    {
      'title': 'Potato Late Blight Warning',
      'desc': 'Potato late blight is a serious fungal-like disease caused by Phytophthora infestans that affects potato plants, especially in cool, wet conditions. It appears as dark, water-soaked lesions on leaves and stems, eventually leading to rapid plant decay. If not controlled, it can cause significant crop loss.',
      'image': 'assets/lateblight.jpeg'
    },
    {
      'title': 'Potato Late Blight Warning',
      'desc': 'Potato late blight is a serious fungal-like disease caused by Phytophthora infestans that affects potato plants, especially in cool, wet conditions. It appears as dark, water-soaked lesions on leaves and stems, eventually leading to rapid plant decay. If not controlled, it can cause significant crop loss.',
      'image': 'assets/lateblight.jpeg'
    },
  ];

  final Set<int> expandedPosts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // ensures back button is white
  title: Text(
    'Potato Community',
    style: TextStyle(color: Colors.white), // makes title text white
  ),
        backgroundColor: Color(0xFF116736),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final isExpanded = expandedPosts.contains(index);
          return Card(
  color: Color(0xFFF5F5F5), // Light grey background (darker than default white)
  elevation: 4, // Adds shadow
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8), // Optional: rounded corners
  ),
  margin: EdgeInsets.only(bottom: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          post['title']!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      if (post['image'] != null)
        ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Image.asset(
            post['image']!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['desc']!,
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if (isExpanded) {
                      expandedPosts.remove(index);
                    } else {
                      expandedPosts.add(index);
                    }
                  });
                },
                child: Text(
                  isExpanded ? 'Read less' : 'Read more',
                  style: TextStyle(color: Color(0xFF116736)),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Color(0xFF116736),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/homepage');
              break;
            case 1:
              Navigator.pushNamed(context, '/report');
              break;
            case 2:
              Navigator.pushNamed(context, '/scan');
              break;
            // case 3:
            //   Navigator.pushNamed(context, '/alert');
            //   break;
            case 3:
              Navigator.pushNamed(context, '/support');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Scan"),
          // BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alert"),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
        ],
      ),
    );
  }
}