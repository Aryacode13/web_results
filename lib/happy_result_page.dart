import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';

const String kStartTimeStr = '2025-08-10 06:54:55';
final DateTime kStartTime = DateTime.parse(kStartTimeStr.replaceFirst(' ', 'T'));
const int kDNFSecs = 1 << 30;

class HappyResultPage extends StatefulWidget {
  const HappyResultPage({super.key});

  @override
  State<HappyResultPage> createState() => _HappyResultPageState();
}

class _HappyResultPageState extends State<HappyResultPage> {
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

  int _getValidRowsPerPage() {
    const availableOptions = [10, 20, 30, 50, 100];
    
    if (_dataSource.rowCount == 0) {
      return 10; // Default value when no data
    }
    
    // If current _rowsPerPage is valid and data is sufficient, use it
    if (availableOptions.contains(_rowsPerPage) && _dataSource.rowCount >= _rowsPerPage) {
      return _rowsPerPage;
    }
    
    // Find the largest available option that doesn't exceed data count
    for (int i = availableOptions.length - 1; i >= 0; i--) {
      if (availableOptions[i] <= _dataSource.rowCount) {
        return availableOptions[i];
      }
    }
    
    // If all options are too large, use the smallest one
    return availableOptions.first;
  }

  Widget _buildMobileTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1000, // Fixed width for all columns
          child: PaginatedDataTable(
            columnSpacing: 20,
            horizontalMargin: 16,
            headingRowHeight: 50,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 50,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onPageChanged: (firstRowIndex) {
              _scrollController.jumpTo(0);
            },
            headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
            showCheckboxColumn: false,
            showFirstLastButtons: true,
            columns: [
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                numeric: true,
                onSort: (i, asc) => _sort<num>((d) => d.rank, i, asc),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                onSort: (i, asc) => _sort<String>((d) => d.name, i, asc),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.confirmation_number, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Bib',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                numeric: true,
                onSort: (i, asc) => _sort<num>(
                  (d) => int.tryParse(d.bib) ?? 0,
                  i,
                  asc,
                ),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wc, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                onSort: (i, asc) => _sort<String>((d) => d.gender, i, asc),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Check Point',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                onSort: (columnIndex, ascending) {
                  _sort<num>(
                    (d) => d.cp1Secs,
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                onSort: (i, asc) => _sort<num>((d) => d.timeSeconds, i, asc),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.leaderboard, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Gender Rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                numeric: true,
                onSort: (i, asc) => _sort<num>(
                  (d) => d.genderRank ?? kDNFSecs,
                  i,
                  asc,
                ),
              ),
              DataColumn(
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      const Text(
                        'Certificate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            source: _dataSource,
            rowsPerPage: _getValidRowsPerPage(),
            availableRowsPerPage: const [10, 20, 30, 50, 100],
            onRowsPerPageChanged: (v) {
              if (v != null) setState(() => _rowsPerPage = v);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Run 2025 - Results'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/happy_logo.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[600]!],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'RESULTS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 200,
                          maxWidth: 400,
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search by Bib or Name',
                            hintText: 'Enter bib number or participant name...',
                            prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: _filterResults,
                        ),
                      ),
                    ),
                  ),
                  // Mobile swipe hint bubble
                  if (isMobile) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[100]!, Colors.blue[50]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue[200]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swipe,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Swipe left/right to view all columns',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  Center(
                    child: Container(
                      width: isMobile 
                        ? MediaQuery.of(context).size.width * 0.95
                        : MediaQuery.of(context).size.width * 0.9,
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 1200,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _dataSource.rowCount == 0
                          ? Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Results Found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try adjusting your search criteria',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : isMobile 
                            ? _buildMobileTable()
                            : PaginatedDataTable(
                        columnSpacing: 20,
                        horizontalMargin: 16,
                        headingRowHeight: 50,
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 50,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onPageChanged: (firstRowIndex) {
                          _scrollController.jumpTo(0);
                        },
                        headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
                        showCheckboxColumn: false,
                        showFirstLastButtons: true,
                        columns: [
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.emoji_events, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Rank',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            numeric: true,
                            onSort: (i, asc) =>
                                _sort<num>((d) => d.rank, i, asc),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onSort: (i, asc) =>
                                _sort<String>((d) => d.name, i, asc),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.confirmation_number, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Bib',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            numeric: true,
                            onSort: (i, asc) => _sort<num>(
                              (d) => int.tryParse(d.bib) ?? 0,
                              i,
                              asc,
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.wc, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onSort: (i, asc) =>
                                _sort<String>((d) => d.gender, i, asc),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.flag, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Check Point',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onSort: (columnIndex, ascending) {
                              _sort<num>(
                                (d) => d.cp1Secs,
                                columnIndex,
                                ascending,
                              );
                            },
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onSort: (i, asc) =>
                                _sort<num>((d) => d.timeSeconds, i, asc),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.leaderboard, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Gender Rank',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            numeric: true,
                            onSort: (i, asc) => _sort<num>(
                              (d) => d.genderRank ?? kDNFSecs,
                              i,
                              asc,
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Certificate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        source: _dataSource,
                        rowsPerPage: _getValidRowsPerPage(),
                        availableRowsPerPage: const [10, 20, 30, 50, 100],
                        onRowsPerPageChanged: (v) {
                          if (v != null) setState(() => _rowsPerPage = v);
                        },
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
      // FOOTER IMAGE
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/lariterus_logo.png', 
              height: 28, 
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              'Powered by Lariterus',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
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
    if (index < 0 || index >= _results.length) {
      // Return empty row if no data
      if (_results.isEmpty) {
        return DataRow.byIndex(
          index: index,
          cells: [
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
          ],
        );
      }
      return null;
    }
    final r = _results[index];
    final isEvenRow = index % 2 == 0;
    
    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.all(
        isEvenRow ? Colors.grey[50] : Colors.white,
      ),
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: r.isDns 
                ? Colors.grey[300] 
                : r.finished 
                  ? Colors.green[100] 
                  : Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              r.isDns ? 'DNS' : (r.finished ? r.rank.toString() : 'DNF'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: r.isDns 
                  ? Colors.grey[700] 
                  : r.finished 
                    ? Colors.green[800] 
                    : Colors.orange[800],
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            r.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: Text(
              r.bib,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: r.gender == 'male' ? Colors.blue[50] : Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  r.gender == 'male' ? Icons.male : Icons.female,
                  size: 14,
                  color: r.gender == 'male' ? Colors.blue[700] : Colors.pink[700],
                ),
                const SizedBox(width: 4),
                Text(
                  r.gender == 'male' ? 'Male' : 'Female',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: r.gender == 'male' ? Colors.blue[700] : Colors.pink[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Text(
            r.cp1Display,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: r.cp1Display.isEmpty ? Colors.grey[500] : Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Text(
            r.timeDisplay,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: r.timeDisplay.isEmpty ? Colors.grey[500] : Colors.green[700],
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          r.finished && r.genderRank != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Text(
                  r.genderRank.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                    fontSize: 12,
                  ),
                ),
              )
            : Text(
                '',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                ),
              ),
        ),
        DataCell(
          r.finished
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () => CertificateService.downloadCertificate(
                    name: r.name,
                    timeText: r.timeDisplay.isEmpty
                      ? '—'
                      : r.timeDisplay,
                  ),
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: const Text(
                    'Download',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'N/A',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
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

    // 6) Trigger download based on platform
    if (kIsWeb) {
      // Web download - temporarily disabled for cross-platform compatibility
      // TODO: Re-enable web download functionality
      print('Certificate download for $name (web version - temporarily disabled)');
    } else {
      // Desktop - just print message for now
      print('Certificate download is only supported on web platform');
      print('Certificate for $name would be saved here on desktop');
    }
  }

  static String _sanitize(String s) => s.replaceAll(RegExp(r'[^a-zA-Z0-9._ -]+'), '_');
}

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return [h, m, s].map((v) => v.toString().padLeft(2, '0')).join(':');
}
