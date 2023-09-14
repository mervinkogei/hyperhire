import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyperhire/Widgets/progressDialog.dart';
import 'package:hyperhire/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController password= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:  [
              const SizedBox(height: 45,),
              const Image(image: AssetImage('images/wikilogo.png'), width: 350,height: 200, alignment: Alignment.center,),
              const SizedBox(height: 1,),
              const Text("Register as a Rider", style: TextStyle(fontSize: 24, fontFamily: 'Brand Bolt', ),textAlign: TextAlign.center,),
              Padding(padding: const EdgeInsets.all(20),
              child: Column(
                children:  [
              const SizedBox(height: 1,),
              TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 1,),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 1,),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 1,),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(child: InkWell(
                onTap: (){
                  if(name.text.length <5){
                   displayToastMessage(context, "Name must be atleast 3 characters");
                  }else if(!email.text.contains("@")){
                    displayToastMessage(context, "Email address isn't valid");
                  }else if(phone.text.isEmpty){
                    displayToastMessage(context, "Phone number is required");
                  }else if(password.text.length < 7){
                    displayToastMessage(context, "Password must be atleast 6 characters");
                  }else{
                    registerUser(context);
                  }
                  
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),             
                  height: 50,
                  width: double.infinity,
                  child: const Center(child: Text("Create Account", style: TextStyle(fontSize: 18, color: Colors.white),)),
                ),
              ))
                ],
              ),),
              TextButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }, child: const Text("Already have an account? Login Here", style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
      )
      
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerUser(BuildContext context) async{
    showDialog(context: context, barrierDismissible: false, builder: (context){
        return ProgressDialog(message: 'Authenticating, Please wait ....',);
      });
    final User? firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text).
      catchError((onError){
      Navigator.pop(context);
      displayToastMessage(context, "Error: $onError");
      // ignore: invalid_return_type_for_catch_error
      return null;
    })).user;
    if(firebaseUser !=null){//user Created
    //Save User info to database
    
    Map userDataMap = {
      "name" : name.text.trim(),
      "phone" : phone.text.trim(),
      "email" : email.text.trim(),
    };
    usersRef.child(firebaseUser.uid).set(userDataMap);
    // ignore: use_build_context_synchronously
    displayToastMessage(context, "Congratulations, your account has been created Successfully");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    }else{
      //error encountered - Display error message
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      displayToastMessage(context, "User has not been created");
    }
  }  
}

displayToastMessage(BuildContext context, String message) async{
    Fluttertoast.showToast(msg: message);
  }