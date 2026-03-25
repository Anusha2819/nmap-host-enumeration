# nmap-host-enumeration
Network scanning &amp; host enumeration using Nmap on scanme.nmap.org
# 🗺️ Network Scanning & Host Enumeration with Nmap

**Author:** Perikala Anusha  
**Portfolio:** [anusha-cybersecurity-portfolio.vercel.app](https://anusha-cybersecurity-portfolio.vercel.app)  
**GitHub:** [github.com/Anusha2819](https://github.com/Anusha2819)  
**LinkedIn:** [linkedin.com/in/perikala-anusha-76b214316](https://linkedin.com/in/perikala-anusha-76b214316)  
**Date:** March 2026  
**Target:** `scanme.nmap.org` (45.33.32.156) — Nmap's official legal practice server  
**Tool:** Nmap 7.94SVN on Kali Linux (WSL2)

---

## 📌 Project Overview

This project demonstrates a complete **network reconnaissance and host enumeration workflow** using Nmap — the industry-standard tool used by penetration testers and security analysts worldwide.

All scans were performed on **scanme.nmap.org** — Nmap's own publicly authorised test server, explicitly provided for legal scanning practice.

> ⚠️ **Ethics Note:** All scans in this project were performed only on `scanme.nmap.org`, a server explicitly provided by the Nmap project for legal scanning practice. Never scan systems without written authorisation.

---

## 🎯 Objectives

- Perform host discovery to confirm target availability
- Enumerate open ports using multiple scan techniques
- Identify running services and their version numbers
- Detect the target's operating system
- Run NSE (Nmap Scripting Engine) scripts for deeper enumeration
- Conduct a full aggressive scan and document findings professionally

---

## 🛠️ Tools & Environment

| Component | Details |
|-----------|---------|
| Tool | Nmap 7.94SVN |
| OS | Kali Linux (WSL2) |
| Target | scanme.nmap.org (45.33.32.156) |
| Target IPv6 | 2600:3c01::f03c:91ff:fe18:bb2f |
| Network Distance | 25 hops |

---

## 📋 Scan 1 — Host Discovery (Ping Sweep)

**Command:**
```bash
sudo nmap -sn scanme.nmap.org -oN scans/ping_sweep.txt
```

**Result:**
```
Host is up (0.24s latency)
IP: 45.33.32.156
IPv6: 2600:3c01::f03c:91ff:fe18:bb2f
Scan time: 1.23 seconds
```

**Analysis:**
- ✅ Target is **online and reachable**
- Round-trip latency of **0.24s** — consistent with international server (~25 hops away)
- `-sn` flag performs ping sweep only — no port scanning, stealthy recon

---

## 📋 Scan 2 — TCP SYN Scan (Stealth Scan)

**Command:**
```bash
sudo nmap -sS scanme.nmap.org -oN scans/syn_scan.txt
```

**Result:**

| Port | State | Service |
|------|-------|---------|
| 22/tcp | **open** | SSH |
| 80/tcp | **open** | HTTP |
| 9929/tcp | **open** | nping-echo |
| 31337/tcp | **open** | Elite |
| 25/tcp | filtered | SMTP |
| 135/tcp | filtered | MSRPC |
| 139/tcp | filtered | NetBIOS-SSN |
| 179/tcp | filtered | BGP |
| 445/tcp | filtered | Microsoft-DS |
| 646/tcp | filtered | LDP |

**Analysis:**
- **4 open ports** discovered: 22, 80, 9929, 31337
- **6 filtered ports** — blocked by a firewall
- Port **31337** is historically associated with "Elite" — a well-known hacker culture port number, used here intentionally by Nmap for testing
- SYN scan sends SYN packets only — never completes TCP handshake — making it stealthier than a full connect scan

---

## 📋 Scan 3 — Service & Version Detection

**Command:**
```bash
sudo nmap -sV scanme.nmap.org -oN scans/version_detection.txt
```

**Result:**

| Port | Service | Version |
|------|---------|---------|
| 22/tcp | SSH | **OpenSSH 6.6.1p1** Ubuntu 2ubuntu2.13 |
| 80/tcp | HTTP | **Apache httpd 2.4.7** (Ubuntu) |
| 9929/tcp | nping-echo | Nping echo |
| 31337/tcp | tcpwrapped | — |

**Analysis:**
- **OpenSSH 6.6.1p1** — an older version (released ~2014). In a real pentest this would be flagged for potential vulnerabilities
- **Apache 2.4.7** — also older version (released ~2013). Would be checked against CVE database in a real assessment
- `tcpwrapped` on port 31337 means the service completed TCP handshake but refused further communication — often a security measure
- OS confirmed as **Linux** by service banners

---

## 📋 Scan 4 — OS Detection

**Command:**
```bash
sudo nmap -O scanme.nmap.org -oN scans/os_detection.txt
```

**Result:**
```
Aggressive OS guesses:
  Linux 2.6.32        — 92% confidence
  Linux 4.4           — 92% confidence
  Linux 2.6.32 or 3.10 — 92% confidence
  Linux 5.0 - 5.4     — 89% confidence

Network Distance: 25 hops
Note: No exact match — test conditions non-ideal
```

**Analysis:**
- Target is definitively **Linux-based** (confirmed by multiple indicators)
- High confidence (89–92%) across multiple Linux kernel versions
- "Non-ideal conditions" is normal for remote scans — OS fingerprinting works best on LAN
- 25 hops distance (India → USA) adds latency and affects fingerprint accuracy

---

## 📋 Scan 5 — NSE Default Scripts

**Command:**
```bash
sudo nmap -sC scanme.nmap.org -oN scans/nse_scripts.txt
```

**Result:**

```
PORT      STATE     SERVICE
22/tcp    open      ssh
| ssh-hostkey:
|   1024 ac:00:a0:1a:82:ff:cc:55:99:dc:67:2b:34:97:6b:75 (DSA)
|   2048 20:3d:2d:44:62:2a:b0:5a:9d:b5:b3:05:14:c2:a6:b2 (RSA)
|   256 96:02:bb:5e:57:54:1c:4e:45:2f:56:4c:4a:24:b2:57 (ECDSA)
|_  256 33:fa:91:0f:e0:e1:7b:1f:6d:05:a2:b0:f1:54:41:56 (ED25519)

80/tcp    open      http
|_http-title: Go ahead and ScanMe!
|_http-favicon: Nmap Project
```

**Analysis:**
- **SSH host keys exposed** — DSA (1024-bit), RSA (2048-bit), ECDSA (256-bit), ED25519 (256-bit)
  - DSA 1024-bit is considered **weak by modern standards** — would be flagged in a real pentest
  - ED25519 is the most modern and secure key type present
- **HTTP title** confirms this is Nmap's intentional test server: *"Go ahead and ScanMe!"*
- NSE scripts automate intelligence gathering that would otherwise require manual tools

---

## 📋 Scan 6 — Full Aggressive Scan

**Command:**
```bash
sudo nmap -A -p- --open scanme.nmap.org -oN scans/full_enumeration.txt
```

**Result Summary:**

| Port | Service | Version | Notes |
|------|---------|---------|-------|
| 22/tcp | SSH | OpenSSH 6.6.1p1 Ubuntu | 4 host keys enumerated |
| 80/tcp | HTTP | Apache 2.4.7 (Ubuntu) | Title: "Go ahead and ScanMe!" |
| 9929/tcp | nping-echo | Nping echo | Nmap test service |
| 31337/tcp | tcpwrapped | — | Connection refused after handshake |

**Traceroute (India → USA, 25 hops):**
```
HOP 1   — 172.30.176.1      (PRINCY-LAPTOP local WSL gateway)
HOP 2   — 192.168.29.1      (Reliance home router)
HOP 3   — 10.0.88.1         (ISP internal)
HOP 4   — 172.31.2.120      (ISP backbone)
HOP 11  — 103.198.140.64    (Indian ISP backbone)
HOP 12  — 49.45.4.103       (International link)
HOP 25  — 45.33.32.156      (scanme.nmap.org — USA)
```

**Analysis:**
- **Full port scan** (-p-) checked all **65,535 ports** — only 4 were open
- Traceroute reveals complete network path from Guntur, India to Nmap's server in USA
- Scan duration: **111.53 seconds** — expected for a full port scan over international connection
- `-A` flag combines OS detection + version detection + scripts + traceroute in one pass

---

## 📊 Final Findings Summary

| Finding | Detail | Severity (if real pentest) |
|---------|--------|---------------------------|
| OpenSSH 6.6.1p1 | Very old version (2014) | 🟡 Medium |
| Apache 2.4.7 | Old version (2013) | 🟡 Medium |
| DSA 1024-bit SSH key | Weak key size | 🟡 Medium |
| Port 31337 open | Unusual port — investigate | 🔵 Informational |
| SMTP port 25 filtered | Firewall present | ✅ Good |
| SMB port 445 filtered | EternalBlue mitigated | ✅ Good |
| 4 open ports only | Small attack surface | ✅ Good |

---

## 💡 Key Learnings

1. **Reconnaissance is the foundation** of any penetration test — you must know what's running before you can assess vulnerabilities
2. **Service versions matter** — old versions like OpenSSH 6.6.1p1 and Apache 2.4.7 have known CVEs that would be exploitable in a real assessment
3. **filtered ≠ closed** — filtered ports are blocked by a firewall; closed ports have no service listening
4. **NSE scripts** dramatically increase intelligence gathering speed — automating what would take hours manually
5. **Traceroute** reveals network topology — useful for understanding attack paths in a real engagement
6. **Documentation is critical** — every scan saved with `-oN` for professional reporting

---
## ⚡ Key Commands Used

- Host Discovery:
  nmap -sn scanme.nmap.org

- SYN Scan:
  nmap -sS scanme.nmap.org

- Version Detection:
  nmap -sV scanme.nmap.org

- OS Detection:
  nmap -O scanme.nmap.org

- Full Scan:
  nmap -A -p- scanme.nmap.org
## 📁 Repository Structure

```
nmap-host-enumeration/
├── README.md                    ← This file
├── run_all_scans.sh             ← Automated scan script
├── scans/
│   ├── ping_sweep.txt           ← Scan 1 output
│   ├── syn_scan.txt             ← Scan 2 output
│   ├── version_detection.txt    ← Scan 3 output
│   ├── os_detection.txt         ← Scan 4 output
│   ├── nse_scripts.txt          ← Scan 5 output
│   └── full_enumeration.txt     ← Scan 6 output
└── screenshots/
    └── (terminal screenshots)
```

---

## ⚖️ Legal & Ethical Disclaimer

All scans performed exclusively on `scanme.nmap.org` — a server **explicitly provided by the Nmap project** for legal scanning practice. No unauthorised systems were scanned. This project is for **educational and portfolio purposes only**.

> "You are authorised to scan this machine with Nmap or other port scanners." — nmap.org

---

*Part of Perikala Anusha's Cybersecurity Portfolio — [anusha-cybersecurity-portfolio.vercel.app](https://anusha-cybersecurity-portfolio.vercel.app)*
