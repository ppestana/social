-- ============================================================
-- Ponte Digital -- Centros de Emprego IEFP
-- Fonte: iefp.pt/redecentros (dados verificados)
-- Distrito de Lisboa -- Maio 2026
-- ============================================================

-- Actualizar o Centro de Emprego de Lisboa (corrigir morada real)
UPDATE recurso SET
    nome = 'Centro de Emprego e Formação Profissional de Lisboa',
    morada = 'Av. 5 de Outubro, 24, 1050-057 Lisboa',
    telefone = '215 802 100',
    email = NULL,
    geom = ST_MakePoint(-9.1470, 38.7346),
    horario = '{"segunda":"09:00-17:00","terca":"09:00-17:00","quarta":"09:00-17:00","quinta":"09:00-17:00","sexta":"09:00-17:00"}',
    verificado = TRUE
WHERE nome = 'Centro de Emprego de Lisboa' AND municipio_id = 1;

-- Actualizar o Centro de Emprego de Cascais (corrigir morada real)
UPDATE recurso SET
    nome = 'Centro de Emprego de Cascais',
    morada = 'Av. Valbom, 17, 1º, 2750-508 Cascais',
    telefone = '215 802 520',
    geom = ST_MakePoint(-9.4185, 38.6999),
    horario = '{"segunda":"09:00-17:00","terca":"09:00-17:00","quarta":"09:00-17:00","quinta":"09:00-17:00","sexta":"09:00-17:00"}',
    verificado = TRUE
WHERE nome = 'Centro de Emprego de Cascais' AND municipio_id = 4;

-- Serviço de Emprego de Benfica (Lisboa)
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, email, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Serviço de Emprego de Benfica',
 'Apoio na procura de emprego e inscrição no desemprego para residentes da zona de Benfica e arredores.',
 3, 'IEFP — Centro de Emprego e Formação Profissional de Lisboa',
 'Rua das Pedralvas, 15-A, 1500-487 Lisboa',
 1, 'Benfica',
 ST_MakePoint(-9.2059, 38.7537),
 '215 802 190', 'se.benfica@iefp.pt', 'https://www.iefp.pt',
 '{"segunda":"09:00-17:00","terca":"09:00-17:00","quarta":"09:00-17:00","quinta":"09:00-17:00","sexta":"09:00-17:00"}',
 'Desempregados e pessoas à procura de emprego',
 'Comparecer com Cartão de Cidadão. Inscrição gratuita.',
 TRUE, TRUE, FALSE, 'A', 'IEFP / iefp.pt');

-- Serviço de Emprego da Amadora
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, email, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Centro de Emprego e Formação Profissional da Amadora',
 'Apoio na procura de emprego, inscrição no desemprego e formação profissional no município da Amadora.',
 3, 'IEFP — Delegação Regional de Lisboa e Vale do Tejo',
 'Rua D. Nuno Álvares Pereira, 1-A, 2700-327 Amadora',
 6, 'Amadora',
 ST_MakePoint(-9.2407, 38.7598),
 '215 802 320', 'se.amadora@iefp.pt', 'https://www.iefp.pt',
 '{"segunda":"09:00-16:00","terca":"09:00-16:00","quarta":"09:00-16:00","quinta":"09:00-16:00","sexta":"09:00-16:00"}',
 'Desempregados e pessoas à procura de emprego',
 'Comparecer com Cartão de Cidadão. Inscrição gratuita.',
 TRUE, TRUE, FALSE, 'A', 'IEFP / iefp.pt');

-- Centro de Emprego de Loures-Odivelas
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Centro de Emprego de Loures-Odivelas — Serviço de Loures',
 'Apoio na procura de emprego e inscrição no desemprego para residentes de Loures.',
 3, 'IEFP — Delegação Regional de Lisboa e Vale do Tejo',
 'Av. José Saramago, 18, 2674-502 Loures',
 3, 'Loures',
 ST_MakePoint(-9.1681, 38.8313),
 '215 802 280', 'https://www.iefp.pt',
 '{"segunda":"09:00-17:00","terca":"09:00-17:00","quarta":"09:00-17:00","quinta":"09:00-17:00","sexta":"09:00-17:00"}',
 'Desempregados e pessoas à procura de emprego',
 'Comparecer com Cartão de Cidadão. Inscrição gratuita.',
 TRUE, TRUE, FALSE, 'A', 'IEFP / iefp.pt');

-- Delegação Regional IEFP Lisboa (sede)
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, email, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('IEFP — Delegação Regional de Lisboa e Vale do Tejo',
 'Sede da Delegação Regional do IEFP para Lisboa e Vale do Tejo. Informações sobre emprego, formação e medidas de apoio.',
 3, 'IEFP — Instituto do Emprego e Formação Profissional',
 'R. das Picoas, 14, 1069-003 Lisboa',
 1, 'Avenidas Novas',
 ST_MakePoint(-9.1470, 38.7344),
 '215 802 000', 'delegacao.lisboa@iefp.pt', 'https://www.iefp.pt',
 '{"segunda":"09:00-17:00","terca":"09:00-17:00","quarta":"09:00-17:00","quinta":"09:00-17:00","sexta":"09:00-17:00"}',
 'Cidadãos e empresas da região de Lisboa e Vale do Tejo',
 'Sem necessidade de marcação para informações gerais.',
 TRUE, TRUE, FALSE, 'A', 'IEFP / iefp.pt');

-- ============================================================
-- Segurança Social -- Centros Distritais de Lisboa
-- Fonte: seg-social.pt (dados verificados)
-- ============================================================

-- Centro Distrital de Lisboa da Segurança Social
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Segurança Social — Centro Distrital de Lisboa',
 'Atendimento presencial para prestações sociais: RSI, abono de família, pensões, subsídio de desemprego e outros apoios da Segurança Social.',
 4, 'Instituto da Segurança Social, I.P.',
 'Rua Rosa Araújo, 43, 1250-194 Lisboa',
 1, 'Santo António',
 ST_MakePoint(-9.1528, 38.7222),
 '300 502 502', 'https://www.seg-social.pt',
 '{"segunda":"09:00-16:00","terca":"09:00-16:00","quarta":"09:00-16:00","quinta":"09:00-16:00","sexta":"09:00-16:00"}',
 'Cidadãos com direito a prestações da Segurança Social',
 'Marcação prévia recomendada. Cartão de Cidadão obrigatório.',
 TRUE, TRUE, FALSE, 'A', 'Segurança Social / seg-social.pt');

-- Serviço de Atendimento da Segurança Social — Amadora
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Segurança Social — Serviço Local da Amadora',
 'Atendimento presencial para prestações sociais e apoios da Segurança Social no município da Amadora.',
 4, 'Instituto da Segurança Social, I.P.',
 'Rua Alfredo da Silva, 10, 2700-016 Amadora',
 6, 'Amadora',
 ST_MakePoint(-9.2250, 38.7560),
 '300 502 502', 'https://www.seg-social.pt',
 '{"segunda":"09:00-16:00","terca":"09:00-16:00","quarta":"09:00-16:00","quinta":"09:00-16:00","sexta":"09:00-16:00"}',
 'Residentes da Amadora com direito a prestações da Segurança Social',
 'Marcação prévia recomendada. Cartão de Cidadão obrigatório.',
 TRUE, FALSE, FALSE, 'A', 'Segurança Social / seg-social.pt');

-- Serviço de Atendimento da Segurança Social — Sintra
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Segurança Social — Serviço Local de Sintra',
 'Atendimento presencial para prestações sociais e apoios da Segurança Social no município de Sintra.',
 4, 'Instituto da Segurança Social, I.P.',
 'Av. Heliodoro Salgado, 2, 2710-589 Sintra',
 2, 'Sintra',
 ST_MakePoint(-9.3870, 38.8015),
 '300 502 502', 'https://www.seg-social.pt',
 '{"segunda":"09:00-16:00","terca":"09:00-16:00","quarta":"09:00-16:00","quinta":"09:00-16:00","sexta":"09:00-16:00"}',
 'Residentes de Sintra com direito a prestações da Segurança Social',
 'Marcação prévia recomendada. Cartão de Cidadão obrigatório.',
 TRUE, FALSE, FALSE, 'A', 'Segurança Social / seg-social.pt');

-- Segurança Social — Torres Vedras
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Segurança Social — Serviço Local de Torres Vedras',
 'Atendimento presencial para prestações sociais e apoios da Segurança Social no município de Torres Vedras.',
 4, 'Instituto da Segurança Social, I.P.',
 'Rua Cândido dos Reis, 5, 2560-275 Torres Vedras',
 10, 'Torres Vedras',
 ST_MakePoint(-9.2610, 39.0905),
 '300 502 502', 'https://www.seg-social.pt',
 '{"segunda":"09:00-16:00","terca":"09:00-16:00","quarta":"09:00-16:00","quinta":"09:00-16:00","sexta":"09:00-16:00"}',
 'Residentes de Torres Vedras com direito a prestações da Segurança Social',
 'Marcação prévia recomendada. Cartão de Cidadão obrigatório.',
 TRUE, FALSE, FALSE, 'A', 'Segurança Social / seg-social.pt');

-- Linha de Apoio da Segurança Social (nacional)
INSERT INTO recurso (nome, descricao, categoria_id, organizacao, morada, municipio_id, freguesia, geom, telefone, website, horario, publico_alvo, condicoes_acesso, activo, verificado, urgente, camada, fonte) VALUES
('Segurança Social — Linha de Apoio 300 502 502',
 'Linha telefónica de apoio da Segurança Social para informações sobre prestações, marcações e esclarecimentos. Disponível em todo o país.',
 4, 'Instituto da Segurança Social, I.P.',
 'Av. 5 de Outubro, 175, 1069-451 Lisboa',
 1, 'Avenidas Novas',
 ST_MakePoint(-9.1510, 38.7380),
 '300 502 502', 'https://www.seg-social.pt',
 '{"segunda":"09:00-18:00","terca":"09:00-18:00","quarta":"09:00-18:00","quinta":"09:00-18:00","sexta":"09:00-18:00"}',
 'Todos os cidadãos com dúvidas ou necessidades relacionadas com a Segurança Social',
 'Sem necessidade de deslocação. Contacto por telefone gratuito.',
 TRUE, TRUE, TRUE, 'A', 'Segurança Social / seg-social.pt');
