# 🏆 Pageant Tabulation System
A secure, real-time pageant scoring system with encrypted communication and reliable performance.

### **Features**

✅ **Weighted Scoring** – Scores for each category  
✅ **Normalized Scores** – Standardized to 100  
✅ **Real-Time Updates** – Live scores and rankings  
✅ **PDF Reports** – Generate instantly  
✅ **Encrypted Communication** – Secure and private

**Developed by:** Mark Tagab

A comprehensive tabulation system for pageant contests with server-client architecture.

---

## 📁 Directory Structure

### Server Components
- **`pageant-server`** — Linux binary; main server application
- **`pageant.xml`** — Contest configuration (rules, judges, users, categories)
- **`nats-server`** — Required NATS messaging server
  > ℹ️ Automatically started by `pageant-server` if in the same directory

### Client Components
- **`client.exe`** — Native Windows dashboard application
- **`config.xml`** — Client configuration (server connection details)

## ⚙️ Configuration

### Automatic Password Hashing

Passwords are securely stored as **Argon2 hashes** with no manual hashing required.

**Before Starting the Server:**

#### 1. Open `pageant.xml` in a text editor
#### 2. Enter plain text passwords in `<PasswordHash>` fields:
   ```xml
   <Judge id="1">
       <Username>judge1</Username>
       <PasswordHash>mySecretPassword123</PasswordHash>
   </Judge>
   <Tabulator>
       <Username>admin</Username>
       <PasswordHash>adminPass</PasswordHash>
   </Tabulator>
   ```
#### 3. Start `pageant-server`

**After Server Startup:**

The server automatically detects plain text passwords, hashes them using Argon2, and **rewrites the `pageant.xml` file**. Your file will now contain secure hashes:

```xml
<Judge id="1">
    <Username>judge1</Username>
    <PasswordHash>$argon2id$v=19$m=19456,t=2,p=1$...</PasswordHash>
</Judge>
<Tabulator>
    <Username>admin</Username>
    <PasswordHash>$argon2id$v=19$m=19456,t=2,p=1$...</PasswordHash>
</Tabulator>
```

### Category & Criteria Setup

When adding categories to `pageant.xml`, follow these weight requirements:

| Rule | Requirement |
|------|-------------|
| **Category Weights** | All `<Category>` weights must sum to `1.0` (100%) |
| **Criterion Weights** | All `<Criterion>` weights within a category must sum to `1.0` (100%) |

**Example:**
```xml
<Category name="Swimsuit" order="1" weight="1.0">
    <Criterion name="Poise" weight="0.4" />
    <Criterion name="Physical Fitness" weight="0.6" />
</Category>
```

## 🚀 Getting Started

### Step 1: Start the Server (Linux - Raspberry Pi 5 Recommended)

The `pageant-server` binary is compiled for **ARM64 architecture**, making it ideal for Raspberry Pi 5 and other ARM-based Linux systems.

```bash
chmod +x nats-server
chmod +x pageant-server
./pageant-server
```

To check for server IP
```bash
hostname -I | awk '{print $1}'
```

> 💡 **Why Raspberry Pi 5?** It provides native ARM64 support without emulation overhead, ensuring optimal performance for the tabulation service.

### Step 2: Deploy with Docker (Optional)
For cross-platform deployment without native compilation on non-ARM64 systems:

**Required files:**
- `pageant.xml` — Contest configuration
- `result.xml` — Results file (can be empty)

**Windows CMD**
```bash
docker run -d --name pageant_server -p 4222:4222 -v "%cd%\pageant.xml:/app/pageant.xml" -v "%cd%\result.xml:/app/result.xml" mtagab/pageant_server:latest
```

| Flag | Purpose |
|------|---------|
| `-d` | Run in detached (background) mode |
| `--name` | Assign container name for easy management |
| `-p 4222:4222` | Expose NATS messaging port |
| `-v` | Mount configuration and results files |

**Docker Management:**
```bash
# View logs
docker logs -f pageant_server

# Stop server
docker stop pageant_server
```

> ℹ️ **Performance Note:** For best performance, run Docker on ARM64 hosts (like Raspberry Pi 5). On non-ARM64 systems, Docker uses QEMU emulation, which may impact performance.

### Step 3: Access the Server
- **Local access:** `localhost:4222`
- **LAN access:** `<host_IP>:4222`
  - Windows: Use `ipconfig` to find IP
  - Linux: Use `ifconfig` or `ip addr` to find IP

### Step 4: Configure the Client
Edit `config.xml` with your server's IP address:
```xml
<Config>
    <ServerIP>192.168.1.100</ServerIP>
</Config>
```

### Step 5: Launch the Client
**Windows:**
Double-click `client.exe`

### Step 6: Generate Final Results
When the Tabulator requests final rankings, the server automatically generates:
- **`result.xml`** — Raw score data
- **`pageant_results.pdf`** — Formatted printable report

---

## 📋 Quick Reference

| Component | File | Platform | Purpose |
|-----------|------|----------|---------|
| Server | `pageant-server` | Linux | Tabulation & scoring service |
| Config | `pageant.xml` | Any | Contest rules, judges & users |
| Messaging | `nats-server` | Any | Event messaging broker |
| Client | `client.exe` | Windows | Judge scoring & tabulator control |
| Results | `result.xml` | Any | Final scoring data |
| Report | `pageant_results.pdf` | Any | Formatted competition results |
