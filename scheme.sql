-- Schema untuk aplikasi MTI Pontianak
-- Tabel users untuk sistem authentication

-- Membuat tabel users
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nrp TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    jabatan TEXT,
    status TEXT,
    group_ TEXT,
    status_group TEXT,
    kontak TEXT,
    unit_kerja TEXT,
    sisa_cuti INTEGER DEFAULT 12,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Membuat index untuk optimasi query
CREATE INDEX idx_users_nrp ON users(nrp);
CREATE INDEX idx_users_updated_at ON users(updated_at);

-- Membuat trigger untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Membuat tabel jabatan
CREATE TABLE jabatan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama TEXT NOT NULL,
    "permissionCuti" BOOLEAN DEFAULT FALSE,
    "permissionEksepsi" BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Membuat index untuk optimasi query jabatan
CREATE INDEX idx_jabatan_nama ON jabatan(nama);
CREATE INDEX idx_jabatan_created_at ON jabatan(created_at);

-- Insert data contoh untuk testing
INSERT INTO users (nrp, password, name, jabatan) VALUES
('12345678', 'password', 'Admin User', 'Administrator'),
('87654321', 'password', 'John Doe', 'Staff'),
('11223344', 'password', 'Jane Smith', 'Manager');

-- Insert data jabatan contoh
INSERT INTO jabatan (nama, "permissionCuti", "permissionEksepsi") VALUES
('Administrator', TRUE, TRUE),
('Manager', TRUE, FALSE),
('Staff', FALSE, FALSE),
('Supervisor', TRUE, FALSE);

-- Membuat tabel cuti
CREATE TABLE public.cuti (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  lama_cuti integer null,
  alasan_cuti text null,
  nama text null,
  list_tanggal_cuti character varying null,
  url_ttd text null,
  sisa_cuti integer null,
  tanggal_pengajuan timestamp with time zone null,
  constraint cuti_pkey primary key (id)
);

-- Membuat index untuk optimasi query cuti
CREATE INDEX idx_cuti_nama ON cuti(nama);
CREATE INDEX idx_cuti_tanggal_pengajuan ON cuti(tanggal_pengajuan);
CREATE INDEX idx_cuti_created_at ON cuti(created_at);

-- Membuat tabel eksepsi (normalized schema for multiple dates)
CREATE TABLE public.eksepsi (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null references users(id) on delete cascade,
  jenis_eksepsi text not null,
  alasan_eksepsi text not null,
  tanggal_pengajuan timestamp with time zone not null default now(),
  status_persetujuan text not null default 'Menunggu',
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint eksepsi_pkey primary key (id)
);

-- Membuat tabel eksepsi_tanggal (detail tanggal untuk setiap eksepsi)
CREATE TABLE public.eksepsi_tanggal (
  id uuid not null default gen_random_uuid (),
  eksepsi_id uuid not null references eksepsi(id) on delete cascade,
  tanggal_eksepsi date not null,
  urutan integer not null,
  alasan_eksepsi text not null,
  created_at timestamp with time zone not null default now(),
  constraint eksepsi_tanggal_pkey primary key (id),
  constraint unique_eksepsi_urutan unique(eksepsi_id, urutan),
  constraint max_10_dates check (urutan <= 10 and urutan >= 1)
);

-- Membuat index untuk optimasi query eksepsi
CREATE INDEX idx_eksepsi_user_id ON eksepsi(user_id);
CREATE INDEX idx_eksepsi_tanggal_pengajuan ON eksepsi(tanggal_pengajuan);
CREATE INDEX idx_eksepsi_status ON eksepsi(status_persetujuan);
CREATE INDEX idx_eksepsi_created_at ON eksepsi(created_at);

-- Membuat index untuk optimasi query eksepsi_tanggal
CREATE INDEX idx_eksepsi_tanggal_eksepsi_id ON eksepsi_tanggal(eksepsi_id);
CREATE INDEX idx_eksepsi_tanggal_date ON eksepsi_tanggal(tanggal_eksepsi);
CREATE INDEX idx_eksepsi_tanggal_urutan ON eksepsi_tanggal(urutan);

-- Membuat trigger untuk auto-update updated_at pada tabel eksepsi
CREATE TRIGGER update_eksepsi_updated_at 
    BEFORE UPDATE ON eksepsi 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Catatan:
-- Password menggunakan plain text untuk testing
-- Untuk production, pastikan menggunakan password yang lebih kuat
-- dan hash yang proper (bcrypt, argon2, dll)

-- Query untuk melihat data
-- SELECT * FROM users;
-- SELECT * FROM jabatan;

-- Query untuk login (contoh)
-- SELECT id, nrp, name, jabatan, updated_at 
-- FROM users 
-- WHERE nrp = 'NRP_USER' AND password = 'PASSWORD_PLAIN';