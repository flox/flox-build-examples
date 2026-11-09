import json
import logging
import sys

import numpy
from django.conf import settings
from django.http import JsonResponse
from django.urls import path

logger = logging.getLogger("quotes-app-python")


def load_quotes() -> numpy.ndarray:
    with open(settings.BASE_DIR / "quotes.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, list) or not all(isinstance(q, str) for q in data):
        raise ValueError("quotes.json must be a JSON array of strings")
    logger.info("Loaded %d quotes", len(data))
    # numpy is here so the package carries a native-code wheel; on Linux the build's
    # auto-patchelf step is what lets it find libstdc++ and libz in run mode.
    return numpy.array(data)


quotes = load_quotes()


def versions(request):
    return JsonResponse({"python": sys.version.split()[0], "numpy": numpy.__version__})


def all_quotes(request):
    return JsonResponse(quotes.tolist(), safe=False)


def quote_by_index(request, index: int):
    if index < 0 or index >= quotes.size:
        return JsonResponse({"detail": f"Failed to get quote at index: {index}"}, status=500)
    return JsonResponse(str(quotes[index]), safe=False)


# No trailing slashes: CommonMiddleware would otherwise answer /quotes/1 with a redirect.
urlpatterns = [
    path("", versions),
    path("quotes", all_quotes),
    path("quotes/<int:index>", quote_by_index),
]
