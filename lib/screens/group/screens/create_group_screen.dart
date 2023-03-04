import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/constants/utils.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/screens/toppages/chat/colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  List peopleUid = [];
  List people = [];
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void refresh() async {
    people = [];
    for (var e in peopleUid) {
      UserModel userModel = UserModel.getValuesFromSnap(
          await firebaseFirestore.collection("users").doc(e).get());
      people.add(userModel);
    }
    setState(() {});
  }

  void createGroup() {
    // if (groupNameController.text.trim().isNotEmpty && image != null) {
    //   ref.read(groupControllerProvider).createGroup(
    //         context,
    //         groupNameController.text.trim(),
    //         image!,
    //         ref.read(selectedGroupContacts),
    //       );
    //   ref.read(selectedGroupContacts.state).update((state) => []);
    //   Navigator.pop(context);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: people.isEmpty ? createGroup : null,
              icon: Icon(
                Icons.done,
                color: people.isEmpty ? Colors.grey : Colors.white,
              ),
            )
          ],
          title: const Text('Create Group'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            staticPhotoUrl,
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            image!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.photo_camera,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: groupNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Group Name',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Group Participants:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              people.isEmpty
                  ? const Center(
                      child: Text("No Participants added"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        return getContactCard(people[index], context, false,
                            shouldShow: false);
                      })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showPeopleForTask(context, peopleUid, refresh);
          },
          label: const Text('Add People'),
          icon: const Icon(Icons.people),
          backgroundColor: mainColor,
        ));
  }
}
