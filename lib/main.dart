import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase konfigürasyon dosyanız
import 'login_screen.dart'; // Giriş ekranınızın bulunduğu dosya

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase'i başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase Baglantisi");
    runApp(MyApp()); // Firebase başlatma işlemi başarılıysa uygulamayı çalıştır
  } catch (e) {
    // Firebase başlatma işleminde bir hata olursa, konsola hata bilgisini yazdır
    print('HATAAAAAAAA: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yemek Tarifi Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Ana ekranınız
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple], // Burada istediğiniz renkleri kullanabilirsiniz
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white.withOpacity(0.8), // İçerik üzerinde yarı saydam bir arka plan
            child: Column(
              mainAxisSize: MainAxisSize.min, // İçerikleri sıkıştırır
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hoş Geldiniz!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Text('Giriş Yap'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

