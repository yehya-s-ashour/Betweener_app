import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';

import 'widgets/custom_text_form_field.dart';

class AddLinkView extends StatefulWidget {
  static const id = '/addLinkView';

  const AddLinkView({super.key});

  @override
  State<AddLinkView> createState() => _AddLinkViewState();
}

class _AddLinkViewState extends State<AddLinkView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void submitLink() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'title': titleController.text,
        'link': linkController.text,
      };

      addLink(body).then((link) async {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kLinksColor.withOpacity(0.6),
            title: Text(
              'Add Link',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            )),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 350,
                  child: CustomTextFormField(
                    onChanged: (p0) {},
                    controller: titleController,
                    hint: 'Instagram,Facebook,...',
                    label: 'Title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Center(
                child: SizedBox(
                  width: 350,
                  child: CustomTextFormField(
                    onChanged: (p0) {},
                    controller: linkController,
                    hint: 'www.example.com',
                    label: 'Link',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the link';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(kSecondaryColor)),
                  onPressed: submitLink,
                  child: Text(
                    'Add Link',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
