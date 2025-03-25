import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(
  home: QuoteList()
));

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(author: 'Oscar Wilde', text: 'Be yourself; everyone else is already taken'),
    Quote(author: 'Oscar Wilde', text: 'I have nothing to declare except my genius'),
    Quote(author: 'Oscar Wilde', text: 'The truth is rarely pure and never simple')
  ];

  void _showQuoteInputSheet({Quote? quote, int? index}) {
    final TextEditingController authorController = TextEditingController(text: quote?.author ?? '');
    final TextEditingController textController = TextEditingController(text: quote?.text ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
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
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (quote == null) {
                          quotes.add(Quote(author: authorController.text, text: textController.text));
                        } else if (index != null) {
                          quotes[index] = Quote(author: authorController.text, text: textController.text);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text(quote == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
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
      body: Column(
        children: quotes.asMap().entries.map((entry) {
          int index = entry.key;
          Quote quote = entry.value;
          return QuoteCard(
            quote: quote,
            delete: () {
              setState(() {
                quotes.removeAt(index);
              });
            },
            update: () {
              _showQuoteInputSheet(quote: quote, index: index);
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuoteInputSheet(),
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}




