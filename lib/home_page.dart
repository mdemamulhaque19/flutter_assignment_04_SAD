import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'club_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _supabase = Supabase.instance.client;
  Future<Map<String,dynamic>?> getCurrentUser() async{
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    final res = await _supabase.from('profiles').select().eq('id', user.id).single();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('Home Page'),
    centerTitle: true,

    actions: [
    IconButton(
    onPressed: () async {
      //await _supabase.auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),);
    },
    icon: const Icon(Icons.logout),
    ),
    ],
    ),
      body: FutureBuilder(
        future: getCurrentUser(),
    builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }

    if (!snapshot.hasData || snapshot.data == null) {
    return const Center(
    child: Text('No User Data Found'),
    );
    }

    final userData = snapshot.data!;
    final user = _supabase.auth.currentUser;

    return Center(
    child: Column(
      children: [
        Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ]
            ,),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.purple,
              child: Text(
                userData['name'][0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,)
                ,),
            ),
            const SizedBox(height: 20),
                Text(userData['name'],
                   style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,),
                           ),
                        const SizedBox(height: 10),
                        Text(
                          user?.email ?? '',
                         style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                         )
                      ,)
                  , ],
                  ),
                ),
        SizedBox(height: 40,),
        ElevatedButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => ClubPage()));
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(320),
            backgroundColor: Colors.purple,
        ),
          child: Text('Club',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),)
      ],
    ),
          );
        },
      ),
    );
  }
}
