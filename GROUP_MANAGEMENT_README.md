# Group Management System

## Deskripsi
Sistem manajemen group yang menggabungkan fungsi tambah dan edit dalam satu halaman dengan dua tab untuk kemudahan penggunaan.

## Fitur
- **Tab 1: Tambah Group** - Form untuk menambahkan group baru
- **Tab 2: Edit Group** - Daftar group dengan fungsi edit dan delete

## Struktur File

### Controller
- `lib/controller/group_management_controller.dart` - Controller utama yang menggabungkan fungsi add dan edit

### Page
- `lib/page/group_management_page.dart` - Halaman utama dengan 2 tab (Tambah & Edit)

### Routing
- Route: `/group-management`
- Dapat diakses dari Home Page menu "Manajemen Group"

## Fitur Utama

### Tambah Group
- Form validasi (minimal 3 karakter)
- Simpan ke database Supabase
- Auto switch ke tab Edit setelah berhasil menambah
- Loading state indicator

### Edit Group
- Daftar semua group yang ada
- Select group untuk edit
- Update data group
- Delete group dengan konfirmasi
- Refresh data manual

## Database Schema
```sql
CREATE TABLE group (
  id SERIAL PRIMARY KEY,
  nama VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## UI/UX Features
- Modern gradient design
- Card-based layout
- Tab navigation
- Loading indicators
- Success/error notifications
- Confirmation dialogs
- Responsive design

## Navigasi
1. Home Page → "Manajemen Group" → Group Management Page
2. Tab 1: Tambah group baru
3. Tab 2: Edit/delete group existing

## Teknologi
- Flutter + GetX
- Supabase Database
- Modern Material Design
- Gradient UI Theme