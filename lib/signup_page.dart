import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_4/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
                            return null;
                          },
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                          controller: _firstNameTEController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'First Name',
                            prefixIconColor: Colors.black,
                          ),
                          validator: (String? value) {
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter a first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8,),
                        TextFormField(
                            controller: _lastNameTEController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Last Name',
                              prefixIconColor: Colors.black,
                            ),
                            validator: (String? value) {
                              if(value?.trim().isEmpty ?? true){
                                return 'Enter a last name';
                              }
                              return null;
                            }
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
                              return null;
                            }
                        ),
                        const SizedBox(height: 16,),

                        FilledButton(
                              onPressed: _onTapSubmitButton,
                              child: Icon(Icons.arrow_circle_right_outlined)
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
                                          recognizer: TapGestureRecognizer()..onTap = (){
                                            LoginPage();
                                          }
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup is done')));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }

  }

  @override
  void dispose(){
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
  }

}
