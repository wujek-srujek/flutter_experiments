import 'package:flutter/material.dart';
import 'package:validator/validator.dart';

import 'password_validator.dart';
import 'user.dart';

void main() {
  validators.register(const PasswordValidator());

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
    pass: '',
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
                onValidate: () => _user.validateFirstName(),
              ),
              MyFormField(
                label: 'Last name',
                initialValue: _user.lastName,
                onChanged: (value) {
                  setState(() {
                    _user = _user.copyWith.lastName(value);
                  });
                },
                onValidate: () => _user.validateLastName(),
              ),
              MyFormField(
                label: 'Password',
                initialValue: _user.pass,
                onChanged: (value) {
                  setState(() {
                    _user = _user.copyWith.pass(value);
                  });
                },
                onValidate: () => _user.validatePass(),
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
  final List<String> Function() onValidate;

  const MyFormField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: onChanged,
      validator: (_) {
        final errors = onValidate();
        if (errors.isEmpty) {
          return null;
        }

        return errors.join('\n');
      },
    );
  }
}
