-- ============================================================
-- Ponte Digital -- Schema da Base de Dados
-- PostgreSQL 16 + PostGIS 3.4
-- Versão 1.0 -- Maio 2026
-- ============================================================

-- Extensões
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Categorias
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    nome_pt VARCHAR(100) NOT NULL,
    nome_en VARCHAR(100) NOT NULL,
    icone VARCHAR(10),
    cor_hex VARCHAR(7)
);

-- Municipios
CREATE TABLE municipio (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo_dico VARCHAR(10) UNIQUE,
    geom GEOMETRY(MultiPolygon, 4326)
);

-- Utilizadores (curadores e admins)
CREATE TABLE utilizador (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    role VARCHAR(20) DEFAULT 'curador',
    activo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT NOW()
);

-- Recursos
CREATE TABLE recurso (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    categoria_id INTEGER REFERENCES categoria(id),
    organizacao VARCHAR(200),
    morada VARCHAR(300),
    municipio_id INTEGER REFERENCES municipio(id),
    freguesia VARCHAR(100),
    geom GEOMETRY(Point, 4326),
    telefone VARCHAR(30),
    email VARCHAR(200),
    website VARCHAR(300),
    horario JSONB,
    publico_alvo TEXT,
    condicoes_acesso TEXT,
    idiomas_atendimento TEXT[],
    acessibilidade_mobilidade BOOLEAN DEFAULT FALSE,
    activo BOOLEAN DEFAULT TRUE,
    verificado BOOLEAN DEFAULT FALSE,
    urgente BOOLEAN DEFAULT FALSE,
    camada CHAR(1),
    fonte VARCHAR(200),
    data_criacao TIMESTAMP DEFAULT NOW(),
    data_ultima_verificacao TIMESTAMP,
    criado_por UUID REFERENCES utilizador(id)
);

-- Log de verificacoes
CREATE TABLE log_verificacao (
    id SERIAL PRIMARY KEY,
    recurso_id UUID REFERENCES recurso(id),
    utilizador_id UUID REFERENCES utilizador(id),
    data TIMESTAMP DEFAULT NOW(),
    notas TEXT
);

-- Feedback publico
CREATE TABLE feedback_publico (
    id SERIAL PRIMARY KEY,
    recurso_id UUID REFERENCES recurso(id),
    tipo VARCHAR(20),
    descricao TEXT,
    email_contacto VARCHAR(200),
    data TIMESTAMP DEFAULT NOW(),
    resolvido BOOLEAN DEFAULT FALSE
);

-- Indices espaciais e de pesquisa
CREATE INDEX idx_recurso_geom ON recurso USING GIST (geom);
CREATE INDEX idx_recurso_categoria ON recurso (categoria_id, activo);
CREATE INDEX idx_recurso_municipio ON recurso (municipio_id, activo);
CREATE INDEX idx_recurso_camada ON recurso (camada, activo);
CREATE INDEX idx_recurso_fts ON recurso USING GIN (
    to_tsvector('portuguese', nome || ' ' || COALESCE(descricao, ''))
);

-- Dados iniciais: categorias
INSERT INTO categoria (slug, nome_pt, nome_en, icone, cor_hex) VALUES
    ('alimentacao', 'Alimentacao', 'Food', '🍽', '#D97706'),
    ('saude', 'Saude', 'Health', '🏥', '#059669'),
    ('emprego', 'Emprego', 'Employment', '💼', '#2563EB'),
    ('apoio-social', 'Apoio Social', 'Social Support', '🤝', '#DB2777'),
    ('educacao', 'Educacao', 'Education', '📚', '#7C3AED');

-- Dados iniciais: municipios do Distrito de Lisboa
INSERT INTO municipio (nome, codigo_dico) VALUES
    ('Lisboa', '1106'),
    ('Sintra', '1111'),
    ('Loures', '1108'),
    ('Cascais', '1105'),
    ('Oeiras', '1110'),
    ('Amadora', '1101'),
    ('Odivelas', '1109'),
    ('Vila Franca de Xira', '1112'),
    ('Mafra', '1107'),
    ('Torres Vedras', '1114'),
    ('Alenquer', '1102'),
    ('Arruda dos Vinhos', '1103'),
    ('Azambuja', '1104'),
    ('Sobral de Monte Agrado', '1113'),
    ('Lourinha', '1115'),
    ('Cadaval', '1116');
