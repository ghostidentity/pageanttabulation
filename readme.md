# Pageant Tabulation System
**Developed by:** Mark Tagab

This directory contains the executables and configuration files for the Pageant Tabulation System.

## Files

*   **Server**
    *   `pageant-server` (Linux binary): The main server application.
    *   `pageant.xml`: Configuration file for the contest, judges, and system users.
    *   `nats-server` (Required): The NATS server binary. **Note:** The `pageant-server` will automatically try to start this if it's in the same directory. You do not need to run it manually.

*   **Client**
    *   `client.exe` (Windows binary): Native Windows executable for the dashboard.
    *   `config.xml`: Configuration file for the client (server connection details).

## Configuration (`pageant.xml`)

The `pageant.xml` file defines the contest rules, categories, contestants, and users (judges and tabulators).

### Auto-Hashing Passwords

For security, passwords are stored as Argon2 hashes. However, you do **not** need to manually generate these hashes. This applies to both **Judges** and the **Tabulator**.

1.  Open `pageant.xml` in a text editor.
2.  Enter the **plain text** password in the `<PasswordHash>` field for any user (Judge or Tabulator).
    ```xml
    <Judge id="1">
        <Username>judge1</Username>
        <PasswordHash>mySecretPassword123</PasswordHash>
    </Judge>
    <!-- Same for Tabulator -->
    <Tabulator>
        <Username>admin</Username>
        <PasswordHash>adminPass</PasswordHash>
    </Tabulator>
    ```
3.  Start the `pageant-server`.
4.  The server will detect the plain text password, automatically hash it using Argon2, and **rewrite the `pageant.xml` file** with the secure hash.
    ```xml
    <!-- After server start -->
    <Judge id="1">
        <Username>judge1</Username>
        <PasswordHash>$argon2id$v=19$m=19456,t=2,p=1$...</PasswordHash>
    </Judge>
    ```

### Defining Categories and Criteria

When adding a new `<Category>` in `pageant.xml`, please follow these rules:

1.  **Category Weights must sum to 1.0 (100%)**: The sum of **all** `<Category>` weights in the contest must equal exactly `1.0`.
2.  **Criterion Weights must sum to 1.0 (100%)**: The sum of all `<Criterion>` weights inside a **single** category must equal exactly `1.0`.
    *   Example: 40% = `0.4`, 60% = `0.6`.
3.  **Format**:
    ```xml
    <Category name="Swimsuit" order="1" weight="1.0">
        <Criterion name="Poise" weight="0.4" />
        <Criterion name="Physical Fitness" weight="0.6" />
    </Category>
    ```

## Running the System

### 1. Start the Server (Linux)
Ensure the server is running on the host machine (e.g., Raspberry Pi).
```bash
./pageant-server
```

### 2. Configure the Client
Edit `config.xml` to point to your NATS server address (usually the IP of the server).
```xml
<Config>
    <ServerIP>192.168.1.100</ServerIP>
</Config>
```

### 3. Run the Client
**Windows:**
Double-click `client.exe`.

### 4. End of Contest (Results)
When the Tabulator requests the final rankings from the dashboard, the server will automatically generate two result files in the directory where `pageant-server` is running:
*   `result.xml`: The raw data of the final scores.
*   `pageant_results.pdf`: A formatted PDF report suitable for printing.
