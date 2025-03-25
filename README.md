# kelas PBB

Tugas PBB 1

## Link

Sumber referensi:
https://github.com/iamshaunjp/flutter-beginners-tutorial/tree/lesson-21/quotes

Link Demo:


## Modify

file quote.dart tetap sama sesuai dengan referensi
<br>
untuk create saya pakai floating action button, yang saya tambahakn sebelumnya di kelas<br>
```
floatingActionButton: FloatingActionButton(
  onPressed: () => _editQuote(),
  child: Icon(Icons.add),
  backgroundColor: Colors.redAccent,
);
```
nanti di function _editQuote(), akan dipass tanpa parameter
```
if (isEditing && index != null) {
  quotes[index] = Quote(author: authorController.text, text: textController.text);
} else {
  quotes.add(Quote(author: authorController.text, text: textController.text));
}
```
Jika isEditing false, quote baru akan ditambahkan ke dalam List quotes.

<br>

lalu untuk update saya tambahkan juga.<br>
di file quote_card.dart saya tambahkan button update
```
  final Quote quote;
  final VoidCallback delete;
  final VoidCallback update;

  QuoteCard({required this.quote, required this.delete, required this.update});
```
implementasinya di main.dart. Button tersebut akan call function _editQuote tapi dengan parameter (quote: quote, index: index)

```
update: () {
  _editQuote(quote: quote, index: index);
},
```
Jika isEditing True, quote baru akan dalam quotelist akan diupdate sesuai dengan index nya tadi.
```
if (isEditing && index != null) {
  quotes[index] = Quote(author: authorController.text, text: textController.text);
}
```

lalu untuk delete, implementasinya sama dengan code aslinya, cuman saya modify delete by index.

```
delete: () {
  setState(() {
    quotes.removeAt(index);
  });
},
```
index ini tadi didapetin dari
```int index = entry.key; ```
