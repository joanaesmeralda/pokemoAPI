import 'package:flutter/material.dart';

class infoPokemon extends StatelessWidget {
  const infoPokemon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Image.network('src'),
          Text('data'),
        ],
      ),
    );
  }
}
