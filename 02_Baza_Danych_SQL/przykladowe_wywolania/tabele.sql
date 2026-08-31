CREATE TABLE sensors_metadata (
    sensor_id TEXT PRIMARY KEY,        -- np. 'CM0010_01R'
    latitude DOUBLE PRECISION NOT NULL, -- Szerokość geograficzna
    longitude DOUBLE PRECISION NOT NULL,-- Długość geograficzna
    altitude DOUBLE PRECISION,          -- Wysokość Z (do dystansu 3D)
    description TEXT                    -- Opcjonalny opis lokalizacji
);

CREATE TABLE monitoring_readings (
    id SERIAL PRIMARY KEY,              -- Unikalny klucz rekordu
    timestamp TIMESTAMP NOT NULL,       -- Data pomiaru (np. 03/03/2024)
    sensor_id TEXT REFERENCES sensors_metadata(sensor_id), -- Powiązanie ze słownikiem
    settlement_value DOUBLE PRECISION,  -- Wartość osiadania w mm
    CONSTRAINT unique_reading UNIQUE (timestamp, sensor_id) -- Zabezpieczenie przed duplikatami
);

ALTER TABLE monitoring_readings 
ADD COLUMN reading_type VARCHAR(50);


CREATE TABLE tbm_telemetry (
    timestamp TIMESTAMP PRIMARY KEY,    -- Czas instalacji/pracy (rozdzielczość 1h)
    serial_number TEXT,                 -- Numer seryjny ringu
    latitude DOUBLE PRECISION,          -- Pozycja tarczy Lat
    longitude DOUBLE PRECISION,         -- Pozycja tarczy Lon
    
    -- Earth Pressure Balance (bar)
    epb_avg DOUBLE PRECISION,
    epb_min DOUBLE PRECISION,
    epb_max DOUBLE PRECISION,
    
    -- Cutterhead Torque (MNm)
    torque_avg DOUBLE PRECISION,
    torque_min DOUBLE PRECISION,
    torque_max DOUBLE PRECISION,
    
    -- Thrust Force (kN)
    thrust_avg DOUBLE PRECISION,
    thrust_min DOUBLE PRECISION,
    thrust_max DOUBLE PRECISION,
    
    -- Excavated Soil
    soil_exc_density_avg DOUBLE PRECISION, -- Ton/m3
    soil_exc_volume DOUBLE PRECISION,      -- V1
    soil_exc_weight DOUBLE PRECISION,      -- W1
    
    -- Primary Grout Injection
    grout_expected DOUBLE PRECISION,
    grout_injected DOUBLE PRECISION,
    
    -- Injection of Foam (Polymer, Surfactant, Water)
    foam_poly_vol DOUBLE PRECISION,        -- V2
    foam_poly_weight DOUBLE PRECISION,     -- W2
    foam_surf_vol DOUBLE PRECISION,        -- V3
    foam_surf_weight DOUBLE PRECISION,     -- W3
    foam_water_vol DOUBLE PRECISION,       -- V4
    
    -- Injection of Bentonite
    bentonite_vol DOUBLE PRECISION,        -- V5
    bentonite_weight DOUBLE PRECISION,     -- W5
    
    -- Conditioned Soil Summary
    cond_soil_vol_v6 DOUBLE PRECISION,     -- V6
    cond_soil_sum_vol DOUBLE PRECISION,    -- V sumaryczne
    cond_soil_sum_weight DOUBLE PRECISION, -- W sumaryczne
    
    -- Muck extracted
    muck_density DOUBLE PRECISION,         -- Ton/m3
    
    -- Geology (PAT)
    soil_category TEXT,                    -- Kategoria gruntu (PAT)
    soil_description TEXT                  -- Opis słowny
);

