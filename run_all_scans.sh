#!/bin/bash
# ============================================================
# Network Scanning & Host Enumeration with Nmap
# Author   : Perikala Anusha
# GitHub   : https://github.com/Anusha2819
# Portfolio: https://anusha-cybersecurity-portfolio.vercel.app
# Date     : March 2026
# Target   : scanme.nmap.org (legal practice server)
# ============================================================

TARGET="scanme.nmap.org"
OUTPUT_DIR="./scans"

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║   NMAP ENUMERATION PROJECT — PERIKALA ANUSHA         ║"
echo "║   Target: $TARGET                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"
mkdir -p "./screenshots"

# ── SCAN 1: HOST DISCOVERY ────────────────────────────────────
echo "[1/6] 🔍 Running Host Discovery (Ping Sweep)..."
sudo nmap -sn "$TARGET" -oN "$OUTPUT_DIR/ping_sweep.txt"
echo "      ✅ Saved to $OUTPUT_DIR/ping_sweep.txt"
echo ""

# ── SCAN 2: TCP SYN SCAN ──────────────────────────────────────
echo "[2/6] 🔍 Running TCP SYN Stealth Scan..."
sudo nmap -sS "$TARGET" -oN "$OUTPUT_DIR/syn_scan.txt"
echo "      ✅ Saved to $OUTPUT_DIR/syn_scan.txt"
echo ""

# ── SCAN 3: SERVICE VERSION DETECTION ────────────────────────
echo "[3/6] 🔍 Running Service & Version Detection..."
sudo nmap -sV "$TARGET" -oN "$OUTPUT_DIR/version_detection.txt"
echo "      ✅ Saved to $OUTPUT_DIR/version_detection.txt"
echo ""

# ── SCAN 4: OS DETECTION ──────────────────────────────────────
echo "[4/6] 🔍 Running OS Detection..."
sudo nmap -O "$TARGET" -oN "$OUTPUT_DIR/os_detection.txt"
echo "      ✅ Saved to $OUTPUT_DIR/os_detection.txt"
echo ""

# ── SCAN 5: NSE DEFAULT SCRIPTS ──────────────────────────────
echo "[5/6] 🔍 Running NSE Default Scripts..."
sudo nmap -sC "$TARGET" -oN "$OUTPUT_DIR/nse_scripts.txt"
echo "      ✅ Saved to $OUTPUT_DIR/nse_scripts.txt"
echo ""

# ── SCAN 6: FULL AGGRESSIVE SCAN ──────────────────────────────
echo "[6/6] 🔍 Running Full Aggressive Scan (all ports)..."
echo "      ⏳ This may take 2-3 minutes..."
sudo nmap -A -p- --open "$TARGET" -oN "$OUTPUT_DIR/full_enumeration.txt"
echo "      ✅ Saved to $OUTPUT_DIR/full_enumeration.txt"
echo ""

echo "╔══════════════════════════════════════════════════════╗"
echo "║   ✅ ALL SCANS COMPLETE!                             ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "📁 Scan results saved in: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"
echo ""
echo "📌 Portfolio: https://anusha-cybersecurity-portfolio.vercel.app"
echo "📌 GitHub   : https://github.com/Anusha2819"
