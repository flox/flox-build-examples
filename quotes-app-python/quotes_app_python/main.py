import json
import logging
from pathlib import Path
from typing import List

import uvicorn
from fastapi import FastAPI, HTTPException

HOST = "0.0.0.0"
PORT = 3000
QUOTES_FILENAME = "quotes.json"


class AppState:
    def __init__(self) -> None:
        self.quotes: List[str] = self._load_quotes()

    def _load_quotes(self) -> List[str]:
        quotes_path = Path(__file__).parent / QUOTES_FILENAME

        if not quotes_path.exists():
            raise FileNotFoundError(f"{QUOTES_FILENAME} not found in {quotes_path.parent!s}")

        try:
            with open(quotes_path, "r", encoding="utf-8") as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            raise

        if not isinstance(data, list) or not all(isinstance(q, str) for q in data):
            raise ValueError(f"{QUOTES_FILENAME} must be a JSON array of strings")

        logger.info(f"Loaded {len(data)} quotes")
        return data


# Initialize shared state once
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("quotes-app-python")
state = AppState()
app = FastAPI()


@app.get("/quotes", response_model=List[str])
async def all_quotes():
    """
    Return all quotes as a JSON array of strings.
    """
    logger.info("Querying all quotes")
    return state.quotes


@app.get("/quotes/{index}", response_model=str)
async def quote_by_index(index: int):
    """
    Return a single quote by its zero-based index.
    If the index is out of range, raise a 500 Internal Server Error.
    """
    logger.info(f"Querying quote at index {index}")
    try:
        return state.quotes[index]
    except IndexError:
        err_msg = f"Failed to get quote at index: {index}"
        logger.error(err_msg)
        raise HTTPException(status_code=500, detail=err_msg)

def main():
    logger.info("Starting server on http://%s:%d", HOST, PORT)
    uvicorn.run(app, host=HOST, port=PORT, log_level="info")

if __name__ == "__main__":
    main()
