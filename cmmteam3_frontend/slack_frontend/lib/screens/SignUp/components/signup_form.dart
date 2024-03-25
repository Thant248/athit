import 'package:flutter/material.dart';
import 'package:flutter_frontend/componnets/already_have_an_account_acheck.dart';
import 'package:flutter_frontend/constants.dart';
import 'package:flutter_frontend/progression.dart';
import 'package:flutter_frontend/screens/Login/login_form.dart';
import 'package:flutter_frontend/services/userservice/api_controller_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = AuthController();

  bool _isLoading = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _workSpaceName,
      _channelName,
      _name,
      _email,
      _password,
      _passwordConfirmation;

  void _submitForm() async {
    if (_isLoading) {
      return; 
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await authController.createUser(
          _workSpaceName!,
          _channelName!,
          _name!,
          _email!,
          _password!,
          _passwordConfirmation!,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm()),
        );
      } catch (e) {
        String error = e.toString();
        SnackBar(content:  Text(error, style: const  TextStyle(color: Colors.red),));
      
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (workSpaceName) {
              _workSpaceName = workSpaceName;
            },
            decoration: const InputDecoration(
              hintText: "WorkSpace Name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.work_outline),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a WorkSpace Name';
              }
              return null;
            },
          ),
         Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              onSaved: (channelName) {
                _channelName = channelName;
              },
              decoration: const InputDecoration(
                hintText: "Channel Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.message_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Channel Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (name) {
                _name = name;
              },
              decoration: const InputDecoration(
                hintText: "Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_2_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {
                _email = email;
              },
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Email';
                }
                if (!RegExp(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
                        caseSensitive: false)
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.none,
              obscureText: !_passwordVisible,
              cursorColor: kPrimaryColor,
              onSaved: (password) {
                _password = password;
              },
              decoration:  InputDecoration(
                hintText: "Password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility),
          ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Password';
                } else if (value.length < 8) {
                  return 'Password should have at least 10 characters';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: !_confirmPasswordVisible,
              cursorColor: kPrimaryColor,
              onSaved: (passwordConfirmation) {
                _passwordConfirmation = passwordConfirmation;
              },
              
              decoration:  InputDecoration(
                hintText: "Re-Enter Password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock_outline),
                ),
                suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
            icon: Icon(
                _confirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
          ),
              ),
              
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please re-enter your password';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(kPrimarybtnColor),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!_isLoading)
                    Text("Sign Up".toUpperCase())
                  else
                     ProgressionBar(imageName: 'mailSending2.json', height: MediaQuery.sizeOf(context).height, size: MediaQuery.sizeOf(context).width)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginForm()),
              );
            },
          ),
        ],
      ),
    );
  }
}
