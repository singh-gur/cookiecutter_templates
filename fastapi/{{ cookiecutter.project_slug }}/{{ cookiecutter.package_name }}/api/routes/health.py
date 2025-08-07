from fastapi import APIRouter

router = APIRouter(tags=["health"])

@router.get("/ping")
def ping():
    return {"ping": "pong"}
