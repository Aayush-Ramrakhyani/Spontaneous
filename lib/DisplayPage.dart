import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Displaypage extends StatefulWidget {
  const Displaypage({super.key});

  @override
  State<Displaypage> createState() => _DisplaypageState();
}

class _DisplaypageState extends State<Displaypage> {
  List<String> items = [];
  String? selectedCategory;
  String? Jokess = "";

  Future<List<String>> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse("https://api.chucknorris.io/jokes/categories"));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return List<String>.from(jsonResponse); 
      } else {
        throw Exception;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> Jokes(String category) async {
    try {
      var response = await http.get(Uri.parse("https://api.chucknorris.io/jokes/random?category=$category"));
      if (response.statusCode == 200) {
        Map<String,dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          Jokess = jsonResponse['value'];
        });
      } else {
        throw Exception;
      }
    } catch (e) {
      throw Exception(e);
    }
    
  }

  @override
  void initState() {
    super.initState();
    fetchCategories().then((value) {
      setState(() {
        items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jokes"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.tealAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: DropdownButton<String>(
                hint: Text("Select any Category"),
                value: selectedCategory,
                items: items.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  Jokes(newValue!);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("$Jokess"),
              )
          ],
        ),
      ),
    );
  }
}
