
from fastapi import FastAPI

app = FastAPI(
    title="Sistema de Almacén API",
    description="Backend para gestionar pedidos, compras e inventario",
    version="1.0.0"
)


@app.get("/")
def inicio():
    return {
        "mensaje": "Sistema de Almacén API funcionando",
        "version": "1.0.0"
    }


@app.get("/health")
def health():
    return {
        "status": "ok"
    }
