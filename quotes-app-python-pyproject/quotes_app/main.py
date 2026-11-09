import json
import logging
import sys
from pathlib import Path
from typing import List

import numpy
import uvicorn
from fastapi import FastAPI, HTTPException

HOST = "0.0.0.0"
PORT = 3000
QUOTES_FILENAME = "quotes.json"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("quotes-app-python")


def load_quotes() -> numpy.ndarray:
    quotes_path = Path(__file__).parent / QUOTES_FILENAME
    with open(quotes_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, list) or not all(isinstance(q, str) for q in data):
        raise ValueError(f"{QUOTES_FILENAME} must be a JSON array of strings")
    logger.info("Loaded %d quotes", len(data))
    # numpy is here so the package carries a native-code wheel; on Linux the build's
    # auto-patchelf step is what lets it find libstdc++ and libz in run mode.
    return numpy.array(data)


quotes = load_quotes()
app = FastAPI()


@app.get("/")
async def versions() -> dict:
    return {"python": sys.version.split()[0], "numpy": numpy.__version__}


@app.get("/quotes", response_model=List[str])
async def all_quotes():
    logger.info("Querying all quotes")
    return quotes.tolist()


@app.get("/quotes/{index}", response_model=str)
async def quote_by_index(index: int):
    logger.info("Querying quote at index %d", index)
    if index < 0 or index >= quotes.size:
        err_msg = f"Failed to get quote at index: {index}"
        logger.error(err_msg)
        raise HTTPException(status_code=500, detail=err_msg)
    return str(quotes[index])


def main():
    logger.info("Starting server on http://%s:%d", HOST, PORT)
    uvicorn.run(app, host=HOST, port=PORT, log_level="info")


if __name__ == "__main__":
    main()
