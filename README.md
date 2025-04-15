# kelas PBB

Tugas PBB 2

## Link

Sumber referensi:
https://github.com/iamshaunjp/flutter-beginners-tutorial/tree/lesson-21/quotes
https://youtu.be/bihC6ou8FqQ?si=wle01SzZiS3x5dxy

Link Demo:


## Modify

## Tugas 2
Referensi database saya ambil dari tutorial SQFLite di classroom<br>
Jadi file app_database.dart handle fungsi CRUD pada quotes table, dan handle database.<br>

```
const String fileName = "quote_database.db";
const String tableName = "quotes";

const String idField = "id";
const String textField = "text";
const String authorField = "author";
```
Inisialiasasi nama database, dan juga table. 

```
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }
```
Cek apakah sudah ada database, jika belum akan diinisialisasi dengan function _initializeDB

```
Future<Database> _initializeDB(String fileName) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, fileName);
  return await openDatabase(path, version: 1, onCreate: _createDB);
}

Future<void> _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE quotes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      author TEXT NOT NULL
    )
  ''');
}
```
Database disimpan di folder lokal HP user
Tabel quotes dibuat dengan kolom:
id: otomatis
text: isi quotes
author: nama author

```
Future<Quote> createQuote(Quote quote) async {
  final db = await instance.database;
  final id = await db.insert(tableName, quote.toMap());
  return quote.copyWith(id: id);
}
```
Digunakan saat tombol tambah ditekan (dan isEditing == false):
store quote ke tabel, kemudian ID otomatis dibuat SQLite, lalu ngereturn quote dengan ID baru

```
Future<List<Quote>> readAllQuotes() async {
  final db = await instance.database;
  final result = await db.query(tableName, orderBy: '$idField DESC');
  return result.map((json) => Quote.fromMap(json)).toList();
}
```
Dipanggil saat aplikasi dimulai atau page dibuka. Semua data quote diambi, lalu diurut berdasarkan ID terbaru, kemudian Dikonversi dari format SQLite (Map) ke objek Quote.

```
Future<int> updateQuote(Quote quote) async {
  final db = await instance.database;
  return await db.update(
    tableName,
    quote.toMap(),
    where: '$idField = ?',
    whereArgs: [quote.id],
  );
}
```
Dipakai jika isEditing == true dan ingin menyimpan perubahan quote

```
Future<int> deleteQuote(int id) async {
  final db = await instance.database;
  return await db.delete(
    tableName,
    where: '$idField = ?',
    whereArgs: [id],
  );
}
```
Ini function buat ngedelete quote di table, dengan params ID juga.

Lalu UI dari tugas 1 kemarin, saya implementasi dengan database SQFLite

```
@override
void initState() {
  super.initState();
  _loadQuotes(); // Ambil semua data dari database saat pertama kali aplikasi dibuka
}

Future<void> _loadQuotes() async {
  final data = await _dbHelper.readAllQuotes();
  setState(() {
    quotes = data;
  });
}
```
Disini untuk ambil data dari database. Fungsi _loadQuotes() mengambil semua quote dari database dan menampilkannya di UI.

```
floatingActionButton: FloatingActionButton(
  onPressed: () => _editQuote(),
  child: Icon(Icons.add),
  backgroundColor: Colors.redAccent,
),
```
Untuk add dan edit quote, function ini akan berjalan.Saat tombol + ditekan, fungsi _editQuote() akan dijalankan.Kemudian
```
void _editQuote({Quote? quote, int? index}) {
  final isEditing = quote != null;
  ...
  if (isEditing && index != null) {
    await _dbHelper.updateQuote(newQuote); // Edit kutipan
  } else {
    await _dbHelper.createQuote(newQuote); // Tambah kutipan baru
  }
  _loadQuotes(); // Refresh tampilan setelah menyimpan
}
```
Jika quote tidak null → mode edit<br>
Jika quote null → mode tambah<br>
Setelah menambah/mengedit, data disimpan ke database dan ditampilkan ulang

```
delete: () async {
  await _dbHelper.deleteQuote(quote.id!);
  _loadQuotes(); // Refresh tampilan setelah dihapus
},
```
Saat user menekan tombol hapus, data langsung dihapus dari database dengan params id juga

```
ListView.builder(
  itemCount: quotes.length,
  itemBuilder: (context, index) {
    final quote = quotes[index];
    return QuoteCard(
      quote: quote,
      delete: () async {
        await _dbHelper.deleteQuote(quote.id!);
        _loadQuotes();
      },
      update: () {
        _editQuote(quote: quote, index: index);
      },
    );
  },
),
```
Menampilkan semua quote dalam bentuk QuoteCard sesuai dengan quote_card.dart
Setiap card memiliki tombol untuk hapus dan edit

## Tugas 1

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
