class TextToSqlProxy < Formula
  desc "Local HTTP proxy bridging web apps with AI CLI tools to generate SQL"
  homepage "https://github.com/tobilg/ai-cli-proxy"
  version "0.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tobilg/ai-cli-proxy/releases/download/v0.3.3/text-to-sql-proxy-darwin-arm64.tar.gz"
      sha256 "630f9e83a2385a583e343010904299e4ba5b0044af9e9381afdc1860a1247f44"
    end
  end

  def install
    bin.install "text-to-sql-proxy"
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"text-to-sql-proxy"]
    keep_alive true
    log_path var/"log/text-to-sql-proxy.log"
    error_log_path var/"log/text-to-sql-proxy.log"
    environment_variables TEXT_TO_SQL_PROXY_PORT: "4000", TEXT_TO_SQL_PROXY_PROVIDER: "claude", TEXT_TO_SQL_PROXY_DATABASE: "DuckDB", TEXT_TO_SQL_PROXY_ALLOWED_ORIGIN: "https://sql-workbench.com"
  end

  def caveats
    <<~EOS
      text-to-sql-proxy runs an HTTP server that bridges web apps with AI CLI tools.

      Configure via environment variables:
        TEXT_TO_SQL_PROXY_PORT=4000              # Server port (default: 4000)
        TEXT_TO_SQL_PROXY_PROVIDER=claude        # AI provider: claude, gemini, codex, continue, opencode
        TEXT_TO_SQL_PROXY_DATABASE=DuckDB        # Target database dialect
        TEXT_TO_SQL_PROXY_ALLOWED_ORIGIN=https://sql-workbench.com  # CORS origin
        TEXT_TO_SQL_PROXY_TLS_CERT=/path/to/cert.pem   # Optional: TLS certificate
        TEXT_TO_SQL_PROXY_TLS_KEY=/path/to/key.pem     # Optional: TLS private key

      To start as a background service:
        brew services start text-to-sql-proxy

      To stop the service:
        brew services stop text-to-sql-proxy

      To restart the service:
        brew services restart text-to-sql-proxy

      Or run manually:
        text-to-sql-proxy

      Logs are written to:
        #{var}/log/text-to-sql-proxy.log

      For HTTPS with self-signed certificates, use mkcert:
        brew install mkcert
        mkcert -install
        mkcert localhost 127.0.0.1 ::1
        TEXT_TO_SQL_PROXY_TLS_CERT=localhost+2.pem TEXT_TO_SQL_PROXY_TLS_KEY=localhost+2-key.pem text-to-sql-proxy
    EOS
  end

  test do
    assert_match "text-to-sql-proxy", shell_output("#{bin}/text-to-sql-proxy --version")
  end
end
