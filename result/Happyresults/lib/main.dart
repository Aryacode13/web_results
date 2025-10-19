import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:html' as html; // web-only download
import 'dart:async';



const String kStartTimeStr = '2025-08-10 06:54:55';
final DateTime kStartTime = DateTime.parse(kStartTimeStr.replaceFirst(' ', 'T'));
const int kDNFSecs = 1 << 30;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hieyauprjmejzhwxsdld.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhpZXlhdXByam1lanpod3hzZGxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI5MDk3OTUsImV4cCI6MjAxODQ4NTc5NX0.plpTl75gOWjFVK0Ypt7DX75jLnTzts_p7p-zBk1U6tE',
  );
  runApp(const RaceResultsApp());
}

class RaceResultsApp extends StatelessWidget {
  const RaceResultsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Challenge 5K - Results',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const RaceResultsPage(),
    );
  }
}

class RaceResultsPage extends StatefulWidget {
  const RaceResultsPage({super.key});
  

  @override
  State<RaceResultsPage> createState() => _RaceResultsPageState();
}

class _RaceResultsPageState extends State<RaceResultsPage> {
  late ResultsDataSource _dataSource;
  bool _loading = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _rowsPerPage = 100;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<RaceResult> _allResults = [];


  @override
  void initState() {
    super.initState();
    _dataSource = ResultsDataSource([]); // start empty — no dummy data
    _loadFromSupabase();
  }

  Future<void> _loadFromSupabase() async {
    final cli = Supabase.instance.client;
    final rows = await cli.from('rts_happy').select('bib,name,cp1,cp2,gender,is_dns');

    final List<Map<String, dynamic>> partial = [];
    for (final r in rows) {
      final bib = (r['bib'] ?? '').toString();
      final name = (r['name'] ?? '').toString();
      final gender = (r['gender'] ?? '').toString().trim().toLowerCase();
      final cp1 = (r['cp1'] ?? '').toString().trim();
      final cp2 = (r['cp2'] ?? '').toString().trim();
      final isDns = r['is_dns'] == true;


      // Parse cp1 and cp2 strings you've already read
      final dt1 = (cp1.isNotEmpty) ? _parseCp2(cp1) : null;
      final dt2 = (cp2.isNotEmpty) ? _parseCp2(cp2) : null;

      // 1) Check Point display (blank if cp1 missing/invalid)
      String cp1Display = '';
      if (dt1 != null) {
        final diff1 = dt1.difference(kStartTime);
        final safe1 = diff1.isNegative ? Duration.zero : diff1;
        cp1Display = _formatDuration(safe1);
      }

      // cp1Secs is a number we will sort on later
      int cp1Secs =
          kDNFSecs; // use your large "DNF seconds" constant for missing values
      if (dt1 != null) {
        final diff1 = dt1.difference(kStartTime);
        final safe1 = diff1.isNegative ? Duration.zero : diff1;
        cp1Secs = safe1.inSeconds;
      }


      // 2) Time column should show cp2 - start IF cp2 exists (even if DNF)
      // Time display: blank if cp2 missing, else cp2 - start
      int secs = kDNFSecs;
      String display = '';
      if (dt2 != null) {
        final diff2 = dt2.difference(kStartTime);
        final safe2 = diff2.isNegative ? Duration.zero : diff2;
        secs = safe2.inSeconds;
        display = _formatDuration(safe2);
      }

      // 3) Finished flag = BOTH cp1 and cp2 present & valid
      final bool finished = (dt1 != null) && (dt2 != null);

      // Add to partial
      partial.add({
        'bib': bib,
        'name': name,
        'gender': gender,
        'secs': secs, // for sorting Time
        'display': display, // Time column text
        'finished': finished, // for Rank / Gender Rank logic
        'cp1Display': cp1Display, // Check Point column text
        'cp1Secs': cp1Secs,
        'isDns': isDns,

      });



    }

    partial.sort((a, b) => (a['secs'] as int).compareTo(b['secs'] as int));

    int overall = 0, m = 0, f = 0;
    final results = <RaceResult>[];
    for (final p in partial) {
      overall++;
      int? gRank;
      if ((p['finished'] == true) &&
          (p['gender'] == 'male' || p['gender'] == 'female')) {
        if (p['gender'] == 'male') {
          m++;
          gRank = m;
        } else {
          f++;
          gRank = f;
        }
      }
      results.add(
        RaceResult(
          rank: overall,
          name: p['name'] as String,
          bib: p['bib'] as String,
          gender: p['gender'] as String,
          timeSeconds: p['secs'] as int,
          timeDisplay: p['display'] as String,
          genderRank: gRank, // null if not finished
          cp1Display:
              p['cp1Display']
                  as String, // <-- ensure this field exists in your model
          finished:
              p['finished']
                  as bool, // <-- ensure this field exists in your model
          cp1Secs: p['cp1Secs'] as int, 
          isDns: p['isDns'] as bool,

        ),
      );

    }

    setState(() {
      _allResults = results;
      _dataSource = ResultsDataSource(_allResults);
      _loading = false;
    });

  }

  DateTime? _parseCp2(String raw) {
    final s = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  void _sort<T>(Comparable<T> Function(RaceResult d) getField, int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    _dataSource.sort<T>(getField, ascending);
  }

  void _filterResults(String query) {
    final q = query.toLowerCase();
    final filtered = _allResults.where((r) =>
      r.name.toLowerCase().contains(q) ||
      r.bib.toLowerCase().contains(q)
    ).toList();
    setState(() {
      _dataSource = ResultsDataSource(filtered);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _loading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Image.asset(
                    'assets/happy_logo.png',
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                    const Text(
                    'RESULTS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  const SizedBox(height: 16),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 120, // ~10 chars minimum
                        maxWidth: 250, // limit max width
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                        labelText: 'Search by Bib or Name',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        ),
                        onChanged: _filterResults,
                      ),
                      ),
                    ),
                    ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: PaginatedDataTable(
                        columnSpacing: 20,
                        horizontalMargin: 0,
                        headingRowHeight: 40,
                        dataRowMinHeight: 24,
                        dataRowMaxHeight: 28,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onPageChanged: (firstRowIndex) {
                          _scrollController.jumpTo(0);
                        },
                        columns: [
                          DataColumn(
                            label: const Text('Rank'),
                            numeric: true,
                            onSort: (i, asc) =>
                                _sort<num>((d) => d.rank, i, asc),
                          ),
                          DataColumn(
                            label: const Text('Name'),
                            onSort: (i, asc) =>
                                _sort<String>((d) => d.name, i, asc),
                          ),
                          DataColumn(
                            label: const Text('Bib'),
                            numeric: true,
                            onSort: (i, asc) => _sort<num>(
                              (d) => int.tryParse(d.bib) ?? 0,
                              i,
                              asc,
                            ),
                          ),
                          DataColumn(
                            label: const Text('Gender'),
                            onSort: (i, asc) =>
                                _sort<String>((d) => d.gender, i, asc),
                          ),
                          DataColumn(
                            label: const Text('Check Point'),
                            onSort: (columnIndex, ascending) {
                              _sort<num>(
                                (d) => d.cp1Secs,
                                columnIndex,
                                ascending,
                              );
                            },
                          ),


                          DataColumn(
                            label: const Text('Time'),
                            onSort: (i, asc) =>
                                _sort<num>((d) => d.timeSeconds, i, asc),
                          ),
                          DataColumn(
                            label: const Text('Gender Rank'),
                            numeric: true,
                            onSort: (i, asc) => _sort<num>(
                              (d) => d.genderRank ?? kDNFSecs,
                              i,
                              asc,
                            ),
                          ),
                          DataColumn(label: const Text('Certificate')),

                        ],
                        source: _dataSource,
                        rowsPerPage: _rowsPerPage,
                        availableRowsPerPage: const [10, 20, 30, 50, 100],
                        onRowsPerPageChanged: (v) {
                          if (v != null) setState(() => _rowsPerPage = v);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      // FOOTER IMAGE
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.black,
        child: Row(
          children: [
            Image.asset('assets/lariterus_logo.png', height: 24, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}

class RaceResult {
  final int rank;
  final String name;
  final String bib;
  final String gender;
  final int timeSeconds;
  final String timeDisplay;
  final int? genderRank;
  final String cp1Display;
  final bool finished;
  final int cp1Secs;
  final bool isDns;

  const RaceResult({
    required this.rank,
    required this.name,
    required this.bib,
    required this.gender,
    required this.timeSeconds,
    required this.timeDisplay,
    required this.genderRank,
    required this.cp1Display,
    required this.finished,
    required this.cp1Secs,
    required this.isDns,

  });
}

class ResultsDataSource extends DataTableSource {
  ResultsDataSource(this._results);
  final List<RaceResult> _results;

  void sort<T>(Comparable<T> Function(RaceResult d) getField, bool ascending) {
    _results.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      final order = Comparable.compare(aValue, bValue);
      return ascending ? order : -order;
    });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= _results.length) return null;
    final r = _results[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(r.isDns ? 'DNS' : (r.finished ? r.rank.toString() : 'DNF')),
        ),
        DataCell(Text(r.name)),
        DataCell(Text(r.bib)),
        DataCell(Text(r.gender)),
        DataCell(Text(r.cp1Display)),
        DataCell(Text(r.timeDisplay)),
        DataCell(Text(r.finished ? (r.genderRank?.toString() ?? '') : '')),
        DataCell(
          r.finished
                ? TextButton.icon(
                  onPressed: () => CertificateService.downloadCertificate(
                  name: r.name,
                  timeText: r.timeDisplay.isEmpty
                    ? '—'
                    : r.timeDisplay, // show time if available
                  ),
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                )
              : const Text(''),
        ),


      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _results.length;
  @override
  int get selectedRowCount => 0;
}

class CertificateService {
  static Future<void> downloadCertificate({
    required String name,
    required String timeText,
  }) async {
    // 1) Load background
    final bg = await rootBundle.load('assets/certificate.png');
    final Uint8List bytes = bg.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image bgImg = frame.image;


    // 2) Draw onto a canvas
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, bgImg.width.toDouble(), bgImg.height.toDouble()));
    final paint = ui.Paint();

    // background
    canvas.drawImage(bgImg, const ui.Offset(0, 0), paint);

    // 3) Text painters
    TextPainter _tp(String text, double size, FontWeight w) {
      final tp = TextPainter(
      text: TextSpan(
        style: TextStyle(
        fontFamily: 'DINCondensed',
        fontSize: size,
        fontWeight: w,
        color: Colors.black,
        ),
        text: text,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      );
      tp.layout(minWidth: 0, maxWidth: bgImg.width.toDouble());
      return tp;
    }

    final nameTp = _tp(name.toUpperCase(), bgImg.width * 0.06, FontWeight.w600);
    final timeTp = _tp(timeText,            bgImg.width * 0.045, FontWeight.w600);

    // 4) Center text (tweak Y as needed)
    nameTp.paint(canvas, ui.Offset((bgImg.width - nameTp.width) / 2, bgImg.height * 0.45));
    timeTp.paint(canvas, ui.Offset((bgImg.width - timeTp.width) / 2, bgImg.height * 0.79));

    // 5) Export PNG
    final pic = recorder.endRecording();
    final img = await pic.toImage(bgImg.width, bgImg.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // 6) Trigger browser download
    final blob = html.Blob([pngBytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final a = html.AnchorElement(href: url)
      ..download = _sanitize('$name-certificate.png')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static String _sanitize(String s) => s.replaceAll(RegExp(r'[^a-zA-Z0-9._ -]+'), '_');
}


String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return [h, m, s].map((v) => v.toString().padLeft(2, '0')).join(':');
}
