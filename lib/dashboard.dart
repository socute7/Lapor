import 'package:flutter/material.dart';
import 'package:myapps/setting.dart';
import 'api_service.dart';
import 'profile.dart';
import 'detail_page.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _originalData = [];
  String _searchQuery = '';

  late PageController _pageController =
      PageController(initialPage: 2, viewportFraction: 0.2);

  @override
  void initState() {
    super.initState();
    refreshData();
    _pageController.addListener(_onPageViewScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageViewScroll() {
    if (_pageController.page == _pageController.position.maxScrollExtent) {
      _pageController.animateToPage(
        2,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> refreshData() async {
    try {
      var data = await _apiService.fetchData();
      setState(() {
        _originalData = data;
      });
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> getFilteredData() {
    if (_searchQuery.isEmpty) {
      return _originalData;
    } else {
      return _originalData.where((item) {
        return item['judul'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = getFilteredData();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
              child: SizedBox(
                height: 56.0,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: _filterData,
                ),
              ),
            ),
            // Promo section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://as2.ftcdn.net/v2/jpg/02/92/36/71/1000_F_292367179_T5xBfw6nJBwJ0HE8wfwz20QuYfOrIm8b.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    'EXPLOSIVE REACTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Menu section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(8, (index) {
                    List<IconData> icons = [
                      Icons.signpost,
                      Icons.water,
                      Icons.landslide,
                      Icons.volcano,
                      Icons.flash_off,
                      Icons.healing,
                      Icons.traffic,
                      Icons.build,
                    ];
                    List<String> labels = [
                      "Jalan",
                      "Sungai",
                      "Tanah Longsor",
                      "Gunung",
                      "Listrik",
                      "Kesehatan",
                      "Lampu Lalulintas",
                      "Equipment",
                    ];
                    return Column(
                      children: [
                        IconButton(
                          icon: Icon(icons[index], size: 30),
                          onPressed: () {},
                        ),
                        Text(labels[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ],
                    );
                  }),
                ),
              ),
            ),
            // Horizontal List of items
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    final imagePath = item['imagePath'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(item: item),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.only(right: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                                child: Image.network(
                                  imagePath,
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        item['judul'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['status'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          item['tanggal'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingPage();
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    DashboardWidget(),
    SettingWidget(),
    ProfileWidget(),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print('FloatingActionButton pressed');
          Navigator.pushNamed(context, '/tambah');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
