#!/bin/bash
# ============================================================================
#
#    ███████╗ ██████╗ ██████╗ ██╗  ██╗██╗   ██╗██████╗ ███████╗
#    ██╔════╝██╔════╝██╔═══██╗██║  ██║██║   ██║██╔══██╗╚══███╔╝
#    █████╗  ██║     ██║   ██║███████║██║   ██║██████╔╝  ███╔╝
#    ██╔══╝  ██║     ██║   ██║██╔══██║██║   ██║██╔══██╗ ███╔╝
#    ███████╗╚██████╗╚██████╔╝██║  ██║╚██████╔╝██████╔╝███████╗
#    ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
#
#                E C O H U B Z   T H E M E   I N S T A L L E R
#                              v1.0.0
#
#    Creator : @RamzOffcID (ʀᴀᴍᴢ)
#    Info    : @ecohubzidinfo
#    Support : https://powershot.my.id
#
# ============================================================================
#   ⚠️  SISTEM & FITUR DEFAULT PTERODACTYL TIDAK DIUBAH
#   ⚠️  HANYA TAMPILAN YANG DI-CUSTOM
#   ⚠️  BACKUP OTOMATIS SEBELUM INSTALL
# ============================================================================

set -e

# ============================================================================
#   BAGIAN 1 — WARNA TERMINAL
# ============================================================================

NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; WHITE='\033[0;37m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_CYAN='\033[96m'; BRIGHT_WHITE='\033[97m'
BG_RED='\033[41m'; BG_GREEN='\033[42m'; BG_YELLOW='\033[43m'
BG_CYAN='\033[46m'; BG_MAGENTA='\033[45m'; BG_BLUE='\033[44m'

# ============================================================================
#   BAGIAN 2 — KONFIGURASI ECOHUBZ
# ============================================================================

ECOHUBZ_VERSION="1.0.0"
ECOHUBZ_NAME="ECOHUBZ"
ECOHUBZ_CREATOR="@RamzOffcID (ʀᴀᴍᴢ)"
ECOHUBZ_INFO="@ecohubzidinfo"
ECOHUBZ_SUPPORT="https://powershot.my.id"
ECOHUBZ_LOGO_URL="https://files.catbox.moe/kekkt1.jpg"
ECOHUBZ_BG_URL="https://files.catbox.moe/umi0u6.jpg"
ECOHUBZ_TOKEN="ecohubz"

PANEL_DIR="/var/www/pterodactyl"
PUBLIC_DIR="$PANEL_DIR/public"
CSS_TARGET="$PUBLIC_DIR/ecohubz-theme.css"
NOTIF_JS="$PUBLIC_DIR/ecohubz-notif.js"
ASSET_DIR="$PUBLIC_DIR/ecohubz-assets"
BLADE_FILE="$PANEL_DIR/resources/views/templates/wrapper.blade.php"
BACKUP_DIR="$PANEL_DIR/.ecohubz-backup"
BACKUP_BLADE="$BACKUP_DIR/wrapper.blade.php.bak"
LOG_FILE="/var/log/ecohubz-installer.log"

# ============================================================================
#   BAGIAN 3 — FUNGSI LOGGING & PRINT
# ============================================================================

log_to_file() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE" 2>/dev/null || true; }

print_info() {
  echo -e "  ${BG_CYAN}${BRIGHT_WHITE}${BOLD}  INFO  ${NC} ${BOLD}${BRIGHT_CYAN}$1${NC}"
  log_to_file "INFO: $1"
}
print_success() {
  echo -e "  ${BG_GREEN}${BRIGHT_WHITE}${BOLD}   OK   ${NC} ${BOLD}${BRIGHT_GREEN}$1${NC}"
  log_to_file "OK: $1"
}
print_warning() {
  echo -e "  ${BG_YELLOW}${BRIGHT_WHITE}${BOLD}  WARN  ${NC} ${BOLD}${BRIGHT_YELLOW}$1${NC}"
  log_to_file "WARN: $1"
}
print_error() {
  echo -e "  ${BG_RED}${BRIGHT_WHITE}${BOLD}  FAIL  ${NC} ${BOLD}${BRIGHT_RED}$1${NC}"
  log_to_file "ERROR: $1"
}
print_step() {
  echo -e ""
  echo -e "  ${BOLD}${BRIGHT_GREEN}▸${NC} ${BOLD}${BRIGHT_WHITE}$1${NC}"
  log_to_file "STEP: $1"
}
print_divider() {
  echo -e "  ${BRIGHT_GREEN}─────────────────────────────────────────────────────${NC}"
}
print_banner() {
  local title="$1"
  echo -e ""
  echo -e "  ${BRIGHT_GREEN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${BRIGHT_GREEN}║${NC}  ${BOLD}${BRIGHT_WHITE}$title${NC}"
  echo -e "  ${BRIGHT_GREEN}╚══════════════════════════════════════════════════════╝${NC}"
  echo -e ""
}
print_loading() {
  local text="$1"
  local duration="${2:-2}"
  local chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local end=$((SECONDS + duration))
  while [ $SECONDS -lt $end ]; do
    for char in "${chars[@]}"; do
      echo -ne "\r  ${BRIGHT_GREEN}${char}${NC}  ${BRIGHT_WHITE}$text${NC}  "
      sleep 0.1
    done
  done
  echo -ne "\r  ${BRIGHT_GREEN}✓${NC}  ${BRIGHT_WHITE}$text${NC}     \n"
}

# ============================================================================
#   BAGIAN 4 — BANNER UTAMA
# ============================================================================

show_main_banner() {
  clear
  echo -e ""
  echo -e "${BRIGHT_GREEN}    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}                                                              ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}███████╗ ██████╗ ██████╗ ██╗  ██╗██╗   ██╗██████╗ ███████╗${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}██╔════╝██╔════╝██╔═══██╗██║  ██║██║   ██║██╔══██╗╚══███╔╝${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}█████╗  ██║     ██║   ██║███████║██║   ██║██████╔╝  ███╔╝ ${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}██╔══╝  ██║     ██║   ██║██╔══██║██║   ██║██╔══██╗ ███╔╝  ${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}███████╗╚██████╗╚██████╔╝██║  ██║╚██████╔╝██████╔╝███████╗${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}   ${BOLD}${BRIGHT_CYAN}╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝${NC}   ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}                                                              ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}          ${BOLD}${BRIGHT_WHITE}T H E M E   F O R   P T E R O D A C T Y L${NC}             ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓${NC}                     ${BRIGHT_GREEN}Version ${ECOHUBZ_VERSION}${NC}                          ${BRIGHT_GREEN}▓${NC}"
  echo -e "${BRIGHT_GREEN}    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
  echo -e ""
  echo -e "           ${BRIGHT_WHITE}Creator :${NC}  ${BRIGHT_GREEN}${ECOHUBZ_CREATOR}${NC}"
  echo -e "           ${BRIGHT_WHITE}Info    :${NC}  ${BRIGHT_GREEN}${ECOHUBZ_INFO}${NC}"
  echo -e "           ${BRIGHT_WHITE}Support :${NC}  ${BRIGHT_GREEN}${ECOHUBZ_SUPPORT}${NC}"
  echo -e ""
}

# ============================================================================
#   BAGIAN 5 — CEK SYSTEM
# ============================================================================

check_root() {
  if [ "$EUID" -ne 0 ]; then
    print_error "Script wajib dijalankan sebagai ROOT!"
    exit 1
  fi
}

check_panel() {
  if [ ! -d "$PANEL_DIR" ]; then
    print_error "Panel Pterodactyl tidak ditemukan di $PANEL_DIR"
    exit 1
  fi
  if [ ! -f "$PANEL_DIR/artisan" ]; then
    print_error "File artisan tidak ada. Panel corrupt."
    exit 1
  fi
}

check_internet() {
  print_info "Cek koneksi internet..."
  if ! curl -fsSL --max-time 5 https://raw.githubusercontent.com >/dev/null 2>&1; then
    print_warning "Koneksi lambat / tidak stabil."
  else
    print_success "Koneksi OK."
  fi
}

check_token() {
  print_banner "VERIFIKASI AKSES"
  echo -e "  ${BRIGHT_WHITE}Masukkan token akses ECOHUBZ:${NC}"
  echo -n -e "  ${BRIGHT_GREEN}Token ${BRIGHT_WHITE}> ${NC}"
  read -r USER_TOKEN
  if [ "$USER_TOKEN" = "$ECOHUBZ_TOKEN" ]; then
    print_success "Token valid!"
  else
    print_error "Token salah!"
    echo -e "  ${BRIGHT_WHITE}Hubungi ${BRIGHT_GREEN}${ECOHUBZ_INFO}${BRIGHT_WHITE} untuk token.${NC}"
    exit 1
  fi
  sleep 1
}

# ============================================================================
#   BAGIAN 6 — BACKUP
# ============================================================================

backup_panel() {
  print_step "Backup konfigurasi panel..."
  mkdir -p "$BACKUP_DIR"
  if [ -f "$BLADE_FILE" ] && [ ! -f "$BACKUP_BLADE" ]; then
    cp "$BLADE_FILE" "$BACKUP_BLADE"
    print_success "wrapper.blade.php di-backup."
  fi
  cat > "$BACKUP_DIR/backup-info.txt" <<EOF
ECOHUBZ Theme Backup
====================
Date    : $(date)
Version : ${ECOHUBZ_VERSION}
Creator : ${ECOHUBZ_CREATOR}
Panel   : ${PANEL_DIR}
EOF
  print_success "Backup OK: $BACKUP_DIR"
}

# ============================================================================
#   BAGIAN 7 — DOWNLOAD ASSETS
# ============================================================================

download_assets() {
  print_step "Download assets ECOHUBZ..."
  mkdir -p "$ASSET_DIR"
  if curl -fsSL --max-time 15 "$ECOHUBZ_LOGO_URL" -o "$ASSET_DIR/logo.jpg"; then
    print_success "Logo OK."
  else
    print_warning "Logo gagal diunduh, pakai URL langsung."
  fi
  if curl -fsSL --max-time 15 "$ECOHUBZ_BG_URL" -o "$ASSET_DIR/bg.jpg"; then
    print_success "Background OK."
  else
    print_warning "Background gagal diunduh, pakai URL langsung."
  fi
}

# ============================================================================
#   BAGIAN 8 — GENERATE CSS ECOHUBZ
# ============================================================================

generate_css() {
  print_step "Generate CSS ECOHUBZ..."
  cat > "$CSS_TARGET" <<'ECOHUBZ_CSS_EOF'
/* ==========================================================================
   ECOHUBZ THEME v1.0.0
   Creator: @RamzOffcID (ʀᴀᴍᴢ) | Info: @ecohubzidinfo
   Support: https://ecohubzoffc.my.id
   Sistem & fitur default Pterodactyl TIDAK diubah.
   ========================================================================== */

:root {
  --ehz-bg: #050505;
  --ehz-card: rgba(10, 15, 10, 0.55);
  --ehz-border: rgba(0, 255, 136, 0.25);
  --ehz-green: #00ff88;
  --ehz-green-dark: #007a3d;
  --ehz-green-glow: 0 0 12px rgba(0, 255, 136, 0.55);
  --ehz-red: #ff3b6b;
  --ehz-yellow: #ffcc00;
  --ehz-text: #e6ffe6;
  --ehz-dim: #8fbfa0;
  --ehz-font-mono: 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
}

html, body {
  background-color: var(--ehz-bg) !important;
  color: var(--ehz-text) !important;
}

body, #app, .app, .content-wrapper, .content,
.page-content, .main-content, .wrapper {
  background:
    linear-gradient(135deg, rgba(0,0,0,0.85), rgba(0,20,10,0.92)),
    url('/ecohubz-assets/bg.jpg') center/cover fixed no-repeat !important;
  background-color: var(--ehz-bg) !important;
  color: var(--ehz-text) !important;
  min-height: 100vh;
}

body::before {
  content: ""; position: fixed; inset: 0; pointer-events: none; z-index: 0;
  background:
    radial-gradient(circle at 20% 10%, rgba(0,255,136,0.10), transparent 45%),
    radial-gradient(circle at 80% 90%, rgba(0,255,136,0.08), transparent 45%);
}

.sidebar, .navbar, .nav, .main-sidebar, nav.main-header,
.main-header, .navbar-static-top, [class*="Navbar"], [class*="Sidebar"] {
  background: rgba(0,0,0,0.55) !important;
  backdrop-filter: blur(14px) saturate(140%);
  -webkit-backdrop-filter: blur(14px) saturate(140%);
  border-right: 1px solid var(--ehz-border) !important;
  border-bottom: 1px solid var(--ehz-border) !important;
  box-shadow: 0 0 24px rgba(0,255,136,0.12);
}

.navbar a, .sidebar a, .nav a { color: var(--ehz-text) !important; transition: all .2s ease; }
.navbar a:hover, .sidebar a:hover, .nav a:hover {
  color: var(--ehz-green) !important;
  text-shadow: var(--ehz-green-glow);
}

.navbar-brand img, .sidebar .logo img, img.brand-image,
.login-logo img, img[alt*="Pterodactyl"], img[alt*="pterodactyl"] {
  content: url('https://files.catbox.moe/kekkt1.jpg') !important;
  filter: drop-shadow(0 0 8px rgba(0,255,136,0.7)) !important;
  max-height: 42px;
}

.card, .box, .panel, .server-card, .server-block,
[class*="ServerCard"], [class*="server-card"], [class*="StatBlock"] {
  background: var(--ehz-card) !important;
  backdrop-filter: blur(16px) saturate(160%);
  -webkit-backdrop-filter: blur(16px) saturate(160%);
  border: 1px solid var(--ehz-border) !important;
  border-radius: 14px !important;
  box-shadow: 0 4px 24px rgba(0,0,0,0.6), var(--ehz-green-glow);
  color: var(--ehz-text) !important;
  transition: all .2s ease;
}

.card:hover, .box:hover, .panel:hover,
.server-card:hover, .server-block:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 32px rgba(0,0,0,0.7), 0 0 24px rgba(0,255,136,0.45);
}

h1, h2, h3, h4, h5, h6, .card-title, .box-title, .server-name {
  color: var(--ehz-text) !important;
}
.text-muted, small, .text-secondary { color: var(--ehz-dim) !important; }
a { color: var(--ehz-green) !important; transition: all .2s ease; }
a:hover { color: #00cc6a !important; text-shadow: var(--ehz-green-glow); }

.text-success, [class*="status"].online {
  color: var(--ehz-green) !important;
  text-shadow: var(--ehz-green-glow);
}
.text-danger, [class*="status"].offline { color: var(--ehz-red) !important; }
.text-warning { color: var(--ehz-yellow) !important; }

.btn, button, .btn-primary {
  background: linear-gradient(135deg, rgba(0,255,136,0.15), rgba(0,255,136,0.05)) !important;
  border: 1px solid var(--ehz-green) !important;
  color: var(--ehz-green) !important;
  border-radius: 10px !important;
  font-weight: 600;
  padding: 8px 18px;
  transition: all .2s ease;
}
.btn:hover, button:hover, .btn-primary:hover {
  background: var(--ehz-green) !important;
  color: #000 !important;
  box-shadow: 0 0 20px rgba(0,255,136,0.7);
  transform: translateY(-1px);
}

input, select, textarea, .form-control {
  background: rgba(0,0,0,0.55) !important;
  border: 1px solid var(--ehz-border) !important;
  color: var(--ehz-text) !important;
  border-radius: 10px !important;
}
input:focus, select:focus, textarea:focus, .form-control:focus {
  border-color: var(--ehz-green) !important;
  box-shadow: 0 0 0 3px rgba(0,255,136,0.18) !important;
  outline: none !important;
}
input::placeholder, textarea::placeholder { color: #5a7a63 !important; }

.login-page, .login-box, .login-card,
[class*="LoginContainer"], [class*="AuthContainer"] {
  background:
    linear-gradient(135deg, rgba(0,0,0,0.82), rgba(0,25,12,0.92)),
    url('https://files.catbox.moe/umi0u6.jpg') center/cover fixed no-repeat !important;
  min-height: 100vh;
}
.login-logo, .login-logo img, .login-logo a {
  content: url('https://files.catbox.moe/kekkt1.jpg') !important;
  filter: drop-shadow(0 0 16px rgba(0,255,136,0.85)) !important;
  max-width: 220px;
}
.login-box .card, .login-card {
  background: rgba(0,0,0,0.55) !important;
  backdrop-filter: blur(18px);
  border: 1px solid var(--ehz-green) !important;
  box-shadow: 0 0 40px rgba(0,255,136,0.35) !important;
  border-radius: 16px !important;
}

::-webkit-scrollbar { width: 10px; height: 10px; }
::-webkit-scrollbar-track { background: #050505; }
::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, var(--ehz-green), var(--ehz-green-dark));
  border-radius: 8px;
  box-shadow: 0 0 8px rgba(0,255,136,0.6);
}

/* ==========================================================================
   HAPUS FOOTER DEFAULT PTERODACTYL
   ========================================================================== */
footer, .footer, .main-footer, .app-footer,
[class*="Footer"], #footer, #app-footer {
  display: none !important;
  visibility: hidden !important;
  height: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  border: none !important;
}

/* ==========================================================================
   TERMINAL STYLING (default Pterodactyl, restyle neon)
   ========================================================================== */
#terminal, .terminal, .console, .xterm,
[class*="Terminal"], [class*="Console"] {
  background: rgba(0,0,0,0.55) !important;
  backdrop-filter: blur(16px) saturate(160%);
  -webkit-backdrop-filter: blur(16px) saturate(160%);
  border: 1px solid rgba(0,255,136,0.35) !important;
  border-radius: 14px !important;
  box-shadow: 0 0 24px rgba(0,255,136,0.25), inset 0 0 40px rgba(0,255,136,0.05);
  font-family: var(--ehz-font-mono) !important;
  font-size: 13.5px !important;
  line-height: 1.6 !important;
  color: #e6ffe6 !important;
  padding: 14px !important;
}
.xterm-rows span, .xterm-viewport { background: transparent !important; }
.xterm .xterm-rows { color: #e6ffe6 !important; }
.xterm .xterm-cursor {
  background: #00ff88 !important;
  box-shadow: 0 0 8px #00ff88 !important;
}
.console-input, input[placeholder*="command"],
input[placeholder*="Command"], [class*="CommandInput"] {
  background: rgba(0,0,0,0.7) !important;
  border: 1px solid rgba(0,255,136,0.45) !important;
  border-radius: 10px !important;
  color: #00ff88 !important;
  font-family: var(--ehz-font-mono) !important;
  padding: 10px 14px !important;
  box-shadow: inset 0 0 12px rgba(0,255,136,0.15);
}
.console-input:focus, input[placeholder*="command"]:focus {
  border-color: #00ff88 !important;
  box-shadow: 0 0 0 3px rgba(0,255,136,0.2), inset 0 0 20px rgba(0,255,136,0.2) !important;
  outline: none !important;
}
[class*="PowerButton"], [class*="power-button"],
button[title*="Start"], button[title*="Restart"], button[title*="Stop"] {
  background: rgba(0,0,0,0.55) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0,255,136,0.4) !important;
  border-radius: 12px !important;
  color: #00ff88 !important;
  font-weight: 700 !important;
  padding: 10px 20px !important;
  transition: all .25s ease;
}
[class*="PowerButton"]:hover, button[title*="Start"]:hover {
  background: rgba(0,255,136,0.15) !important;
  box-shadow: 0 0 24px rgba(0,255,136,0.6) !important;
  transform: translateY(-2px);
}
[class*="StatBlock"], [class*="stat-block"] {
  background: rgba(0,0,0,0.5) !important;
  backdrop-filter: blur(14px);
  border: 1px solid rgba(0,255,136,0.25) !important;
  border-radius: 12px !important;
  color: #e6ffe6 !important;
  box-shadow: 0 0 16px rgba(0,255,136,0.15);
}
[class*="StatBlock"] svg { color: #00ff88 !important; filter: drop-shadow(0 0 6px rgba(0,255,136,0.7)); }

.xterm-viewport::-webkit-scrollbar { width: 8px; }
.xterm-viewport::-webkit-scrollbar-track { background: rgba(0,0,0,0.5); }
.xterm-viewport::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, #00ff88, #007a3d);
  border-radius: 6px;
  box-shadow: 0 0 8px rgba(0,255,136,0.6);
}

/* ==========================================================================
   ANIMASI PULSE
   ========================================================================== */
@keyframes ecohubzPulse {
  0%,100% { box-shadow: 0 0 12px rgba(0,255,136,0.35); }
  50%     { box-shadow: 0 0 28px rgba(0,255,136,0.85); }
}
.server-card, .card { animation: ecohubzPulse 3.5s ease-in-out infinite; }

@keyframes ecohubzTermPulse {
  0%,100% { box-shadow: 0 0 24px rgba(0,255,136,0.25), inset 0 0 40px rgba(0,255,136,0.05); }
  50%     { box-shadow: 0 0 40px rgba(0,255,136,0.5),  inset 0 0 60px rgba(0,255,136,0.1); }
}
#terminal, .terminal, .console { animation: ecohubzTermPulse 4s ease-in-out infinite; }

::selection { background: var(--ehz-green); color: #000; }
ECOHUBZ_CSS_EOF
  print_success "CSS selesai ($(wc -l < "$CSS_TARGET") baris)."
}

# ============================================================================
#   BAGIAN 9 — GENERATE NOTIF SLIDE (JS)
# ============================================================================

generate_notif_js() {
  print_step "Generate notif slide ECOHUBZ..."
  cat > "$NOTIF_JS" <<'ECOHUBZ_NOTIF_EOF'
/* ==========================================================================
   ECOHUBZ NOTIFICATION SLIDE v1.0.0
   Muncul otomatis saat user masuk panel
   Slide smooth dari atas, auto-close dengan animasi smooth
   Creator: @RamzOffcID (ʀᴀᴍᴢ) | Info: @ecohubzidinfo
   Support: https://ecohubzoffc.my.id
   ========================================================================== */

(function() {
  'use strict';

  const NOTIF_DURATION = 12000;
  const NOTIF_SLIDE_MS = 600;
  const SHOW_ONCE_PER_SESSION = false;

  if (SHOW_ONCE_PER_SESSION && sessionStorage.getItem('ecohubz_notif_shown')) {
    return;
  }
  sessionStorage.setItem('ecohubz_notif_shown', '1');

  const style = document.createElement('style');
  style.textContent = `
    #ecohubz-notif-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0, 0, 0, 0.65);
      backdrop-filter: blur(4px);
      -webkit-backdrop-filter: blur(4px);
      z-index: 999999;
      opacity: 0;
      transition: opacity ${NOTIF_SLIDE_MS}ms ease;
      display: flex;
      align-items: flex-start;
      justify-content: center;
      padding-top: 40px;
      pointer-events: none;
    }
    #ecohubz-notif-overlay.show {
      opacity: 1;
      pointer-events: auto;
    }

    #ecohubz-notif-card {
      background: linear-gradient(135deg, #050505 0%, #0a150a 100%);
      border: 1px solid #00ff88;
      border-radius: 18px;
      box-shadow:
        0 0 40px rgba(0, 255, 136, 0.5),
        0 20px 60px rgba(0, 0, 0, 0.8),
        inset 0 0 30px rgba(0, 255, 136, 0.05);
      max-width: 520px;
      width: calc(100% - 40px);
      padding: 24px 28px;
      color: #e6ffe6;
      font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
      transform: translateY(-120%);
      transition: transform ${NOTIF_SLIDE_MS}ms cubic-bezier(0.34, 1.56, 0.64, 1);
      position: relative;
      overflow: hidden;
    }
    #ecohubz-notif-overlay.show #ecohubz-notif-card {
      transform: translateY(0);
    }

    #ecohubz-notif-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, transparent, #00ff88, transparent);
      animation: ecohubzShimmer 2s linear infinite;
    }
    @keyframes ecohubzShimmer {
      0% { transform: translateX(-100%); }
      100% { transform: translateX(100%); }
    }

    .ecohubz-notif-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
      padding-bottom: 12px;
      border-bottom: 1px solid rgba(0, 255, 136, 0.25);
    }
    .ecohubz-notif-logo {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      border: 2px solid #00ff88;
      box-shadow: 0 0 16px rgba(0, 255, 136, 0.7);
      object-fit: cover;
      flex-shrink: 0;
    }
    .ecohubz-notif-title {
      font-size: 18px;
      font-weight: 700;
      color: #00ff88;
      text-shadow: 0 0 12px rgba(0, 255, 136, 0.6);
      letter-spacing: 0.5px;
      flex: 1;
    }
    .ecohubz-notif-close {
      background: rgba(0, 255, 136, 0.1);
      border: 1px solid rgba(0, 255, 136, 0.4);
      color: #00ff88;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      font-size: 18px;
      line-height: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
      font-weight: bold;
      padding: 0;
      flex-shrink: 0;
    }
    .ecohubz-notif-close:hover {
      background: #00ff88;
      color: #000;
      transform: rotate(90deg);
      box-shadow: 0 0 20px rgba(0, 255, 136, 0.9);
    }

    .ecohubz-notif-body {
      font-size: 14px;
      line-height: 1.7;
    }
    .ecohubz-notif-thanks {
      font-size: 15px;
      color: #00ff88;
      margin-bottom: 14px;
      font-weight: 600;
      text-shadow: 0 0 8px rgba(0, 255, 136, 0.4);
    }
    .ecohubz-notif-links {
      display: flex;
      flex-direction: column;
      gap: 8px;
      margin-bottom: 14px;
    }
    .ecohubz-notif-link {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 14px;
      background: rgba(0, 255, 136, 0.06);
      border: 1px solid rgba(0, 255, 136, 0.25);
      border-radius: 10px;
      color: #e6ffe6 !important;
      text-decoration: none;
      font-size: 13px;
      transition: all 0.2s ease;
    }
    .ecohubz-notif-link:hover {
      background: rgba(0, 255, 136, 0.15);
      border-color: #00ff88;
      transform: translateX(4px);
      box-shadow: 0 0 16px rgba(0, 255, 136, 0.4);
      color: #00ff88 !important;
    }
    .ecohubz-notif-link-icon {
      font-size: 18px;
      filter: drop-shadow(0 0 4px rgba(0, 255, 136, 0.8));
    }
    .ecohubz-notif-link-label {
      font-size: 11px;
      color: #8fbfa0;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .ecohubz-notif-link-value {
      color: #00ff88;
      font-weight: 600;
      font-size: 13px;
    }
    .ecohubz-notif-footer {
      text-align: center;
      font-size: 11px;
      color: #5a7a63;
      padding-top: 12px;
      border-top: 1px solid rgba(0, 255, 136, 0.15);
      margin-top: 8px;
    }

    @media (max-width: 480px) {
      #ecohubz-notif-card {
        padding: 20px;
        margin-top: 20px;
      }
      .ecohubz-notif-title { font-size: 16px; }
      .ecohubz-notif-body { font-size: 13px; }
      .ecohubz-notif-link-value { font-size: 12px; }
    }
  `;
  document.head.appendChild(style);

  function createNotif() {
    const overlay = document.createElement('div');
    overlay.id = 'ecohubz-notif-overlay';
    overlay.innerHTML = `
      <div id="ecohubz-notif-card">
        <div class="ecohubz-notif-header">
          <img class="ecohubz-notif-logo" src="https://files.catbox.moe/kekkt1.jpg" alt="EcoHubz">
          <div class="ecohubz-notif-title">ECOHUBZ THEME</div>
          <button class="ecohubz-notif-close" aria-label="Close">×</button>
        </div>
        <div class="ecohubz-notif-body">
          <div class="ecohubz-notif-thanks">
            ✨ By Ramz: Thanks For Install EcoHubz
          </div>
          <div class="ecohubz-notif-links">
            <a class="ecohubz-notif-link" href="https://saweria.co/widgets/qr?streamKey=34d6e4704f58c02ab43e27f1c116c941" target="_blank" rel="noopener">
              <span class="ecohubz-notif-link-icon">💰</span>
              <div>
                <div class="ecohubz-notif-link-label">Donation</div>
                <div class="ecohubz-notif-link-value">SAWERIA</div>
              </div>
            </a>
            <a class="ecohubz-notif-link" href="https://t.me/RamzOffcID" target="_blank" rel="noopener">
              <span class="ecohubz-notif-link-icon">✈️</span>
              <div>
                <div class="ecohubz-notif-link-label">Telegram</div>
                <div class="ecohubz-notif-link-value">RAMZ (@RamzOffcID)</div>
              </div>
            </a>
            <a class="ecohubz-notif-link" href="https://powershot.my.id" target="_blank" rel="noopener">
              <span class="ecohubz-notif-link-icon">🛠️</span>
              <div>
                <div class="ecohubz-notif-link-label">Eco Support</div>
                <div class="ecohubz-notif-link-value">SUPPORT (powershot.my.id)</div>
              </div>
            </a>
          </div>
          <div class="ecohubz-notif-footer">
            ECOHUBZ Theme v1.0.0
          </div>
        </div>
      </div>
    `;
    return overlay;
  }

  function showNotif() {
    const overlay = createNotif();
    document.body.appendChild(overlay);
    void overlay.offsetHeight;

    requestAnimationFrame(() => {
      overlay.classList.add('show');
    });

    const closeBtn = overlay.querySelector('.ecohubz-notif-close');
    let autoCloseTimer = null;

    function closeNotif() {
      if (autoCloseTimer) clearTimeout(autoCloseTimer);
      overlay.classList.remove('show');
      setTimeout(() => {
        if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
      }, NOTIF_SLIDE_MS + 50);
    }

    closeBtn.addEventListener('click', closeNotif);
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) closeNotif();
    });
    document.addEventListener('keydown', function escHandler(e) {
      if (e.key === 'Escape') {
        closeNotif();
        document.removeEventListener('keydown', escHandler);
      }
    });

    if (NOTIF_DURATION > 0) {
      autoCloseTimer = setTimeout(closeNotif, NOTIF_DURATION);
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      setTimeout(showNotif, 600);
    });
  } else {
    setTimeout(showNotif, 600);
  }
})();
ECOHUBZ_NOTIF_EOF
  print_success "Notif JS selesai ($(wc -l < "$NOTIF_JS") baris)."
}

# ============================================================================
#   BAGIAN 10 — INJECT KE BLADE
# ============================================================================

inject_blade() {
  print_step "Inject CSS & JS ke wrapper.blade.php..."
  if [ ! -f "$BLADE_FILE" ]; then
    print_error "wrapper.blade.php gak ada!"
    exit 1
  fi

  mkdir -p "$BACKUP_DIR"
  [ ! -f "$BACKUP_BLADE" ] && cp "$BLADE_FILE" "$BACKUP_BLADE" && print_success "Backup dibuat."

  sed -i '/ecohubz-theme\.css/d' "$BLADE_FILE" || true
  sed -i '/ecohubz-notif\.js/d' "$BLADE_FILE" || true

  if ! grep -q "ecohubz-theme.css" "$BLADE_FILE"; then
    sed -i "s|</head>|    <link rel=\"stylesheet\" href=\"/ecohubz-theme.css\">\n    <script src=\"/ecohubz-notif.js\" defer></script>\n</head>|" "$BLADE_FILE"
  fi

  if grep -q "ecohubz-theme.css" "$BLADE_FILE" && grep -q "ecohubz-notif.js" "$BLADE_FILE"; then
    print_success "CSS & JS berhasil di-inject."
  else
    print_error "Inject gagal. Cek $BLADE_FILE"
    exit 1
  fi
}

# ============================================================================
#   BAGIAN 11 — CLEAR CACHE & PERMISSION
# ============================================================================

clear_cache() {
  print_step "Clear cache panel..."
  cd "$PANEL_DIR"
  for cmd in optimize view config route cache; do
    php artisan $cmd:clear >/dev/null 2>&1 || true
  done
  print_success "Cache clear."
}

fix_perm() {
  chown -R www-data:www-data "$CSS_TARGET" "$NOTIF_JS" "$ASSET_DIR" 2>/dev/null || true
  chmod 644 "$CSS_TARGET" "$NOTIF_JS" 2>/dev/null || true
  print_success "Permission OK."
}

# ============================================================================
#   BAGIAN 12 — INSTALL / UNINSTALL / TOOLS
# ============================================================================

install_ecohubz() {
  print_banner "INSTALL ECOHUBZ THEME v${ECOHUBZ_VERSION}"
  check_panel

  echo -e "  ${BRIGHT_WHITE}Yang bakal diubah:${NC}"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Background panel → EcoHubz"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Logo burung → Logo EcoHubz"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Warna UI → Hijau Neon"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Server card → Transparan (glassmorphism)"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Terminal → Neon style (logic default)"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Login page → Modern neon"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Notif slide keren tiap masuk panel"
  echo -e "   ${BRIGHT_GREEN}✓${NC} Footer default dihapus"
  echo -e ""
  echo -n -e "  ${BOLD}Lanjut install? (y/n): ${NC}"
  read -r c
  [[ "$c" != [yY] ]] && { echo -e "  ${BRIGHT_YELLOW}Dibatalkan.${NC}"; return; }

  download_assets
  generate_css
  generate_notif_js
  inject_blade
  clear_cache
  fix_perm

  echo -e ""
  print_banner "INSTALL SELESAI ✅"
  echo -e "  ${BRIGHT_GREEN}ECOHUBZ v${ECOHUBZ_VERSION} aktif!${NC}"
  echo -e "  ${BRIGHT_WHITE}Refresh panel lo (Ctrl+Shift+R).${NC}"
  echo -e "  ${BRIGHT_WHITE}Support: ${BRIGHT_GREEN}${ECOHUBZ_SUPPORT}${NC}"
  echo -e ""
  sleep 3
}

uninstall_ecohubz() {
  print_banner "UNINSTALL ECOHUBZ THEME"
  check_panel

  echo -n -e "  ${BOLD}Yakin hapus theme ECOHUBZ? (y/n): ${NC}"
  read -r c
  [[ "$c" != [yY] ]] && { echo -e "  ${BRIGHT_YELLOW}Dibatalkan.${NC}"; return; }

  print_info "Hapus file theme..."
  rm -f "$CSS_TARGET" "$NOTIF_JS"
  rm -rf "$ASSET_DIR"

  print_info "Restore wrapper.blade.php..."
  if [ -f "$BACKUP_BLADE" ]; then
    cp "$BACKUP_BLADE" "$BLADE_FILE"
    print_success "Blade direstore dari backup."
  else
    sed -i '/ecohubz-theme\.css/d' "$BLADE_FILE" || true
    sed -i '/ecohubz-notif\.js/d' "$BLADE_FILE" || true
    print_success "Inject dihapus manual."
  fi

  clear_cache
  print_success "Panel balik default."
  sleep 2
}

reset_panel() {
  print_banner "RESET PANEL (FULL)"
  check_panel
  echo -n -e "  ${BOLD}Yakin reset panel ke vanilla? (y/n): ${NC}"
  read -r c
  [[ "$c" != [yY] ]] && return

  cd "$PANEL_DIR"
  php artisan down || true
  TMP=$(mktemp -d)
  [ -f ".env" ] && cp .env "$TMP/"

  print_info "Hapus file panel lama..."
  find . -mindepth 1 -delete

  print_info "Download panel original..."
  curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzf - -C "$PANEL_DIR"

  [ -f "$TMP/.env" ] && mv "$TMP/.env" . && rm -rf "$TMP"

  chmod -R 755 storage/* bootstrap/cache/
  print_info "Composer install..."
  if ! command -v composer >/dev/null 2>&1; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  fi
  export COMPOSER_ALLOW_SUPERUSER=1
  composer install --no-dev --optimize-autoloader --no-interaction

  php artisan migrate --seed --force
  clear_cache
  php artisan up
  chown -R www-data:www-data "$PANEL_DIR"
  print_banner "RESET SELESAI ✅"
  sleep 2
}

start_wings() {
  print_banner "CONFIGURE WINGS"
  read -p "  Token Auto-Deploy: " wings
  eval "$wings"
  systemctl start wings
  print_success "Wings jalan."
  sleep 2
}

create_node() {
  print_banner "CREATE NODE"
  bash <(curl -s https://cdn.jsdelivr.net/gh/Bangsano/themeinstaller@main/createnode.sh) || {
    print_error "Gagal create node."
    return 1
  }
  print_success "Node dibuat."
  sleep 2
}

hackback_panel() {
  print_banner "HACK BACK PANEL"
  read -p "  Username baru: " u
  read -sp "  Password baru: " p
  echo
  [ -z "$u" ] || [ -z "$p" ] && { print_error "Gak boleh kosong!"; return; }
  cd "$PANEL_DIR"
  printf 'yes\n%s@admin.com\n%s\n%s\n%s\n%s\n' "$u" "$u" "$u" "$u" "$p" | php artisan p:user:make
  print_success "Admin $u dibuat."
  sleep 2
}

ubahpw_vps() {
  print_banner "UBAH PASSWORD VPS"
  read -p "  Password baru: " a
  read -p "  Ulangi: " b
  [ "$a" != "$b" ] && { print_error "Gak cocok!"; return; }
  echo "$a:$a" | passwd root
  print_success "Password VPS diubah."
  sleep 2
}

# ============================================================================
#   BAGIAN 13 — MENU UTAMA
# ============================================================================

check_root
show_main_banner

print_loading "Memuat installer ECOHUBZ..." 2
check_internet
check_token

while true; do
  show_main_banner
  echo -e "${BRIGHT_GREEN}  ┌─────────────────────────────────────────────────────┐${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BOLD}${BRIGHT_WHITE}           ECOHUBZ MENU — v${ECOHUBZ_VERSION}              ${NC} ${BRIGHT_GREEN}│${NC}"
  echo -e "${BRIGHT_GREEN}  ├─────────────────────────────────────────────────────┤${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[1]${NC}  ${BRIGHT_WHITE}Install ECOHUBZ Theme${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[2]${NC}  ${BRIGHT_WHITE}Uninstall ECOHUBZ Theme${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[3]${NC}  ${BRIGHT_WHITE}Reset Panel ke Vanilla${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[4]${NC}  ${BRIGHT_WHITE}Start Wings${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[5]${NC}  ${BRIGHT_WHITE}Create Node & Location${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[6]${NC}  ${BRIGHT_WHITE}Hack Back Panel (buat admin baru)${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[7]${NC}  ${BRIGHT_WHITE}Ubah Password VPS${NC}"
  echo -e "${BRIGHT_GREEN}  │${NC}  ${BRIGHT_CYAN}[x]${NC}  ${BRIGHT_WHITE}Exit${NC}"
  echo -e "${BRIGHT_GREEN}  └─────────────────────────────────────────────────────┘${NC}"
  echo -e "    ${BRIGHT_GREEN}${ECOHUBZ_SUPPORT}${NC}"
  echo -e ""
  echo -n -e "  ${BOLD}${BRIGHT_WHITE}Pilih menu [1-7/x]: ${NC}"
  read -r CHOICE

  case "$CHOICE" in
    1) install_ecohubz ;;
    2) uninstall_ecohubz ;;
    3) reset_panel ;;
    4) start_wings ;;
    5) create_node ;;
    6) hackback_panel ;;
    7) ubahpw_vps ;;
    x|X)
      echo -e "  ${BRIGHT_GREEN}Bye bro! 👋${NC}"
      echo -e "  ${BRIGHT_WHITE}Support: ${BRIGHT_GREEN}${ECOHUBZ_SUPPORT}${NC}"
      exit 0
      ;;
    *) print_error "Pilihan gak valid."; sleep 1 ;;
  esac

  echo ""
  echo -n -e "  ${BRIGHT_WHITE}Tekan ENTER balik ke menu...${NC}"
  read -r _
done
