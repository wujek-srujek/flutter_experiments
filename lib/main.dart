import 'package:flutter/material.dart';

import 'user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Experiments',
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm();

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _user = const User(
    firstName: '',
    lastName: '',
    age: 18,
    comment: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyFormField(
                label: 'First name',
                initialValue: _user.firstName,
                onChanged: (value) {
                  setState(() {
                    _user = _user.copyWith.firstName(value);
                  });
                },
              ),
              MyFormField(
                label: 'Last name',
                initialValue: _user.lastName,
                onChanged: (value) {
                  setState(() {
                    _user = _user.copyWith.lastName(value);
                  });
                },
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      final formState = Form.of(context)!;
                      if (formState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Good job')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFormField extends StatelessWidget {
  final String label;
  final String initialValue;
  final void Function(String) onChanged;

  const MyFormField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}
