import 'dart:io';

import 'package:first_flutter_project/data/contact.dart';
import 'package:first_flutter_project/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: use_key_in_widget_constructors
class ContactForm extends StatefulWidget {
  // ignore: annotate_overrides

  final Contact? editedContact;
  //final int? editedContactIndex;

  // ignore: prefer_const_constructors_in_immutables
  ContactForm({
    Key? key,
    this.editedContact,
    //this.editedContactIndex,
  }) : super(key: key);

  // ignore: annotate_overrides
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  File? _contactImageFile;

  bool get isEditMode => widget.editedContact != null;
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          /*
        Container(
          margin: EdgeInsets.fromLTRB(width / 20, 20, width / 20, 10),
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Color(0xFFD0D0D0),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isTappedOneWay = true;
                      isTappedRoundTrip = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: isTappedOneWay
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFFD0D0D0),
                      boxShadow: isTappedOneWay
                          ? const [
                              BoxShadow(
                                color: Color(0x22000000),
                                offset: Offset(0, 1),
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      "Aller uniquement",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isTappedOneWay
                            ? const Color(0xFF146CC2)
                            : const Color(0xFF212121),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isTappedOneWay = false;
                      isTappedRoundTrip = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: isTappedRoundTrip
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFFD0D0D0),
                      boxShadow: isTappedRoundTrip
                          ? const [
                              BoxShadow(
                                color: Color(0x22000000),
                                offset: Offset(0, 1),
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      "Aller - Retour",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isTappedRoundTrip
                            ? const Color(0xFF146CC2)
                            : const Color(0xFF212121),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        */
          const SizedBox(height: 10),
          _buildContactPicture(),
          const SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _name = newValue!,
            keyboardType: TextInputType
                .name, // affiche le clavier adapté à la saisie d'email
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: _validateName,
            initialValue: widget.editedContact?.name,
          ),
          const SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _email = newValue!,
            keyboardType: TextInputType
                .emailAddress, // affiche le clavier adapté à la saisie d'email
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: _validateEmail,
            initialValue: widget.editedContact?.email,
          ),
          const SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _phoneNumber = newValue!,
            keyboardType: TextInputType
                .phone, // affiche le clavier adapté à la saisie d'email
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: _validatePhoneNumber,
            initialValue: widget.editedContact?.phoneNumber,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _onSavedContactButtonPressed,
            style: ElevatedButton.styleFrom(
              minimumSize:
                  const Size(150, 50), // Définir la taille minimale du bouton
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Définir l'espacement interne
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Définir la forme de la bordure
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Save Contact'),
                Icon(
                  Icons.person,
                  size: 18,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactPicture() {
    /*String firstChar = '';
    if (widget.editedContact?.name != null &&
        widget.editedContact!.name.isNotEmpty) {
      firstChar = widget.editedContact!.name[0];
    }*/
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactImageTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleAvatarContent(halfScreenDiameter),
        ),
      ),
    );
  }

  ImagePicker imagePicker = ImagePicker();
  void _onContactImageTapped() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _contactImageFile = File(pickedFile!.path);
    });
  }

  Widget _buildCircleAvatarContent(double halfScreenDiameter) {
    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0],
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            _contactImageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    if (value == null || value.isEmpty) {
      return 'Enter an email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumberRegex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    } else if (!phoneNumberRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  void _onSavedContactButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newOrEditedContact = Contact(
        email: _email,
        name: _name,
        phoneNumber: _phoneNumber,
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );
      if (isEditMode) {
        newOrEditedContact.idContact = widget.editedContact!.idContact;
        ScopedModel.of<ContactsModel>(context).updateContact(
          newOrEditedContact,
          //widget.editedContactIndex!,
        );
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newOrEditedContact);
      }
      Navigator.of(context).pop();
    }
  }
}
