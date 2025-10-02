-- Tabel untuk data supervisor
CREATE TABLE supervisor (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    jabatan VARCHAR(255) NOT NULL,
    jenis VARCHAR(50) NOT NULL CHECK (jenis IN ('Penunjang', 'Logistik', 'Manager PDS')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert data default supervisor
INSERT INTO supervisor (nama, jabatan, jenis) VALUES 
('BAHTIAR SETIO HONO', 'SUPERVISOR LOGISTIK', 'Logistik'),
('YOGI AULIA', 'REGIONAL MANAGER JAKARTA', 'Penunjang');

-- Trigger untuk update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_supervisor_updated_at 
    BEFORE UPDATE ON supervisor 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();