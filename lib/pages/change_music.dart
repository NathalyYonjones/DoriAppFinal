import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChangeMusicPage extends StatefulWidget {
  final Profile user;
  final AppUser appUser;

  const ChangeMusicPage({super.key, required this.user, required this.appUser});

  @override
  State<ChangeMusicPage> createState() => _ChangeMusicPageState();
}

class _ChangeMusicPageState extends State<ChangeMusicPage> {
  String? _uploadStatus = '';
  List<Audio> _audioFiles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;

  @override
  void initState() {
    super.initState();
    _fetchAudioFiles();
  }

  Future<void> _fetchAudioFiles() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child('audio/');

    try {
      ListResult result = await storageRef.listAll();
      List<Audio> approvedFileNames = [];

      for (var item in result.items) {
        FullMetadata metadata = await item.getMetadata();
        bool isApproved = metadata.customMetadata?['aproved'] == 'true';
        // Include all files if isAdmin is true, otherwise only include approved files
        if (widget.appUser.isAdmin! || isApproved) {
          approvedFileNames.add(Audio(name: item.name, isAccepted: isApproved));
        }
      }

      setState(() {
        _audioFiles = approvedFileNames;
      });
    } catch (e) {
      setState(() {
        _uploadStatus = 'Failed to load audio files: $e';
      });
    }
  }

  Future<void> _playAudio(String fileName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = await storage.ref().child('audio/$fileName').getDownloadURL();

    if (_currentlyPlaying != fileName) {
      _audioPlayer.stop();
      setState(() {
        _currentlyPlaying = fileName;
      });
    }

    _audioPlayer.play(UrlSource(url));
  }

  Future<void> _acceptSong(String fileName, BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('audio/$fileName');

    try {
      SettableMetadata newMetadata = SettableMetadata(
        contentType: 'audio/mp3',
        customMetadata: {
          'aproved': 'true',
        },
      );
      await ref.updateMetadata(newMetadata);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canción aceptada.')),
        );
      }

      _fetchAudioFiles();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al aceptar la canción.')),
        );
      }
    }
  }

  Future<void> _rejectSong(String fileName, BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('audio/$fileName');

    try {
      await ref.delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canción eliminada.')),
        );
      }

      _fetchAudioFiles();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la canción.')),
        );
      }
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('audio/${file.name}');

      try {
        SettableMetadata metadata = SettableMetadata(
          contentType: 'audio/mp3',
          customMetadata: {
            'uploaded_by': widget.appUser.name!,
            'aproved': 'false',
          },
        );

        UploadTask uploadTask = ref.putFile(
          File(file.path!),
          metadata,
        );

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          setState(() {
            _uploadStatus = 'Subiendo: ${progress.toStringAsFixed(2)}% completado';
          });
        });

        await uploadTask.whenComplete(() async {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Archivo subido correctamente. Esperando aprobación.'),
              ),
            );
          });
        });
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir el archivo.')),
          );
        }
      }
    } else {
      setState(() {
        _uploadStatus = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets().buildProfileAppBar(
        widget.user.name!,
        context,
        isMainPage: true,
        image: widget.user.image!,
        title: 'Cambiar música',
        user: widget.user,
        appUser: widget.appUser,
      ),
      backgroundColor: CustomColors.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _audioFiles.isEmpty
                    ? const Center(child: Text('No hay archivos de música'))
                    : ListView.builder(
                        itemCount: _audioFiles.length,
                        itemBuilder: (context, index) {
                          String fileName = _audioFiles[index].name!;
                          bool isApproved = _audioFiles[index].isAccepted!;
                          return ListTile(
                            title: Text(fileName),
                            leading: const Icon(Icons.audiotrack),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Play/Pause button
                                IconButton(
                                  icon: Icon(
                                    _currentlyPlaying == fileName
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    if (_currentlyPlaying == fileName) {
                                      _audioPlayer.pause();
                                      setState(() {
                                        _currentlyPlaying = null;
                                      });
                                    } else {
                                      _playAudio(fileName);
                                    }
                                  },
                                ),
                                // Admin controls (Accept/Reject)
                                if (widget.appUser.isAdmin!)
                                  if (isApproved)
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _rejectSong(fileName, context),
                                    )
                                  else ...[
                                    IconButton(
                                      icon: const Icon(Icons.check, color: Colors.green),
                                      onPressed: () => _acceptSong(fileName, context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () => _rejectSong(fileName, context),
                                    ),
                                  ]
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Text(_uploadStatus ?? ''),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadFile(context),
                child: const Text('Subir archivo de música'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
