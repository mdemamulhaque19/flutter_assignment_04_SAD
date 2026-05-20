import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_4/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isProgress = false;
  final _supabase = Supabase.instance.client;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 82,),
                        Text('Join With Us',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24,),
                        TextFormField(
                          controller: _emailTEController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
                            prefixIconColor: Colors.black,
                          ),
                          validator: (String? value) {
                            String inputText = value ?? '';
                            if(EmailValidator.validate(inputText)== false){
                              return 'Enter a valid email';
                            }
                            if(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!) == false){
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                          controller: _nameTEController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
                            prefixIconColor: Colors.black,
                          ),
                          validator: (String? value) {
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                            controller: _mobileTEController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Mobile',
                              prefixIconColor: Colors.black,
                            ),
                            validator: (String? value) {
                              if(value?.trim().isEmpty ?? true){
                                return 'Enter your mobile number';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                            controller: _passwordTEController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              prefixIconColor: Colors.black,
                              suffixIcon: Icon(Icons.remove_red_eye),
                              suffixIconColor: Colors.black,
                            ),
                            validator: (String? value) {
                              if((value?.length ?? 0) <= 6){
                                return 'Enter a password more than 6 letters';
                              }
                              if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!)){
                                return 'Enter a valid password';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 8,),

                        TextFormField(
                          controller: _confirmPasswordTEController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Confirm Password',
                            prefixIconColor: Colors.black,
                            suffixIcon: Icon(Icons.remove_red_eye),
                            suffixIconColor: Colors.black,
                          ),
                          validator: (String? value) {

                            if(value == null || value.isEmpty){
                              return 'Confirm your password';
                            }

                            if(value != _passwordTEController.text){
                              return 'Password does not match';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16,),

                        FilledButton(
                              onPressed: _onTapSubmitButton,
                              child: _isProgress ? CircularProgressIndicator() : Text('Register'),
                          ),

                        const SizedBox(height: 36,),
                        Center(
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                            color: Colors.green
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const LoginPage(),
                                              ),
                                            );
                                          },
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ),
      ),
    );
  }


  void _onTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      register();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }

  }

  void register() async {
    String email = _emailTEController.text.trim();
    String name = _nameTEController.text.trim();
    String mobile = _mobileTEController.text.trim();
    String password = _passwordTEController.text.trim();
    setState(() {
      _isProgress = true;
    });
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = authResponse.user;
      if (user != null) {
        await _supabase.from('profiles').insert({
          'id': user.id,
          'name': name,
          'mobile': mobile,
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup is done')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } on AuthApiException catch (e) {
      setState(() {
        _isProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
    _nameTEController.clear();
    _emailTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
    _confirmPasswordTEController.clear();
    setState(() {
      _isProgress = false;
    });
  }



  @override
  void dispose(){
    super.dispose();
    _emailTEController.dispose();
    _nameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }

}
