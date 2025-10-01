-- SQL untuk memperbaiki database agar sesuai dengan aplikasi

-- Karena menggunakan field 'list_tanggal_cuti' (varchar) untuk menyimpan tanggal cuti
-- Format: "2024-01-15,2024-01-16,2024-01-17"
-- Tidak perlu menambah kolom tanggal_mulai dan tanggal_selesai

-- 1. Tambah kolom status jika belum ada
ALTER TABLE public.cuti 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending';

-- 2. Buat index untuk performa yang lebih baik
CREATE INDEX IF NOT EXISTS idx_cuti_users_id ON public.cuti(users_id);
CREATE INDEX IF NOT EXISTS idx_cuti_status ON public.cuti(status);
CREATE INDEX IF NOT EXISTS idx_cuti_list_tanggal ON public.cuti(list_tanggal_cuti);

-- 3. Contoh data untuk testing (opsional - uncomment jika diperlukan)
-- INSERT INTO public.cuti (
--     lama_cuti, 
--     alasan_cuti, 
--     nama, 
--     list_tanggal_cuti,
--     status, 
--     users_id
-- ) VALUES 
-- (3, 'Liburan keluarga', 'Test User', '2024-01-15,2024-01-16,2024-01-17', 'approved', 
--  (SELECT id FROM users WHERE nrp = 'your_nrp_here'));

-- 4. Grant permissions
GRANT SELECT ON public.cuti TO authenticated;
GRANT SELECT ON public.cuti TO anon;