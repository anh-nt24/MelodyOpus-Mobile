import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/services/song_service.dart';
import 'package:melodyopus/views/fragments/library_tab.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

class AddNewSong extends StatefulWidget {
  @override
  _AddNewSongState createState() => _AddNewSongState();
}

class _AddNewSongState extends State<AddNewSong> {
  final _formKey = GlobalKey<FormState>();

  String _songTitle = '';
  String _lyrics = ' ';
  File? _coverImage;
  File? _songFile;
  String _songFileName = '';
  DateTime? _releaseDate = DateTime.now();
  String _genre = 'Pop';
  final _genres = ['Pop', 'R&B', 'Jazz', 'Classical', 'Hip Hop', 'Other'];

  late SongService _songService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _songService = SongService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(
          'Add a New Song',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ))),
        backgroundColor: Color.fromRGBO(31, 31, 31, 0.09),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.white70,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              // Song Title
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Song Title',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _songTitle = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the song title';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),

              // Release Date
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Release Date',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _releaseDate == null
                          ? ''
                          : '${_releaseDate!.month.toString().padLeft(2, '0')}/${_releaseDate!.day.toString().padLeft(2, '0')}/${_releaseDate!.year}',
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the release date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Genre Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Genre',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                value: _genre,
                style: TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    _genre = newValue!;
                  });
                },
                items: _genres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Lyrics
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Lyrics (max 5000 words)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                maxLines: 7,
                onChanged: (value) {
                  setState(() {
                    _lyrics = value;
                  });
                },
                validator: (value) {
                  if (value != null && value.length > 5000) {
                    return 'Lyrics exceed 5000 characters';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),

              // Upload Cover Image
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickCoverImage,
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: _coverImage == null
                            ? Icon(
                          Icons.upload_file,
                          size: 50,
                          color: Color(0xFF7145F5),
                        )
                            : Image.file(
                          _coverImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Upload Song File
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickSongFile,
                      icon: Icon(Icons.music_note),
                      label: Text(_songFileName.length == 0 ? 'Upload Song File' : _songFileName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      submitSong();
                    }
                  },
                  height: 50,
                  // margin: EdgeInsets.symmetric(horizontal: 50),
                  color: Color(0xFF7145F5).withOpacity(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  // decoration: BoxDecoration(
                  // ),
                  child: Center(
                    child: Text("Submit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitSong() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User user = authProvider.user;
    try {
      Map<String, dynamic> bodyObject = {
        "title": _songTitle,
        "genre": _genre,
        "lyrics": _lyrics,
        "thumbnail": _coverImage!.path,
        "songFile": _songFile!.path,
        "jwt": user.jwt
      };
      await _songService.addNewSong(bodyObject);
      CustomSnackBar.show(
          context: context,
          content: "Song added successfully"
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LibraryTab())
      );
    } catch (e) {
      CustomSnackBar.show(
          context: context,
          content: e.toString()
      );
    }

  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _releaseDate)
      setState(() {
        _releaseDate = picked;
      });
  }


  void _pickCoverImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _coverImage = File(result.files.single.path!);
      });
    }
  }

  void _pickSongFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _songFile = File(result.files.single.path!);
        _songFileName = result.files.single.name;
      });
    }
  }
}

