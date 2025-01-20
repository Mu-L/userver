#pragma once

/// @file userver/clients/http/response.hpp
/// @brief @copybrief clients::http::Response

#include <string>

#include <userver/clients/http/error.hpp>
#include <userver/clients/http/local_stats.hpp>
#include <userver/http/header_map.hpp>
#include <userver/http/status_code.hpp>
#include <userver/server/http/http_response_cookie.hpp>
#include <userver/utils/str_icase.hpp>

USERVER_NAMESPACE_BEGIN

namespace clients::http {

using Status = USERVER_NAMESPACE::http::StatusCode;

/// Headers container type
using Headers = USERVER_NAMESPACE::http::headers::HeaderMap;

/// Class that will be returned for successful request
class Response final {
public:
    using CookiesMap = server::http::Cookie::CookiesMap;

    Response() = default;

    /// response string
    std::string& sink_string() { return response_; }

    /// body as string
    std::string body() const& { return response_; }
    std::string&& body() && { return std::move(response_); }

    /// body as string_view
    std::string_view body_view() const { return response_; }

    /// return reference to headers
    const Headers& headers() const { return headers_; }
    Headers& headers() { return headers_; }
    const CookiesMap& cookies() const { return cookies_; }
    CookiesMap& cookies() { return cookies_; }

    /// status_code
    Status status_code() const;
    /// check status code
    bool IsOk() const { return status_code() == Status::OK; }
    bool IsError() const { return static_cast<uint16_t>(status_code()) >= 400; }

    static void RaiseForStatus(int code, const LocalStats& stats);

    void raise_for_status() const;

    /// returns statistics on request execution like count of opened sockets,
    /// connect time...
    LocalStats GetStats() const;

    void SetStats(const LocalStats& stats) { stats_ = stats; }
    void SetStatusCode(Status status_code) { status_code_ = status_code; }

private:
    Headers headers_;
    CookiesMap cookies_;
    std::string response_;
    Status status_code_{Status::Invalid};
    LocalStats stats_;
};

}  // namespace clients::http

USERVER_NAMESPACE_END
