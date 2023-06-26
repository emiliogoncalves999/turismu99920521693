import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ListaTurismu extends StatefulWidget {
  const ListaTurismu({Key? key}) : super(key: key);

  @override
  _ListaTurismuState createState() => _ListaTurismuState();
}

class _ListaTurismuState extends State<ListaTurismu> {
  final List<Data> _dataList = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('API Data'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _showSearchDialog(context),
              ),
            ],
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('4'),
                ],
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _dataList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_dataList[index].title),
                            subtitle: Text(_dataList[index].description),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String id) {
    return ElevatedButton(
      onPressed: () => _loadData(id),
      child: Text('Button $id'),
    );
  }

  Future<void> _loadData(String id) async {
    setState(() {
      _isLoading = true;
    });

    final response = await Dio().get('https://api.example.com/data/$id');

    setState(() {
      final data = Data(
        title: response.data['title'],
        description: response.data['description'],
      );
      if (_searchQuery.isEmpty ||
          data.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          data.description.toLowerCase().contains(_searchQuery.toLowerCase())) {
        _dataList.add(data);
      }
      _isLoading = false;
    });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _search();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _search() {
    setState(() {
      _dataList.clear();
      _isLoading = true;
    });

    // Perform API search with _searchQuery
    // ...
    // Add matching data to _dataList

    setState(() {
      _isLoading = false;
    });
  }
}

class Data {
  final String title;
  final String description;

  Data({required this.title, required this.description});
}
