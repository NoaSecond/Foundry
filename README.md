# StarDeception - Foundry

<div align="center">
  <img src="Foundry Logo.svg" alt="StarDeception - Foundry Logo" width="150" height="150">
</div>

Simple interactive script to manage StarDeception game servers.

<div align="center">
  
[![GitHub](https://img.shields.io/badge/GitHub-NoaSecond%2FFoundry-blue?style=flat-square&logo=github)](https://github.com/NoaSecond/Foundry)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-5.0+-brightgreen?style=flat-square&logo=gnu-bash)](https://www.gnu.org/software/bash/)

</div>

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/NoaSecond/Foundry.git
```

### 2. Go in the right folder
```bash
cd ./Foundry
```

### 3. Run the Manager
```bash
sudo bash Foundry.sh
```

The script will automatically handle the dedicated server binary download when needed.

## 🔧 Requirements

- Bash shell (Linux/WSL/macOS)
- `wget` or `curl` (for binary downloads)
- Write permissions in the directory

That's it! The script handles everything else for you.

### Permission Error
If you get a "Permission denied" error:
```bash
chmod +x Foundry.sh
chmod +x scripts/*.sh
chmod +x src/StarDeception.dedicated_server.sh
```

### Identifier Error
If the identifier is not valid:
- Make sure it contains exactly 2 digits (e.g., 01, 12, 99)
- Letters and special characters are not allowed

---

## 📄License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Contributor

**Foundry developed by [𝕭𝖗𝖚𝖒𝖊](https://noasecond.com)**
