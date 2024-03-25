#include "Lightstreamer/HxPoco/HttpClient.h"

#include <iostream>
#include <sstream>
#include "Poco/URI.h"
#include "Poco/Net/HTTPClientSession.h"
#include "Poco/Net/HTTPSClientSession.h"
#include "Poco/Net/HTTPRequest.h"
#include "Poco/Net/HTTPResponse.h"
#include "Poco/CountingStream.h"
#include "Poco/Net/NameValueCollection.h"
#include "Lightstreamer/HxPoco/Network.h"

namespace {

using Poco::URI;
using Poco::Net::HTTPClientSession;
using Poco::Net::HTTPSClientSession;
using Poco::Net::HTTPRequest;
using Poco::Net::HTTPResponse;
using Poco::Net::HTTPMessage;
using Poco::Net::Context;
using Poco::FastMutex;
using Poco::Event;
using Poco::Net::NameValueCollection;

using Lightstreamer::HxPoco::HttpClient;
using Lightstreamer::HxPoco::CookieJar;
using Lightstreamer::HxPoco::Network;

std::istream &getLine(std::istream& is, std::string& line) {
  auto& res = std::getline(is, line);
  auto sz = line.size();
  if (sz > 0 && line.back() == '\r') {
    line.resize(sz - 1);
  }
  return res;
}

} // END unnamed namespace

HttpClient::HttpClient(const char* url, const char* body, const std::unordered_map<std::string, std::string>& headers, const HTTPClientSession::ProxyConfig& proxy) : 
  _url(url),
  _body(body),
  _headers(headers),
  _proxy(proxy),
  _disposed(false)
{}

HttpClient::~HttpClient()
{
  dispose();
}

void HttpClient::dispose() {
  if (_disposed.exchange(true)) {
    return;
  }

  try
  {
    if (_session) {
      _session->abort();
    }
  }
  catch(...)
  {
    // there is nothing we can do
  }
  
  try
  {
    stop();
    wait();
  }
  catch (...)
  {
    poco_unexpected();
  }
}

std::streamsize HttpClient::computeContentLength() {
  Poco::CountingOutputStream ostr;
  ostr << _body;
  return ostr.chars();
}

void HttpClient::run() {
  try 
  {
    URI url(_url);
    auto secure = url.getScheme() == "https";
    auto host = url.getHost();
    auto port = url.getPort();
    auto path = url.getPathAndQuery();

    if (secure) {
      Context::Ptr pContext = Network::_sslCtx;
      _session = std::make_unique<HTTPSClientSession>(pContext);
    } else {
      _session = std::make_unique<HTTPClientSession>();
    }
    _session->setHost(host);
    _session->setPort(port);
    _session->setProxyConfig(_proxy);

    HTTPRequest request(HTTPRequest::HTTP_POST, path, HTTPMessage::HTTP_1_1);

    // add cookies
    auto inCookies = Network::_cookieJar.cookiesForUrl(url);
    if (!inCookies.empty()) {
      NameValueCollection nvc;
      for (const auto& c : inCookies) {
        nvc.add(c.getName(), c.getValue());
      }
      request.setCookies(nvc);
    }

    // add request headers
    for (const auto& h : _headers) {
      request.set(h.first, h.second);
    }

    // add other headers (the following code has been derived from HTMLForm::prepareSubmit)
    request.setContentType("application/x-www-form-urlencoded");
		request.setChunkedTransferEncoding(false);
		request.setContentLength(computeContentLength());
    
    // send request: headers+parameters
    std::ostream& ros = _session->sendRequest(request);
    ros << _body;

    Poco::Net::HTTPResponse response;
    std::istream& rs = _session->receiveResponse(response);

    // retrieve cookies
    std::vector<Poco::Net::HTTPCookie> outCookies;
    response.getCookies(outCookies);
    if (!outCookies.empty()) {
      Network::_cookieJar.setCookiesFromUrl(url, outCookies);
    }
    
    std::string line;
    while (!isStopped() && getLine(rs, line)) {
      onText(line.c_str());
    }
    onDone();
  }
  catch(const Poco::Exception& e)
  {
    onError(e.displayText().c_str());
  }
  catch(const std::exception& e)
  {
    onError(e.what());
  }
  catch(...)
  {
    onError("unknown exception");
  }
}
