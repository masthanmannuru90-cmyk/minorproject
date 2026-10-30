# SecureGuard AI — AI-Based Secure Malware Analysis & Threat Platform

An enterprise-inspired, full-stack cybersecurity platform built for the college minor project: **"AI-Based Secure Malware Analysis and Threat Platform"**.

SecureGuard AI provides defense-in-depth, zero-execution static inspection of untrusted files, combining:
1. **Scikit-Learn Machine Learning Classifier**: Evaluates 25 structural static features, Shannon byte entropy, and API import frequencies.
2. **YARA Pattern Matching Engine**: Scans for ransomware volume shadow deletions, web shell commands, PowerShell stagers, and suspicious binaries.
3. **ClamAV Antivirus Daemon Integration**: Seamlessly interfaces with local ClamAV daemons or CLI executables, providing explicit status tracking.
4. **VirusTotal Threat Intelligence**: Optional server-side cloud hash reputation queries.
5. **Cryptographic Quarantine Isolation**: Scrambles and isolates detected malicious payloads to prevent accidental endpoint execution.
6. **Verifiable Audit PDF Reports**: Generates tamper-evident forensic PDF audit documents.

---

## 1. System Architecture

```
                                  +---------------------------------------+
                                  |     React.js Frontend (Vite)          |
                                  |  Dark Navy Cyber Dashboard (Port 5173)|
                                  +-------------------+-------------------+
                                                      |
                                           REST API   |  JWT Bearer Auth
                                                      v
                                  +---------------------------------------+
                                  |       Flask REST API (Port 5000)      |
                                  +-------------------+-------------------+
                                                      |
                    +---------------------------------+---------------------------------+
                    |                                 |                                 |
                    v                                 v                                 v
        +-----------------------+         +-----------------------+         +-----------------------+
        |   Scikit-Learn ML     |         |   YARA Pattern Rules  |         |   ClamAV Antivirus    |
        |  Static Classifier    |         |  malware_rules.yar    |         |  TCP Socket / CLI     |
        | (25 Structural Traits)|         | (WebShell, EICAR, PS) |         | (Explicit Status)     |
        +-----------------------+         +-----------------------+         +-----------------------+
                    |                                 |                                 |
                    +---------------------------------+---------------------------------+
                                                      |
                                                      v
                                  +---------------------------------------+
                                  |     Decision & Policy Synthesizer     |
                                  |  - Threat Detected -> Quarantine (.qrn)|
                                  |  - Clean -> Approved Storage / Verify |
                                  |  - Incomplete -> Non-Safe Warning     |
                                  +-------------------+-------------------+
                                                      |
                                                      v
                                  +---------------------------------------+
                                  |     SQLite3 Database & ReportLab      |
                                  |  - Users & ScanReports Tables         |
                                  |  - Official Forensic PDF Generation   |
                                  +---------------------------------------+
```

---

## 2. Technology Stack

- **Frontend**: React 18, Vite, Lucide Icons, Pure CSS3 Cyber Grid Design
- **Backend**: Python 3.10+, Flask 3.1, Flask-CORS, Werkzeug (PBKDF2/Scrypt hash)
- **Machine Learning**: Scikit-Learn 1.6+, NumPy, SciPy, Joblib
- **Heuristics & Signatures**: YARA Pattern Rules (`rules/malware_rules.yar`), Native Rule Engine
- **Antivirus Service**: ClamAV (TCP Socket `127.0.0.1:3310` or CLI `clamscan`)
- **Intelligence**: VirusTotal v3 Hash Reputation API (Optional, server-side env)
- **Reporting**: ReportLab PDF Document Engine
- **Database**: SQLite3 Relational Database with Indexed Queries & Foreign Keys

---

## 3. Directory Layout

```
secureguard-ai/
├── backend/
│   ├── app.py                     # Flask application entry point
│   ├── config.py                  # System configuration & environment paths
│   ├── database.py                # SQLite connection manager & schema init
│   ├── auth.py                    # Scrypt password hashing & JWT token handling
│   ├── seed_demo.py               # Database seeder for demo presentation
│   ├── requirements.txt           # Python dependency specifications
│   ├── .env.example               # Environment variable reference
│   ├── scanner/
│   │   ├── engine.py              # Central multi-engine malware orchestrator
│   │   ├── yara_scanner.py        # YARA rule parser and matching engine
│   │   ├── ml_classifier.py       # Scikit-Learn Random Forest threat classifier
│   │   ├── clamav_scanner.py      # ClamAV daemon socket & CLI connector
│   │   ├── virustotal_scanner.py  # VirusTotal hash reputation client
│   │   └── quarantine.py          # Isolated scrambled storage manager
│   ├── rules/
│   │   └── malware_rules.yar      # Enterprise YARA rule signatures
│   ├── reports/
│   │   └── pdf_report.py          # ReportLab PDF security report generator
│   ├── routes/
│   │   ├── auth_routes.py         # User registration, login, profile routes
│   │   ├── scan_routes.py         # Multipart file scan & history endpoints
│   │   ├── report_routes.py       # Report inspection & PDF download routes
│   │   ├── dashboard_routes.py    # Metric aggregation & chart analytics
│   │   └── threat_intel_routes.py # Indicators of compromise (IOCs) feed
│   └── tests/
│       └── test_backend.py        # Automated test suite (10/10 scenarios)
│
├── frontend/
│   ├── index.html                 # HTML5 document root
│   ├── vite.config.js             # Vite configuration with API proxy
│   ├── package.json               # Frontend dependencies (React, Lucide)
│   └── src/
│       ├── main.jsx               # React DOM entry point
│       ├── App.jsx                # Router & main application container
│       ├── index.css              # Dark navy-blue cyber design system
│       ├── api.js                 # Unified REST client with JWT interceptor
│       ├── context/
│       │   └── AuthContext.jsx    # React authentication context provider
│       ├── components/
│       │   ├── Navbar.jsx         # Responsive top navigation header
│       │   ├── Footer.jsx         # Enterprise platform footer
│       │   ├── ThreatResultCard.jsx    # Red warning card for threats
│       │   ├── SafeResultCard.jsx      # Green verification card for safe files
│       │   └── IncompleteResultCard.jsx# Warning card for incomplete/suspicious
│       └── pages/
│           ├── Home.jsx           # Landing page with live metric counters
│           ├── Dashboard.jsx      # Analytics charts & severity distribution
│           ├── ScanFile.jsx       # Dedicated drag-and-drop file scanner
│           ├── ScanHistory.jsx    # Filterable & searchable audit history
│           ├── ThreatIntelligence.jsx # Threat IOCs & detection rules
│           ├── SecurityReports.jsx# Forensic reports & PDF downloader
│           ├── AboutUs.jsx        # Project objectives & tech stack documentation
│           ├── Login.jsx          # User authentication page
│           └── Register.jsx       # User registration page
└── README.md                      # Complete setup & demonstration guide
```

---

## 4. Installation & Setup

### Prerequisites
- **Python**: Version 3.10, 3.11, 3.12, 3.13, or 3.14.
- **Node.js**: Version 18+ and `npm`.

### Step 1: Install Backend Dependencies
Open a terminal in `backend/`:
```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Configure Environment Variables
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```
Key variables:
- `SECRET_KEY`: Random 32+ character string.
- `JWT_SECRET_KEY`: Cryptographic signing key.
- `VIRUSTOTAL_API_KEY`: *(Optional)* Your free VirusTotal API key. If empty, local scanning engines run without external dependencies.
- `CLAMAV_REQUIRED`: `false` by default. When set to `true`, scans will mark files as `SCAN INCOMPLETE` if ClamAV daemon is offline.

### Step 3: Seed Demo Account (Optional)
```bash
python seed_demo.py
```
Preconfigured demonstration account:
- **Email**: `analyst@secureguard.ai`
- **Password**: `AnalystPass123!`

### Step 4: Install Frontend Dependencies & Build
Open a terminal in `frontend/`:
```bash
cd ../frontend
npm install
npm run build
```

---

## 5. Running the Application

### Start the Flask Backend
In terminal 1:
```bash
cd backend
python app.py
```
*API server will listen on `http://127.0.0.1:5000`.*

### Start the React Frontend
In terminal 2:
```bash
cd frontend
npm run dev
```
*Vite dev server will launch at `http://localhost:5173`.*

Open your browser and navigate to **`http://localhost:5173`**.

---

## 6. ClamAV Installation & Configuration

SecureGuard AI checks for ClamAV via TCP socket (`127.0.0.1:3310`) or local `clamscan` CLI binary. If ClamAV is not installed, the platform explicitly marks ClamAV status as **`UNAVAILABLE`** in scan reports rather than faking results.

### To Enable ClamAV on Windows:
1. Download the ClamAV Windows installer from [clamav.net/downloads](https://www.clamav.net/downloads) or use Chocolatey:
   ```powershell
   choco install clamav
   ```
2. Update signature databases:
   ```powershell
   freshclam
   ```
3. Start the ClamAV daemon:
   ```powershell
   clamd
   ```
4. Verify port `3310` is active. SecureGuard AI will automatically detect the running daemon and stream scan requests over socket.

---

## 7. Testing & Verification

### Running Automated Test Suite
The backend includes 10 comprehensive unit & integration tests covering all prompt requirements:
```bash
cd backend
pytest tests/test_backend.py -v
```

Tests verify:
1. `test_user_registration_and_login`: Valid user registration and JWT token issue.
2. `test_unauthenticated_upload_rejected`: Unauthenticated users cannot scan files.
3. `test_invalid_file_type_rejected`: Disallowed extensions are rejected.
4. `test_oversized_file_rejected`: Uploads exceeding 16 MB limit are rejected.
5. `test_malicious_eicar_file_rejected`: The standard EICAR test file is identified, rejected, and quarantined.
6. `test_safe_file_verification`: Clean files pass checks and receive `SEC-VERIFY-` token.
7. `test_incomplete_scan_not_safe`: Strict policy never marks incomplete scans as clean.
8. `test_user_report_isolation`: One user cannot view another user's scan reports.
9. `test_scan_history_saved`: Scans are recorded in SQLite with full metadata.
10. `test_pdf_report_generation`: Valid PDF audit documents are dynamically generated.

### Manual Live Demonstration Steps
1. Navigate to `http://localhost:5173/` and click **"Start Security Scan"**.
2. Sign in using `analyst@secureguard.ai` / `AnalystPass123!` or create a new user.
3. **Test Benign File**: Upload any clean `.txt` or `.docx` file. Observe:
   - Green **"NO THREATS DETECTED"** card appears.
   - Unique Verification ID generated (`SEC-VERIFY-XXXXXX`).
   - File marked as approved for storage.
4. **Test Malware Detection**: Click the homepage button **"Download EICAR Test Sample"** (or upload `eicar_test_sample.com`). Observe:
   - Red **"THREAT DETECTED — UPLOAD REJECTED"** warning card appears.
   - Threat signature identified: `EICAR_Standard_Test_File`.
   - File is immediately isolated and scrambled in `backend/quarantine/`.
5. **Download PDF Report**: Click **"Download Audit PDF"** to receive an official security audit report formatted with hashes, engine statuses, and remediation steps.
6. **Inspect Dashboard**: View real-time database counts, threat distribution bars, and activity charts.
7. **Threat Intelligence Feed**: View locally detected IOCs and active platform signatures.

---

## 8. Security Disclaimers

- **Zero-Execution Architecture**: Files uploaded to SecureGuard AI are inspected as passive byte streams. Payloads are never executed on the operating system.
- **Audit Verification IDs**: The verification token identifies the specific scan record in the database; it is not a warranty against zero-day vulnerabilities.
- **Privacy First**: If VirusTotal is enabled, only file SHA-256 hashes are queried by default to protect confidentiality.
