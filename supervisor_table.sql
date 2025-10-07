-- Tabel untuk data supervisor (diselaraskan dengan skema terbaru)
CREATE TABLE IF NOT EXISTS public.supervisor (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    jabatan VARCHAR(255) NOT NULL,
    jenis VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT supervisor_jenis_check CHECK (
      (jenis)::text = ANY ((ARRAY['Penunjang'::varchar,'Logistik'::varchar,'Manager_PDS'::varchar])::text[])
    )
);

-- Trigger untuk update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_supervisor_updated_at ON public.supervisor;
CREATE TRIGGER update_supervisor_updated_at 
    BEFORE UPDATE ON public.supervisor 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- (Opsional) Seed data contoh
-- INSERT INTO supervisor (nama, jabatan, jenis) VALUES 
-- ('BAHTIAR SETIO HONO', 'SUPERVISOR LOGISTIK', 'Logistik'),
-- ('YOGI AULIA', 'REGIONAL MANAGER JAKARTA', 'Penunjang');
