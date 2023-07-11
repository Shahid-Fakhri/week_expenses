import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/Adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate; //we can add '?' that ensures value may be null."

  void _submitData() {
    if (_amountController.text.isEmpty) {
      // if try to submit empty form, just return
      return;
    }
    final enterTitle = _titleController.text;
    final enterAmount = double.parse(_amountController.text);

    if (enterTitle.isEmpty || enterAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enterTitle,
      enterAmount,
      _selectedDate,
    );
    // widget.addTx(
    //   titleController.text,
    //   double.parse(amountController.text),
    //   _selectedDate,
    // );

    Navigator.of(context).pop(); //close the botton sheat once add a data
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // then is called when a user select date and give value for future process
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  10), // to set the keyboard appearance in small screen
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  //onChanged: (String val) {titleInput = val;},
                  controller: _titleController,
                  onSubmitted: (String _) => _submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller:
                      _amountController, //onChanged: (String _) => amountInput = _,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String _) =>
                      _submitData(), //anonymous fuc that takes a string arg as a convension to signal that I have to accept it but I dont play to use it
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : "Packed Date: ${DateFormat.yMd().format(_selectedDate!)}", // we can add '!' at the end that ensures value will not be null here."
                        ),
                      ),
                      AdaptiveButton('Choose Date', _presentDatePicker),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text('Add Transaction'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors
                        .white, // Theme.of(context).textTheme.button.color,
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.purple, // Text Color
                  ),
                  onPressed: _submitData,
                )
              ]),
        ),
      ),
    );
  }
}
