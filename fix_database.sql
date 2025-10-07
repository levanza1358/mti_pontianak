-- Penyesuaian tambahan untuk skema terbaru (opsional & idempotent)

-- Index bantu untuk performa query CUTI
CREATE INDEX IF NOT EXISTS idx_cuti_users_id ON public.cuti(users_id);
CREATE INDEX IF NOT EXISTS idx_cuti_list_tanggal ON public.cuti(list_tanggal_cuti);

-- Grant akses baca (opsional, sesuaikan kebijakan RLS Anda)
GRANT SELECT ON public.cuti TO authenticated;
GRANT SELECT ON public.cuti TO anon;
