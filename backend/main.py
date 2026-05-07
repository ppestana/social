from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Ponte Digital API",
    description="Plataforma de Apoio Social — Distrito de Lisboa",
    version="0.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"status": "ok", "projeto": "Ponte Digital", "versao": "0.1.0"}

@app.get("/api/v1/health")
def health():
    return {"status": "healthy"}
