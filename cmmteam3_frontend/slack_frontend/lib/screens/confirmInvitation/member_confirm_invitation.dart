import 'package:flutter/material.dart';
import 'package:flutter_frontend/componnets/Nav.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/screens/Login/login_form.dart';
import 'package:flutter_frontend/services/confirmInvitation/confirm_member_invitation.dart';
import 'package:flutter_frontend/model/confirm.dart';
import 'package:flutter_frontend/services/confirmInvitation/confirm_invitation_service.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class ConfirmPage extends StatelessWidget {
  final int? channelId;
  final String? email;
  final int? workspaceId;

  const ConfirmPage({Key? key, this.channelId, this.email, this.workspaceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _apiService = MemberInvitation();

    String? name;
    String? password;
    String? confirmPassword;
    String? channelName;
    String? workspaceName;

    void _submitForm(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
          _apiService.memberInvitationConfirm(
              password.toString(),
              confirmPassword.toString(),
              name.toString(),
              email!,
              channelName!,
              workspaceName!);
        } catch (e) {
          SnackBar(
              content: Text(
            '${e}',
            style: const TextStyle(backgroundColor: Colors.red),
          ));
        } finally {
          context.go('/');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navColor,
        title: Center(child: const Text('Confirm Invitation'))),
      body: FutureBuilder<Confirm>(
          future: ConfirmInvitationService(Dio())
              .getConfirmData(channelId!, email!, workspaceId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProgressionBar(
                  imageName: 'waiting.json', height: 200, size: 200);
            } else {
              var muser = snapshot.data;
              channelName = muser!.mUser!.profileImage;
              workspaceName = muser.mUser!.rememberDigest;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          initialValue: channelName,
                          enabled: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: email,
                          enabled: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: workspaceName,
                          enabled: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'Enter Your Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Your Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Enter Your Password again',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            _submitForm(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.lightBlue),
                          ),
                          child: const Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
