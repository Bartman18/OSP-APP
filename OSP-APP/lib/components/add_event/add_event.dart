import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class AddEventButton extends StatelessWidget {
void showCreateEventPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tytuł Wydarzenia',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.red.shade600,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.red.shade600,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Miejsce',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.red.shade600,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Limit osób',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.red.shade600,
                    //suffixIcon: Icon(Icons.infinity, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLength: 100,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Opis',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.red.shade600,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Dołączono', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        
                      ),
                      onPressed: () {
                        // Action for creating the event
                        Navigator.of(context).pop();
                      },
                      child: Text('Utwórz Wydarzenie'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
          style: ElevatedButton.styleFrom(
            //primary: Colors.red.shade800,
          ),
          onPressed: () => showCreateEventPopup(context),
          child: Text('Dodaj Wydarzenie'),
    );
  }
}
