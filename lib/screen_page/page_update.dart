import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_uasp/screen_page/page_listpegawai.dart';
import '../model/model_pegawai.dart';

class PageEditEmployee extends StatefulWidget {
  final Datum employee;

  const PageEditEmployee({required this.employee});

  @override
  _PageEditEmployeeState createState() => _PageEditEmployeeState();
}

class _PageEditEmployeeState extends State<PageEditEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtFirstname = TextEditingController();
  final TextEditingController _txtLastname = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();

  String? gender;
  String? statuspegawai;

  @override
  void initState() {
    super.initState();
    _txtFirstname.text = widget.employee.firstname;
    _txtLastname.text = widget.employee.lastname;
    _txtPhone.text = widget.employee.nohp;
    _txtEmail.text = widget.employee.email;
    gender = widget.employee.gender;
    statuspegawai = widget.employee.statuspegawai;
  }

  @override
  void dispose() {
    _txtFirstname.dispose();
    _txtLastname.dispose();
    _txtPhone.dispose();
    _txtEmail.dispose();
    super.dispose();
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.43.124/latihanuasp/updatePegawai.php'),
          body: {
            'id': widget.employee.id.toString(),
            'firstname': _txtFirstname.text,
            'lastname': _txtLastname.text,
            'nohp': _txtPhone.text,
            'email': _txtEmail.text,
            'gender': gender,
            'statuspegawai': statuspegawai,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['value'] == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageUtama()),
                  (Route<dynamic> route) => false,
            );
          } else {
            _showErrorDialog(jsonResponse['message']);
          }
        } else {
          _showErrorDialog('An error occurred while sending data to the server');
        }
      } catch (error) {
        _showErrorDialog('An error occurred: $error');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: _txtFirstname,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _txtLastname,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _txtPhone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gender"),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'P',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('P'),
                      Radio<String>(
                        value: 'L',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('L'),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Status Pegawai"),
                  DropdownButtonFormField<String>(
                    value: statuspegawai,
                    items: [
                      DropdownMenuItem(
                        child: Text("Pegawai Tetap"),
                        value: "Pegawai Tetap",
                      ),
                      DropdownMenuItem(
                        child: Text("Non Tetap"),
                        value: "Non Tetap",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        statuspegawai = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEmployee,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
