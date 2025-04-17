#include <boost/beast.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio.hpp>
#include <boost/json.hpp>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>   // for std::getenv
#include <filesystem>

namespace beast = boost::beast;
namespace http = beast::http;
namespace net = boost::asio;
namespace json = boost::json;
using tcp = net::ip::tcp;

// Global quotes storage
json::array quotes;


void load_quotes(const std::string& default_filename) {
    std::ifstream file(default_filename);
    if (!file) {
        const char* env_path = std::getenv("QUOTES_FILE");
        if (env_path) {
            std::cerr << "quotes.json not found in current directory, trying QUOTES_FILE=" << env_path << std::endl;
            file.open(env_path);
            if (!file) {
                throw std::runtime_error(std::string("Could not open file from QUOTES_FILE env var: ") + env_path);
            }
        } else {
            throw std::runtime_error("quotes.json not found in current directory and QUOTES_FILE is not set.");
        }
    }

    std::stringstream buffer;
    buffer << file.rdbuf();
    quotes = json::parse(buffer.str()).as_array();
}


template <class Body, class Allocator, class Send>
void handle_request(http::request<Body, http::basic_fields<Allocator>>&& req, Send&& send) {
    if (req.method() != http::verb::get) {
        return send(http::response<http::string_body>{
            http::status::bad_request, req.version(), "Only GET allowed"});
    }

		const std::string target(req.target());

    http::response<http::string_body> res{http::status::ok, req.version()};
    res.set(http::field::content_type, "application/json");

    if (target == "/quotes") {
        res.body() = json::serialize(quotes);
    } else if (target.rfind("/quotes/", 0) == 0) {
        std::string index_str = target.substr(8);
        try {
            size_t index = std::stoul(index_str);
            if (index < quotes.size()) {
                res.body() = json::serialize(quotes[index]);
            } else {
                res.result(http::status::not_found);
                res.body() = R"({"error":"Index out of bounds"})";
            }
        } catch (...) {
            res.result(http::status::bad_request);
            res.body() = R"({"error":"Invalid index"})";
        }
    } else {
        res.result(http::status::not_found);
        res.body() = R"({"error":"Not found"})";
    }

    res.prepare_payload();
    send(std::move(res));
}


void do_session(tcp::socket socket) {
    beast::flat_buffer buffer;
    http::request<http::string_body> req;

    try {
        http::read(socket, buffer, req);

        handle_request(std::move(req), [&](http::response<http::string_body>&& res) {
            http::write(socket, res);
        });
    } catch (const std::exception& ex) {
        std::cerr << "Session error: " << ex.what() << std::endl;
    }

    beast::error_code ec;
    socket.shutdown(tcp::socket::shutdown_send, ec);
}


int main() {
    try {
        load_quotes("quotes.json");

        net::io_context ioc{1};
        tcp::acceptor acceptor{ioc, {tcp::v4(), 3000}};

        std::cout << "Server listening on http://localhost:3000\n";

        for (;;) {
            tcp::socket socket{ioc};
            acceptor.accept(socket);
            do_session(std::move(socket));
        }
    } catch (const std::exception& ex) {
        std::cerr << "Fatal error: " << ex.what() << std::endl;
        return 1;
    }
}

