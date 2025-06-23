use std::sync::Arc;

use anyhow::{Context, anyhow};
use axum::{
    Router,
    extract::{MatchedPath, Path, Request, State},
    http::StatusCode,
    response::{IntoResponse, Json, Response},
    routing::get,
};
use serde::{Deserialize, Serialize};
use tower_http::trace::TraceLayer;
use tracing::{info, instrument};

/// A list of quotes loaded from disk.
#[derive(Debug, Serialize, Deserialize)]
struct Quotes(Vec<String>);

#[derive(Debug)]
struct AppState {
    quotes: Quotes,
}

#[derive(Debug)]
struct AppError(anyhow::Error);

// Tell axum how to convert `AppError` into a response.
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Encountered an error: {}", self.0),
        )
            .into_response()
    }
}

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    // initialize tracing
    tracing_subscriber::fmt::init();

    // Prepare the application state
    let state = AppState {
        quotes: load_quotes()?,
    };
    let shared_state = Arc::new(state);

    // build our application with a route
    let app = Router::new()
        .route("/quotes", get(all_quotes))
        .route("/quotes/{idx}", get(quote_by_index))
        .layer(
            TraceLayer::new_for_http()
                // Create our own span for the request and include the matched path. The matched
                // path is useful for figuring out which handler the request was routed to.
                .make_span_with(|req: &Request| {
                    let method = req.method();
                    let uri = req.uri();

                    // axum automatically adds this extension.
                    let matched_path = req
                        .extensions()
                        .get::<MatchedPath>()
                        .map(|matched_path| matched_path.as_str());

                    tracing::info_span!("request", %method, %uri, matched_path)
                }),
        )
        .with_state(shared_state);

    // run our app with hyper, listening globally on port 3000
    info!("starting server");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app)
        .await
        .context("server was terminated")?;
    Ok(())
}

/// Load the quotes from disk
fn load_quotes() -> Result<Quotes, anyhow::Error> {
    let quotes_text = include_str!("../quotes.json");
    let quotes: Quotes =
        serde_json::from_str(quotes_text).context("failed to deserialize quotes")?;
    Ok(quotes)
}

#[instrument(skip_all)]
async fn all_quotes(
    State(app_state): State<Arc<AppState>>,
) -> Result<Json<serde_json::Value>, AppError> {
    info!("querying all quotes");
    serde_json::to_value(&app_state.quotes)
        .context("failed to convert quotes to JSON")
        .map_err(AppError)
        .map(Json)
}

#[instrument(skip(app_state))]
async fn quote_by_index(
    State(app_state): State<Arc<AppState>>,
    Path(index): Path<usize>,
) -> Result<Json<serde_json::Value>, AppError> {
    info!("querying quote by index");
    app_state
        .quotes
        .0
        .get(index)
        .ok_or(anyhow!("failed to get quote at index: {index}"))
        .inspect(|_maybe_quote| {
            info!("found quote");
        })
        .map_err(AppError)
        .map(|quote| serde_json::Value::String(quote.clone()))
        .map(Json)
}
