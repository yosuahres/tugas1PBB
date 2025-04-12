import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';
import 'database/app_database.dart';

void main() => runApp(MaterialApp(home: QuoteList()));

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [];
  final AppDatabase _dbHelper = AppDatabase.instance; // Use AppDatabase singleton

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    final data = await _dbHelper.readAllQuotes(); // Fetch all quotes from the database
    setState(() {
      quotes = data;
    });
  }

  void _editQuote({Quote? quote, int? index}) {
    final isEditing = quote != null;
    final TextEditingController authorController =
        TextEditingController(text: quote?.author ?? '');
    final TextEditingController textController =
        TextEditingController(text: quote?.text ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Quote' : 'Add Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Quote'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newQuote = Quote(
                  id: quote?.id,
                  author: authorController.text,
                  text: textController.text,
                );

                if (isEditing && index != null) {
                  await _dbHelper.updateQuote(newQuote); // Update quote in the database
                } else {
                  await _dbHelper.createQuote(newQuote); // Insert new quote into the database
                }

                _loadQuotes(); // Reload quotes after the operation
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return QuoteCard(
            quote: quote,
            delete: () async {
              await _dbHelper.deleteQuote(quote.id!); // Delete quote from the database
              _loadQuotes(); // Reload quotes after deletion
            },
            update: () {
              _editQuote(quote: quote, index: index); // Open edit dialog
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editQuote(),
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}