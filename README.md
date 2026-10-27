# MY TUGAS (TaskList)

Aplikasi mobile Flutter untuk mencatat tugas kuliah, deadline, dan pengingat.
Project UTS Pemrograman Mobile.

**Nama:** I Kadek Agus Mertha Kusuma
**NIM:** 2415051054
**Kelas:** PTI 5C

## Fitur
- CRUD tugas (tambah, lihat, edit, hapus dengan dialog konfirmasi)
- Deadline dengan pemilih tanggal dan jam
- Notifikasi pengingat H-3, H-2, H-1 sebelum deadline
- Tambah event deadline ke kalender perangkat
- Home dashboard: statistik, prioritas utama, deadline terdekat
- Pencarian dan filter status
- Kalender mingguan untuk melihat tugas per tanggal
- Kutipan motivasi dari REST API
- Layout responsif (NavigationBar/NavigationRail, list/grid)
- Loading, error (dengan Retry), dan empty state

## Tech Stack
Flutter, Dart, Provider (ChangeNotifier), supabase_flutter, http,
flutter_local_notifications, add_2_calendar

## REST API
`GET https://dummyjson.com/quotes?limit=5`, untuk kutipan motivasi di Home.

## Backend / Database
Supabase (PostgreSQL), tabel `courses`:
`id, code, title, credits, status, deadline`.

## Arsitektur
```
UI (screens/widgets) -> Provider -> Repository -> Service -> REST API / Supabase
lib/
├── models/        course.dart, quote.dart
├── services/      data source, API, Supabase, notifikasi, kalender
├── repositories/  course_repository.dart, quote_repository.dart
├── providers/     course_provider.dart, quote_provider.dart
├── screens/       home, tasks, detail, add, edit, calendar, profile, shell
├── widgets/       course_card, highlight_card, quote_section, error_view
└── main.dart
```
UI tidak mengimpor `http` maupun `supabase`. Pergantian sumber data tugas
dilakukan dengan mengganti satu baris di `main.dart`.

## Screenshot
![Home](image-6.png)
![Proses](image-1.png)
![Selesai](image-2.png)

![Tambah](image-3.png)
![Edit](image-4.png)
![Kalender](image-5.png)

![Responsif](image-7.png)
![Data API](image-9.png)
![Data Database](image-8.png)


## Cara Menjalankan
1. Clone repo, lalu `flutter pub get`.
2. Buat project Supabase dan jalankan SQL:
   ```sql
   create table courses (
     id bigint generated always as identity primary key,
     code text not null,
     title text not null,
     credits int not null default 1,
     status text not null default 'planned',
     deadline timestamptz
   );
   alter table courses enable row level security;
   create policy "public all" on courses for all using (true) with check (true);
   ```
3. Salin `dart_defines.example.json` menjadi `dart_defines.json`, lalu isi
   URL dan publishable key Supabase.
4. Jalankan:
   ```
   flutter run --dart-define-from-file=dart_defines.json
   ```

## Keterbatasan
- Policy RLS dibuka untuk semua pengguna (hanya untuk keperluan belajar).
- Notifikasi dan kalender hanya berjalan di Android/iOS, bukan di web.
- Event kalender dibuat lewat layar bawaan perangkat, jadi tidak bisa
  dihapus otomatis dari aplikasi.