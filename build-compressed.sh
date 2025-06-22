#!/bin/bash
# 編譯並使用 UPX 壓縮
deno compile --allow-net --allow-read --allow-env --target x86_64-unknown-linux-gnu --output server src/server.ts

# 安裝 UPX (如果還沒有)
if ! command -v upx &> /dev/null; then
    echo "Installing UPX..."
    brew install upx
fi

# 壓縮二進位檔案 (可減少 50-70%)
upx --best --lzma server