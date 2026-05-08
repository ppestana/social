-- ============================================================
-- Ponte Digital -- Recursos Iniciais Camada A
-- Recursos de Emergência -- Distrito de Lisboa
-- Fonte: Carta Social, Cruz Vermelha, Misericórdias
-- Data: Maio 2026
-- NOTA: Verificar contactos antes de publicar
-- ============================================================

-- Banco Alimentar Contra a Fome de Lisboa
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, email, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Banco Alimentar Contra a Fome de Lisboa',
    'Recolha e distribuição de alimentos a instituições de solidariedade social que apoiam pessoas carenciadas no distrito de Lisboa.',
    1, 'Banco Alimentar Contra a Fome',
    'Rua Engenheiro Ferreira Dias 62, 1600-113 Lisboa',
    1, 'Campolide',
    ST_MakePoint(-9.1583, 38.7223),
    '213 522 454', 'geral@bancoalimentar.pt', 'https://www.bancoalimentar.pt',
    '{"segunda": "09:00-17:00", "terca": "09:00-17:00", "quarta": "09:00-17:00", "quinta": "09:00-17:00", "sexta": "09:00-17:00"}',
    'Famílias e pessoas em situação de carência alimentar, através de instituições parceiras',
    'Acesso indirecto através de IPSS e instituições parceiras registadas',
    TRUE, TRUE, FALSE, 'A', 'Banco Alimentar Contra a Fome'
);

-- Refeitório Social da Misericórdia de Lisboa
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Refeitório Social da Misericórdia de Lisboa',
    'Fornecimento de refeições quentes diárias a pessoas em situação de vulnerabilidade social e económica.',
    1, 'Santa Casa da Misericórdia de Lisboa',
    'Rua Duques de Bragança 9, 1200-162 Lisboa',
    1, 'Santa Maria Maior',
    ST_MakePoint(-9.1397, 38.7089),
    '213 234 600', 'https://www.scml.pt',
    '{"segunda": "12:00-14:00", "terca": "12:00-14:00", "quarta": "12:00-14:00", "quinta": "12:00-14:00", "sexta": "12:00-14:00", "sabado": "12:00-14:00", "domingo": "12:00-14:00"}',
    'Pessoas sem-abrigo e em situação de pobreza extrema',
    'Sem condições de acesso -- refeição gratuita a quem necessitar',
    TRUE, TRUE, TRUE, 'A', 'Santa Casa da Misericórdia de Lisboa'
);

-- Cruz Vermelha Portuguesa -- Centro de Lisboa
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, email, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Cruz Vermelha Portuguesa -- Apoio Alimentar Lisboa',
    'Distribuição de cabazes alimentares e apoio de emergência a famílias em situação de carência.',
    1, 'Cruz Vermelha Portuguesa',
    'Jardim 9 de Abril 1, 1350-019 Lisboa',
    1, 'Estrela',
    ST_MakePoint(-9.1608, 38.7142),
    '213 913 400', 'sede@cruzvermelha.pt', 'https://www.cruzvermelha.pt',
    '{"segunda": "09:30-12:30", "quarta": "09:30-12:30", "sexta": "09:30-12:30"}',
    'Famílias e indivíduos em situação de carência económica comprovada',
    'Inscrição prévia necessária. Apresentar comprovativo de residência e situação económica.',
    TRUE, TRUE, FALSE, 'A', 'Cruz Vermelha Portuguesa'
);

-- Centro de Acolhimento para Sem-Abrigo -- Rua Salitre
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Centro de Acolhimento de Lisboa -- Rua Salitre',
    'Centro de acolhimento nocturno para pessoas sem-abrigo, com fornecimento de dormida, refeição e apoio social.',
    2, 'Santa Casa da Misericórdia de Lisboa',
    'Rua do Salitre 52, 1250-204 Lisboa',
    1, 'Santo António',
    ST_MakePoint(-9.1520, 38.7196),
    '213 234 650', 'https://www.scml.pt',
    '{"segunda": "19:00-09:00", "terca": "19:00-09:00", "quarta": "19:00-09:00", "quinta": "19:00-09:00", "sexta": "19:00-09:00", "sabado": "19:00-09:00", "domingo": "19:00-09:00"}',
    'Pessoas sem-abrigo adultas',
    'Acesso directo. Apresentar-se no centro após as 19h. Sem necessidade de documentação.',
    TRUE, TRUE, TRUE, 'A', 'Santa Casa da Misericórdia de Lisboa'
);

-- Centro de Saúde para Sem-Abrigo -- Clínica da Rua
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, email, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Clínica da Rua -- Cuidados de Saúde Gratuitos',
    'Prestação de cuidados de saúde primários gratuitos a pessoas sem-abrigo e em situação de exclusão social.',
    2, 'Médicos do Mundo Portugal',
    'Rua de São Bento 344, 1200-822 Lisboa',
    1, 'Misericórdia',
    ST_MakePoint(-9.1467, 38.7133),
    '213 961 824', 'geral@medicosdomundom.pt', 'https://www.medicosdomundom.pt',
    '{"segunda": "14:00-17:00", "quarta": "14:00-17:00", "sexta": "10:00-13:00"}',
    'Pessoas sem-abrigo, migrantes sem documentação e população em exclusão social',
    'Sem necessidade de cartão de utente nem documentação. Acesso directo.',
    TRUE, TRUE, FALSE, 'A', 'Médicos do Mundo Portugal'
);

-- Banco de Roupa da Misericórdia de Lisboa
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Banco de Roupa da Misericórdia de Lisboa',
    'Distribuição gratuita de vestuário e calçado a pessoas e famílias em situação de carência.',
    4, 'Santa Casa da Misericórdia de Lisboa',
    'Largo Trindade Coelho 1, 1200-470 Lisboa',
    1, 'Misericórdia',
    ST_MakePoint(-9.1432, 38.7117),
    '213 234 600', 'https://www.scml.pt',
    '{"terca": "10:00-12:30", "quinta": "14:00-16:30"}',
    'Pessoas e famílias em situação de carência económica',
    'Inscrição prévia na assistente social da junta de freguesia ou centro de saúde.',
    TRUE, TRUE, FALSE, 'A', 'Santa Casa da Misericórdia de Lisboa'
);

-- Centro de Emprego de Lisboa
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Centro de Emprego de Lisboa',
    'Apoio na procura de emprego, inscrição no desemprego, formação profissional e orientação vocacional.',
    3, 'IEFP -- Instituto do Emprego e Formação Profissional',
    'Rua Rodrigo da Fonseca 72, 1099-053 Lisboa',
    1, 'Santo António',
    ST_MakePoint(-9.1547, 38.7231),
    '707 204 204', 'https://www.iefp.pt',
    '{"segunda": "09:00-13:00", "terca": "09:00-13:00", "quarta": "09:00-13:00", "quinta": "09:00-13:00", "sexta": "09:00-13:00"}',
    'Desempregados e pessoas à procura de emprego',
    'Comparecer pessoalmente com Cartão de Cidadão. Inscrição gratuita.',
    TRUE, TRUE, FALSE, 'A', 'IEFP'
);

-- Cantina Social de Sintra
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Cantina Social de Sintra',
    'Fornecimento de refeições sociais a preço simbólico ou gratuito a residentes do município de Sintra em situação de carência.',
    1, 'Câmara Municipal de Sintra',
    'Av. Heliodoro Salgado, 2710-589 Sintra',
    2, 'Sintra',
    ST_MakePoint(-9.3881, 38.8026),
    '219 107 600', 'https://www.cm-sintra.pt',
    '{"segunda": "12:00-14:00", "terca": "12:00-14:00", "quarta": "12:00-14:00", "quinta": "12:00-14:00", "sexta": "12:00-14:00"}',
    'Residentes do município de Sintra em situação de carência económica',
    'Inscrição prévia nos serviços sociais da Câmara Municipal. Necessário comprovativo de residência.',
    TRUE, TRUE, FALSE, 'A', 'Câmara Municipal de Sintra'
);

-- Banco Alimentar de Cascais
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Banco Alimentar de Cascais',
    'Distribuição de géneros alimentícios a famílias carenciadas do município de Cascais através de instituições parceiras.',
    1, 'Banco Alimentar de Cascais',
    'Rua Padre Américo 5, 2750-201 Cascais',
    4, 'Cascais',
    ST_MakePoint(-9.4218, 38.6979),
    '214 867 900', 'https://www.bancoalimentar.pt',
    '{"segunda": "09:00-12:30", "quarta": "09:00-12:30", "sexta": "09:00-12:30"}',
    'Famílias carenciadas do município de Cascais, através de instituições parceiras',
    'Acesso indirecto através de IPSS e instituições parceiras registadas no município.',
    TRUE, FALSE, FALSE, 'A', 'Banco Alimentar de Cascais'
);

-- Centro de Apoio ao Sem-Abrigo de Torres Vedras
INSERT INTO recurso (
    nome, descricao, categoria_id, organizacao,
    morada, municipio_id, freguesia,
    geom, telefone, website,
    horario, publico_alvo, condicoes_acesso,
    activo, verificado, urgente, camada, fonte
) VALUES (
    'Centro de Apoio Social de Torres Vedras',
    'Apoio alimentar, social e de encaminhamento a pessoas em situação de vulnerabilidade no município de Torres Vedras.',
    4, 'Santa Casa da Misericórdia de Torres Vedras',
    'Rua Paiva de Andrade 25, 2560-275 Torres Vedras',
    10, 'Torres Vedras',
    ST_MakePoint(-9.2597, 39.0919),
    '261 324 773', 'https://www.scmtorresvedras.pt',
    '{"segunda": "09:00-12:30", "terca": "09:00-12:30", "quarta": "09:00-12:30", "quinta": "09:00-12:30", "sexta": "09:00-12:30"}',
    'Pessoas e famílias em situação de carência no município de Torres Vedras',
    'Contactar previamente por telefone para marcação.',
    TRUE, FALSE, FALSE, 'A', 'Santa Casa da Misericórdia de Torres Vedras'
);
