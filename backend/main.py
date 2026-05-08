"""
Ponte Digital — API REST
FastAPI + SQLAlchemy + PostGIS
Versão 1.0 — Maio 2026
"""

from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session, sessionmaker
from typing import Optional, List
import os

# ── Configuração ─────────────────────────────────────────────
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://pd_user:pd_secure_2026@db:5432/ponte_digital"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# ── App ───────────────────────────────────────────────────────
app = FastAPI(
    title="Ponte Digital API",
    description="Plataforma de Apoio Social — Distrito de Lisboa",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Dependência DB ────────────────────────────────────────────
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ── Endpoints base ────────────────────────────────────────────
@app.get("/")
def root():
    return {
        "status": "ok",
        "projeto": "Ponte Digital",
        "versao": "1.0.0",
        "docs": "/docs"
    }

@app.get("/api/v1/health")
def health(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ── Categorias ────────────────────────────────────────────────
@app.get("/api/v1/categorias")
def get_categorias(db: Session = Depends(get_db)):
    result = db.execute(text("""
        SELECT
            c.id,
            c.slug,
            c.nome_pt,
            c.nome_en,
            c.icone,
            c.cor_hex,
            COUNT(r.id) as total_recursos
        FROM categoria c
        LEFT JOIN recurso r ON r.categoria_id = c.id AND r.activo = TRUE
        GROUP BY c.id
        ORDER BY c.id
    """))
    rows = result.mappings().all()
    return {"categorias": [dict(r) for r in rows]}

# ── Municípios ────────────────────────────────────────────────
@app.get("/api/v1/municipios")
def get_municipios(db: Session = Depends(get_db)):
    result = db.execute(text("""
        SELECT
            m.id,
            m.nome,
            m.codigo_dico,
            COUNT(r.id) as total_recursos
        FROM municipio m
        LEFT JOIN recurso r ON r.municipio_id = m.id AND r.activo = TRUE
        GROUP BY m.id
        ORDER BY m.nome
    """))
    rows = result.mappings().all()
    return {"municipios": [dict(r) for r in rows]}

# ── Recursos ──────────────────────────────────────────────────
@app.get("/api/v1/recursos")
def get_recursos(
    db: Session = Depends(get_db),
    q: Optional[str] = Query(None, description="Pesquisa full-text"),
    categoria: Optional[str] = Query(None, description="Slug da categoria"),
    municipio_id: Optional[int] = Query(None, description="ID do município"),
    camada: Optional[str] = Query(None, description="Camada A, B ou C"),
    verificado: Optional[bool] = Query(None),
    activo: Optional[bool] = Query(True),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=50)
):
    offset = (page - 1) * per_page
    conditions = ["r.activo = :activo"]
    params = {"activo": activo, "limit": per_page, "offset": offset}

    if q:
        conditions.append("""
            to_tsvector('portuguese', r.nome || ' ' || COALESCE(r.descricao, ''))
            @@ plainto_tsquery('portuguese', :q)
        """)
        params["q"] = q

    if categoria:
        conditions.append("c.slug = :categoria")
        params["categoria"] = categoria

    if municipio_id:
        conditions.append("r.municipio_id = :municipio_id")
        params["municipio_id"] = municipio_id

    if camada:
        conditions.append("r.camada = :camada")
        params["camada"] = camada

    if verificado is not None:
        conditions.append("r.verificado = :verificado")
        params["verificado"] = verificado

    where = " AND ".join(conditions)

    result = db.execute(text(f"""
        SELECT
            r.id,
            r.nome,
            r.descricao,
            r.organizacao,
            r.morada,
            r.freguesia,
            r.telefone,
            r.email,
            r.website,
            r.horario,
            r.publico_alvo,
            r.acessibilidade_mobilidade,
            r.activo,
            r.verificado,
            r.urgente,
            r.camada,
            r.data_ultima_verificacao,
            ST_X(r.geom) as longitude,
            ST_Y(r.geom) as latitude,
            c.slug as categoria_slug,
            c.nome_pt as categoria_nome,
            c.icone as categoria_icone,
            c.cor_hex as categoria_cor,
            m.nome as municipio_nome
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        LEFT JOIN municipio m ON r.municipio_id = m.id
        WHERE {where}
        ORDER BY r.urgente DESC, r.verificado DESC, r.nome ASC
        LIMIT :limit OFFSET :offset
    """), params)

    rows = result.mappings().all()

    # Total
    count_result = db.execute(text(f"""
        SELECT COUNT(*) as total
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        LEFT JOIN municipio m ON r.municipio_id = m.id
        WHERE {where}
    """), {k: v for k, v in params.items() if k not in ["limit", "offset"]})

    total = count_result.scalar()

    return {
        "total": total,
        "page": page,
        "per_page": per_page,
        "pages": (total + per_page - 1) // per_page,
        "recursos": [dict(r) for r in rows]
    }

# ── Recurso por ID ────────────────────────────────────────────
@app.get("/api/v1/recursos/{recurso_id}")
def get_recurso(recurso_id: str, db: Session = Depends(get_db)):
    result = db.execute(text("""
        SELECT
            r.*,
            ST_X(r.geom) as longitude,
            ST_Y(r.geom) as latitude,
            c.slug as categoria_slug,
            c.nome_pt as categoria_nome,
            c.icone as categoria_icone,
            c.cor_hex as categoria_cor,
            m.nome as municipio_nome
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        LEFT JOIN municipio m ON r.municipio_id = m.id
        WHERE r.id = :id AND r.activo = TRUE
    """), {"id": recurso_id})

    row = result.mappings().first()
    if not row:
        raise HTTPException(status_code=404, detail="Recurso não encontrado")
    return dict(row)

# ── Recursos próximos (geoespacial) ───────────────────────────
@app.get("/api/v1/recursos/proximos")
def get_proximos(
    db: Session = Depends(get_db),
    lat: float = Query(..., description="Latitude"),
    lng: float = Query(..., description="Longitude"),
    raio_km: float = Query(5.0, description="Raio em km"),
    categoria: Optional[str] = Query(None),
    limit: int = Query(10, ge=1, le=50)
):
    params = {
        "lat": lat, "lng": lng,
        "raio_m": raio_km * 1000,
        "limit": limit
    }
    cat_filter = ""
    if categoria:
        cat_filter = "AND c.slug = :categoria"
        params["categoria"] = categoria

    result = db.execute(text(f"""
        SELECT
            r.id,
            r.nome,
            r.organizacao,
            r.morada,
            r.telefone,
            r.verificado,
            r.urgente,
            ST_X(r.geom) as longitude,
            ST_Y(r.geom) as latitude,
            c.slug as categoria_slug,
            c.nome_pt as categoria_nome,
            c.icone as categoria_icone,
            m.nome as municipio_nome,
            ROUND(
                ST_Distance(
                    r.geom::geography,
                    ST_MakePoint(:lng, :lat)::geography
                )::numeric / 1000, 2
            ) as distancia_km
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        LEFT JOIN municipio m ON r.municipio_id = m.id
        WHERE r.activo = TRUE
          AND r.geom IS NOT NULL
          {cat_filter}
          AND ST_DWithin(
              r.geom::geography,
              ST_MakePoint(:lng, :lat)::geography,
              :raio_m
          )
        ORDER BY distancia_km ASC
        LIMIT :limit
    """), params)

    rows = result.mappings().all()
    return {"recursos": [dict(r) for r in rows]}

# ── Mapa GeoJSON ──────────────────────────────────────────────
@app.get("/api/v1/recursos/mapa")
def get_mapa(
    db: Session = Depends(get_db),
    categoria: Optional[str] = Query(None)
):
    params = {}
    cat_filter = ""
    if categoria:
        cat_filter = "AND c.slug = :categoria"
        params["categoria"] = categoria

    result = db.execute(text(f"""
        SELECT
            r.id,
            r.nome,
            r.organizacao,
            r.telefone,
            r.verificado,
            r.urgente,
            c.slug as categoria_slug,
            c.nome_pt as categoria_nome,
            c.icone as categoria_icone,
            c.cor_hex as categoria_cor,
            ST_X(r.geom) as longitude,
            ST_Y(r.geom) as latitude
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        WHERE r.activo = TRUE AND r.geom IS NOT NULL
        {cat_filter}
        ORDER BY r.urgente DESC, r.nome ASC
    """), params)

    rows = result.mappings().all()

    features = []
    for r in rows:
        features.append({
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [r["longitude"], r["latitude"]]
            },
            "properties": {
                "id": str(r["id"]),
                "nome": r["nome"],
                "organizacao": r["organizacao"],
                "telefone": r["telefone"],
                "verificado": r["verificado"],
                "urgente": r["urgente"],
                "categoria_slug": r["categoria_slug"],
                "categoria_nome": r["categoria_nome"],
                "categoria_icone": r["categoria_icone"],
                "categoria_cor": r["categoria_cor"]
            }
        })

    return {
        "type": "FeatureCollection",
        "features": features
    }

# ── Pesquisa ──────────────────────────────────────────────────
@app.get("/api/v1/pesquisa")
def pesquisa(
    q: str = Query(..., min_length=2),
    db: Session = Depends(get_db)
):
    result = db.execute(text("""
        SELECT
            r.id,
            r.nome,
            r.organizacao,
            r.morada,
            r.telefone,
            r.verificado,
            c.slug as categoria_slug,
            c.nome_pt as categoria_nome,
            c.icone as categoria_icone,
            m.nome as municipio_nome,
            ts_rank(
                to_tsvector('portuguese', r.nome || ' ' || COALESCE(r.descricao, '')),
                plainto_tsquery('portuguese', :q)
            ) as relevancia
        FROM recurso r
        LEFT JOIN categoria c ON r.categoria_id = c.id
        LEFT JOIN municipio m ON r.municipio_id = m.id
        WHERE r.activo = TRUE
          AND to_tsvector('portuguese', r.nome || ' ' || COALESCE(r.descricao, ''))
              @@ plainto_tsquery('portuguese', :q)
        ORDER BY relevancia DESC
        LIMIT 20
    """), {"q": q})

    rows = result.mappings().all()
    return {"query": q, "resultados": [dict(r) for r in rows]}

# ── Feedback ──────────────────────────────────────────────────
@app.post("/api/v1/feedback")
def submeter_feedback(
    recurso_id: str,
    tipo: str,
    descricao: str,
    email_contacto: Optional[str] = None,
    db: Session = Depends(get_db)
):
    db.execute(text("""
        INSERT INTO feedback_publico (recurso_id, tipo, descricao, email_contacto)
        VALUES (:recurso_id, :tipo, :descricao, :email)
    """), {
        "recurso_id": recurso_id,
        "tipo": tipo,
        "descricao": descricao,
        "email": email_contacto
    })
    db.commit()
    return {"status": "ok", "mensagem": "Feedback recebido. Obrigado!"}
