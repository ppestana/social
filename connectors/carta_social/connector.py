"""
Ponte Digital -- Conector Carta Social
Fonte: dados.gov.pt / cartasocial.pt
Importa equipamentos sociais do Distrito de Lisboa para a base de dados.
Versão 1.0 -- Maio 2026
"""

import requests
import json
import psycopg2
import logging
from datetime import datetime

# ── Configuração ──────────────────────────────────────────────
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
log = logging.getLogger(__name__)

DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "dbname": "ponte_digital",
    "user": "pd_user",
    "password": "pd_secure_2026"
}

# Código DICO do Distrito de Lisboa e seus municípios
MUNICIPIOS_LISBOA = {
    "1101": 6,   # Amadora
    "1102": 11,  # Alenquer
    "1103": 12,  # Arruda dos Vinhos
    "1104": 13,  # Azambuja
    "1105": 4,   # Cascais
    "1106": 1,   # Lisboa
    "1107": 9,   # Mafra
    "1108": 3,   # Loures
    "1109": 7,   # Odivelas
    "1110": 5,   # Oeiras
    "1111": 2,   # Sintra
    "1112": 8,   # Vila Franca de Xira
    "1113": 14,  # Sobral de Monte Agrado
    "1114": 10,  # Torres Vedras
    "1115": 15,  # Lourinha
    "1116": 16,  # Cadaval
}

# Mapeamento de respostas sociais para categorias da Ponte Digital
MAPEAMENTO_CATEGORIAS = {
    # Alimentação
    "Ajuda Alimentar": 1,
    "Cantina Social": 1,
    "Refeitorio": 1,
    "Banco Alimentar": 1,
    # Saúde
    "Centro de Saude": 2,
    "Clinica": 2,
    "Unidade de Cuidados": 2,
    "Apoio Domiciliario": 2,
    "Centro de Dia": 2,
    "Estrutura Residencial": 2,
    "Lar": 2,
    "Centro de Reabilitacao": 2,
    # Emprego
    "Centro de Emprego": 3,
    "Formacao Profissional": 3,
    "Centro Qualifica": 3,
    "Empresa de Insercao": 3,
    # Apoio Social
    "Centro de Atendimento": 4,
    "Centro Comunitario": 4,
    "Centro de Acolhimento": 4,
    "Comunidade de Insercao": 4,
    "Apoio Social": 4,
    "Rendimento Social": 4,
    "Centro de Apoio Familiar": 4,
    # Educação
    "Creche": 5,
    "Centro de Actividades": 5,
    "Centro de Educacao": 5,
    "CATL": 5,
    "Jardim de Infancia": 5,
}

def obter_categoria(resposta_social):
    """Mapeia o tipo de resposta social para uma categoria da Ponte Digital."""
    if not resposta_social:
        return 4  # Apoio Social por defeito
    rs = resposta_social.strip()
    for chave, cat_id in MAPEAMENTO_CATEGORIAS.items():
        if chave.lower() in rs.lower():
            return cat_id
    return 4  # Apoio Social por defeito

def descarregar_dados_datagov():
    """Descarrega dados da Carta Social do portal dados.gov.pt."""
    log.info("A descarregar dados do dados.gov.pt...")

    # API do dados.gov.pt para o dataset SED17
    url_api = "https://dados.gov.pt/api/1/datasets/carta-social-equipamentos-e-respostas-sociais/"

    try:
        resp = requests.get(url_api, timeout=30)
        resp.raise_for_status()
        dataset = resp.json()

        # Encontrar recurso CSV ou JSON
        recursos = dataset.get("resources", [])
        url_dados = None
        for r in recursos:
            if r.get("format", "").upper() in ["CSV", "JSON", "GEOJSON"]:
                url_dados = r.get("url")
                log.info(f"Ficheiro encontrado: {r.get('title')} ({r.get('format')})")
                break

        if not url_dados:
            log.warning("Nenhum ficheiro CSV/JSON encontrado. A tentar scraping directo...")
            return scraper_carta_social()

        log.info(f"A descarregar: {url_dados}")
        resp_dados = requests.get(url_dados, timeout=60)
        resp_dados.raise_for_status()
        return processar_csv(resp_dados.text)

    except Exception as e:
        log.error(f"Erro ao aceder dados.gov.pt: {e}")
        log.info("A tentar scraping directo da Carta Social...")
        return scraper_carta_social()

def scraper_carta_social():
    """
    Scraper do site cartasocial.pt por município do distrito de Lisboa.
    Usa a pesquisa por concelho disponível no site.
    """
    from bs4 import BeautifulSoup

    log.info("A fazer scraping da Carta Social por município...")
    equipamentos = []

    # URL de pesquisa por distrito de Lisboa (código 11)
    url_base = "https://www.cartasocial.pt/index.php"

    for codigo_dico, municipio_id in MUNICIPIOS_LISBOA.items():
        try:
            # Pesquisa por concelho
            params = {
                "cod_distrito": "11",
                "cod_concelho": codigo_dico[-2:],  # últimos 2 dígitos
                "pesquisa": "1"
            }

            log.info(f"A pesquisar município {codigo_dico}...")
            resp = requests.get(url_base, params=params, timeout=30,
                              headers={"User-Agent": "PonteDigital/1.0 (social@terradigital.net)"})

            if resp.status_code != 200:
                log.warning(f"Erro HTTP {resp.status_code} para município {codigo_dico}")
                continue

            soup = BeautifulSoup(resp.text, "html.parser")

            # Extrair tabela de resultados
            tabela = soup.find("table", {"class": "resultados"})
            if not tabela:
                tabela = soup.find("table")

            if not tabela:
                log.warning(f"Nenhuma tabela encontrada para município {codigo_dico}")
                continue

            linhas = tabela.find_all("tr")[1:]  # saltar cabeçalho
            for linha in linhas:
                cols = linha.find_all("td")
                if len(cols) >= 4:
                    equipamento = {
                        "nome": cols[0].get_text(strip=True),
                        "resposta_social": cols[1].get_text(strip=True),
                        "morada": cols[2].get_text(strip=True),
                        "municipio_id": municipio_id,
                        "telefone": cols[3].get_text(strip=True) if len(cols) > 3 else None,
                    }
                    equipamentos.append(equipamento)

            log.info(f"Município {codigo_dico}: {len(linhas)} equipamentos encontrados")

        except Exception as e:
            log.error(f"Erro no município {codigo_dico}: {e}")
            continue

    log.info(f"Total de equipamentos recolhidos: {len(equipamentos)}")
    return equipamentos

def processar_csv(conteudo_csv):
    """Processa o CSV da Carta Social e converte para lista de dicionários."""
    import csv
    import io

    equipamentos = []
    reader = csv.DictReader(io.StringIO(conteudo_csv), delimiter=";")

    for linha in reader:
        # Filtrar apenas Distrito de Lisboa (código 11)
        cod_distrito = linha.get("COD_DISTRITO", linha.get("Distrito", ""))
        if str(cod_distrito).strip() != "11":
            continue

        cod_municipio = linha.get("COD_MUNICIPIO", linha.get("COD_CONCELHO", ""))
        municipio_id = MUNICIPIOS_LISBOA.get(str(cod_municipio).strip())
        if not municipio_id:
            continue

        # Tentar obter coordenadas
        try:
            lat = float(linha.get("LATITUDE", linha.get("Latitude", 0)) or 0)
            lng = float(linha.get("LONGITUDE", linha.get("Longitude", 0)) or 0)
        except (ValueError, TypeError):
            lat, lng = 0, 0

        equipamento = {
            "nome": linha.get("DESIGNACAO", linha.get("Designacao", linha.get("Nome", ""))).strip(),
            "resposta_social": linha.get("RESPOSTA_SOCIAL", linha.get("Resposta_Social", "")).strip(),
            "morada": linha.get("MORADA", linha.get("Morada", "")).strip(),
            "municipio_id": municipio_id,
            "telefone": linha.get("TELEFONE", linha.get("Telefone", "")).strip(),
            "email": linha.get("EMAIL", linha.get("Email", "")).strip(),
            "website": linha.get("WEBSITE", linha.get("Website", "")).strip(),
            "latitude": lat,
            "longitude": lng,
        }

        if equipamento["nome"]:
            equipamentos.append(equipamento)

    log.info(f"CSV processado: {len(equipamentos)} equipamentos no Distrito de Lisboa")
    return equipamentos

def inserir_na_bd(equipamentos):
    """Insere os equipamentos na base de dados da Ponte Digital."""
    if not equipamentos:
        log.warning("Nenhum equipamento para inserir.")
        return 0

    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    inseridos = 0
    duplicados = 0

    for eq in equipamentos:
        try:
            # Verificar se já existe (pelo nome + município)
            cur.execute("""
                SELECT id FROM recurso
                WHERE nome = %s AND municipio_id = %s
            """, (eq["nome"], eq["municipio_id"]))

            if cur.fetchone():
                duplicados += 1
                continue

            # Preparar geometria
            geom = None
            if eq.get("latitude") and eq.get("longitude") and \
               eq["latitude"] != 0 and eq["longitude"] != 0:
                geom = f"ST_MakePoint({eq['longitude']}, {eq['latitude']})"

            # Determinar categoria
            categoria_id = obter_categoria(eq.get("resposta_social", ""))

            # Inserir recurso
            cur.execute(f"""
                INSERT INTO recurso (
                    nome, descricao, categoria_id, organizacao,
                    morada, municipio_id,
                    geom,
                    telefone, email, website,
                    activo, verificado, urgente, camada, fonte,
                    data_ultima_verificacao
                ) VALUES (
                    %s, %s, %s, %s,
                    %s, %s,
                    {"" + geom if geom else "NULL"},
                    %s, %s, %s,
                    TRUE, FALSE, FALSE, 'A', 'Carta Social / dados.gov.pt',
                    NOW()
                )
            """, (
                eq["nome"],
                eq.get("resposta_social", ""),
                categoria_id,
                eq["nome"],
                eq.get("morada", ""),
                eq["municipio_id"],
                eq.get("telefone") or None,
                eq.get("email") or None,
                eq.get("website") or None,
            ))

            inseridos += 1

        except Exception as e:
            log.error(f"Erro ao inserir '{eq.get('nome', '?')}': {e}")
            conn.rollback()
            continue

    conn.commit()
    cur.close()
    conn.close()

    log.info(f"Inseridos: {inseridos} | Duplicados ignorados: {duplicados}")
    return inseridos

def main():
    log.info("=== Ponte Digital -- Conector Carta Social ===")
    log.info(f"Início: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # 1. Descarregar dados
    equipamentos = descarregar_dados_datagov()

    if not equipamentos:
        log.error("Nenhum dado obtido. A terminar.")
        return

    # 2. Inserir na base de dados
    total = inserir_na_bd(equipamentos)
    log.info(f"Concluído. {total} novos recursos inseridos na Ponte Digital.")

if __name__ == "__main__":
    main()
