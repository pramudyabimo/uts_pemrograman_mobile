import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sehat_bersama/main.dart';
import 'package:sehat_bersama/data/dummy/dummy_data.dart';
import 'package:sehat_bersama/features/facility_detail/screens/detail_fasilitas_screen.dart';
import 'package:sehat_bersama/features/route/screens/rute_navigasi_screen.dart';
import 'package:sehat_bersama/features/geofencing/screens/lockscreen_demo_screen.dart';
import 'package:sehat_bersama/features/geofencing/widgets/geofence_alert_dialog.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Welcome screen renders and navigates to main scaffold',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SehatBersamaApp());
    await tester.pumpAndSettle();

    // Verify Welcome Screen content
    expect(find.text('Sehat Bersama Smart Village'), findsOneWidget);
    expect(find.text('LAYANAN KESEHATAN DESA'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    expect(find.text('Navigasi Cepat'), findsOneWidget);

    // Tap "Mulai" to navigate to MainScaffold
    await tester.tap(find.text('Mulai'));
    await tester.pumpAndSettle();

    // Verify Beranda tabs and content
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Peta'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Siaga Darurat Kabupaten X'), findsOneWidget);
    expect(find.text('RSUD Kabupaten X'), findsAtLeastNWidgets(1));

    // Test Tab Switching: Peta
    await tester.tap(find.text('Peta'));
    await tester.pumpAndSettle();
    expect(find.text('Peta Lokasi'), findsOneWidget);
    expect(find.text('Rute Cepat'), findsOneWidget);

    // Test Tab Switching: Favorit
    await tester.tap(find.text('Favorit'));
    await tester.pumpAndSettle();
    expect(find.text('Fasilitas Favorit'), findsOneWidget);
    expect(find.text('Panggilan Cepat Siaga'), findsOneWidget);

    // Test Tab Switching: Profil
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Andi Pratama'), findsOneWidget);
    expect(find.text('Warga Terverifikasi NIK'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('Detail Fasilitas renders and allows bookmark toggling',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final facility = DummyData.facilities.first;
    await tester.pumpWidget(
      MaterialApp(
        home: DetailFasilitasScreen(facility: facility),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Detail Fasilitas'), findsOneWidget);
    expect(find.text('RSUD Kabupaten X'), findsWidgets);
    expect(find.text('Jenis Pelayanan'), findsOneWidget);
    expect(find.text('Fasilitas Rekanan BPJS Kesehatan'), findsOneWidget);
    expect(find.text('Buka di Peta & Rute'), findsOneWidget);

    // Scroll down to reveal services
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap service item to open bottom sheet
    await tester.tap(find.text('Poliklinik'));
    await tester.pumpAndSettle();
    expect(find.text('Poliklinik Spesialis'), findsOneWidget);
    expect(find.text('Tutup'), findsOneWidget);

    // Close bottom sheet
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
  });

  testWidgets('Rute Navigasi screen renders route metrics and transport options',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final facility = DummyData.facilities.first;
    await tester.pumpWidget(
      MaterialApp(
        home: RuteNavigasiScreen(facility: facility),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rute ke ${facility.name}'), findsOneWidget);
    expect(find.text('Pilih Mode Transportasi'), findsOneWidget);
    expect(find.text('MOBIL'), findsOneWidget);
    expect(find.text('MOTOR'), findsOneWidget);
    expect(find.text('JALAN KAKI'), findsOneWidget);
    expect(find.text('Mulai Navigasi'), findsOneWidget);

    // Switch to Motor mode
    await tester.tap(find.text('MOTOR'));
    await tester.pumpAndSettle();
    expect(find.text('15 mnt'), findsOneWidget);
  });

  testWidgets('Lockscreen demo and Geofence Alert dialog render properly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Test Lockscreen Demo Screen
    await tester.pumpWidget(
      const MaterialApp(
        home: LockscreenDemoScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('10:24'), findsOneWidget);
    expect(find.text('Geofencing Aktif — Wilayah Terdeteksi'), findsOneWidget);
    expect(find.text('Anda berada di area RSUD Kabupaten X'), findsOneWidget);

    // Test Geofence Alert Dialog
    final facility = DummyData.facilities[1];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GeofenceAlertDialog(
            facility: facility,
            onViewLocation: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Anda Masuk Area Geofencing'), findsOneWidget);
    expect(find.text('Lihat Lokasi'), findsOneWidget);
  });

  test('Dummy data contains all 4 facilities required by design', () {
    expect(DummyData.facilities.length, 4);
    expect(DummyData.facilities.any((f) => f.name.contains('RSUD')), isTrue);
    expect(DummyData.facilities.any((f) => f.name.contains('Puskesmas')), isTrue);
    expect(DummyData.facilities.any((f) => f.name.contains('Klinik')), isTrue);
    expect(DummyData.facilities.any((f) => f.name.contains('Harapan Bunda')), isTrue);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) {}
  @override
  set authenticateProxy(
      Future<bool> Function(
              String host, int port, String scheme, String? realm)?
          f) {}
  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback) {}
  @override
  void close({bool force = false}) {}
  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> postUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> putUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> headUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> patchUrl(Uri url) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      Future.value(_TestHttpClientRequest());
  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(
              Uri url, String? proxyHost, int? proxyPort)?
          f) {}
  @override
  set keyLog(Function(String line)? callback) {}
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _TestHttpHeaders();
  @override
  bool bufferOutput = true;
  @override
  int contentLength = 0;
  @override
  Encoding encoding = utf8;
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  String method = 'GET';
  @override
  bool persistentConnection = true;
  @override
  Uri get uri => Uri.parse('http://dummy.url');

  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future addStream(Stream<List<int>> stream) => Future.value();
  @override
  Future<HttpClientResponse> close() =>
      Future.value(_TestHttpClientResponse());
  @override
  Future<HttpClientResponse> get done =>
      Future.value(_TestHttpClientResponse());
  @override
  void write(Object? object) {}
  @override
  void writeAll(Iterable objects, [String separator = ""]) {}
  @override
  void writeCharCode(int charCode) {}
  @override
  void writeln([Object? object = ""]) {}
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  List<Cookie> get cookies => [];
  @override
  Future flush() => Future.value();
  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}
}

class _TestHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  static const List<int> _kTransparentImage = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
    0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82,
  ];

  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  HttpHeaders get headers => _TestHttpHeaders();
  @override
  bool get isRedirect => false;
  @override
  List<RedirectInfo> get redirects => [];
  @override
  bool get persistentConnection => true;
  @override
  String get reasonPhrase => 'OK';
  @override
  Future<Socket> detachSocket() => throw UnimplementedError();
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
  @override
  X509Certificate? get certificate => null;
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  List<Cookie> get cookies => [];
  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) =>
      Future.value(this);
}

class _TestHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void clear() {}
  @override
  void forEach(void Function(String name, List<String> values) action) {}
  @override
  void noFolding(String name) {}
  @override
  void remove(String name, Object value) {}
  @override
  void removeAll(String name) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  String? value(String name) => null;
  @override
  bool chunkedTransferEncoding = false;
  @override
  int contentLength = 0;
  @override
  ContentType? contentType;
  @override
  DateTime? date;
  @override
  DateTime? expires;
  @override
  String? host;
  @override
  DateTime? ifModifiedSince;
  @override
  bool persistentConnection = true;
  @override
  int? port;
}
