import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {

  final TextEditingController _clubTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;

  final _clubStream = Supabase.instance.client.from('clubs').stream(primaryKey: ['id']).eq('uuid', Supabase.instance.client.auth.currentUser!.id);

  _addClub() async {
    try{
      await supabase.from('clubs').insert({
        'club_name': _clubTEController.text,
        'uuid': supabase.auth.currentUser!.id,
      });
    } catch (e){
      mySnackbar(context, e.toString());
    }
    _clubTEController.clear();
    setState(() {
    });
  }

  mySnackbar(context,content){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
    Navigator.pop(context);
  }

  Future<void> _updateClub(int id, String clubName) async {
    await supabase.from('clubs').update({'club_name': clubName}).eq('id', id);
    _clubTEController.clear();
    setState(() {
    });
  }


  Future<void> deleteClub(int id) async {
    await supabase.from('clubs').delete().eq('id', id);
    setState(() {
    });
  }

  @override
  void dispose(){
    super.dispose();
    _clubTEController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Page'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
          stream: _clubStream,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('No Data Found'),
              );
            }

            final clubs = snapshot.data!;

            if (clubs.isEmpty) {
              return const Center(
                child: Text('No Club Found'),
              );
            }
            return ListView.builder(
                itemCount: clubs.length,
              itemBuilder: (context, index){
                  return Card(
                    color: Colors.purple,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(clubs[index]['club_name'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    _clubTEController.text = clubs[index]['club_name'];
                                    showDialog(
                                      context: context,
                                      builder: ((context){
                                        return SimpleDialog(
                                          title: Text('Edit Club'),
                                          contentPadding: EdgeInsets.all(20),
                                          children: [
                                            Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                controller: _clubTEController,
                                                validator: (value){
                                                  if(value == null || value.isEmpty){
                                                    return 'Please Enter Club Name';
                                                  }
                                                  return null;
                                                },
                                                onFieldSubmitted: (value){
                                                  if (_clubTEController.text.trim().isNotEmpty){
                                                    _updateClub(clubs[index]['id'],
                                                        _clubTEController.text);
                                                    mySnackbar(context, 'Club Updated');
                                                  }
                                                }
                                              )
                                            )
                                          ]
                                        );
                                      })
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: ((context){
                                        return SimpleDialog(
                                          title: Text('Are you sure?'),
                                          contentPadding: EdgeInsets.all(20),
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel'),
                                                ),
                                                SizedBox(width: 20,),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                    onPressed: (){
                                                      deleteClub(clubs[index]['id']);
                                                      mySnackbar(context, 'Club Deleted');
                                                    },
                                                  child: Icon(Icons.delete),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      })
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            )
                          ],
                        ),
                    )
                  );
              }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: ((context) {
                return SimpleDialog(
                  title: Text('Add Club'),
                  contentPadding: EdgeInsets.all(20),
                  children: [
                    Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _clubTEController,
                          decoration: InputDecoration(
                            hintText: 'Enter Club Name',
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please Enter Club Name';
                            }
                            return null;
                          },
                            onFieldSubmitted: (value){
                              if (_clubTEController.text.trim().isNotEmpty) {
                                _addClub();
                                mySnackbar(context, 'Club Added');
                              }
                            }
                        )
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: (){
                          if (_clubTEController.text.trim().isNotEmpty) {
                            _addClub();
                            mySnackbar(context, 'Club Added');
                          }
                        },
                      child: Text('Add'),
                            )
                  ]
                );
              }
              )
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      )
    );
  }
}
