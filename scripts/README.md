# Factorio Data Extraction Scripts

This directory contains cross-platform scripts to extract Factorio data dumps for mod development and analysis.

## Available Scripts

### Linux/macOS/Git Bash

- **`extract-factorio-data.sh`** - Bash script for Unix-like systems

### Windows

- **`extract-factorio-data.cmd`** - Batch script for Windows Command Prompt
- **`extract-factorio-data.ps1`** - PowerShell script for Windows (recommended)

## Usage

### Command Line Options

All scripts support the same command line options:

- `-p, --path PATH` - Path to Factorio executable
- `-l, --languages CODES` - Comma-separated language codes (default: en)
- `-h, --help` - Show help message

### Examples

#### Interactive Mode (Recommended)

```bash
# Linux/macOS/Git Bash
./extract-factorio-data.sh

# Windows Command Prompt
extract-factorio-data.cmd

# Windows PowerShell
.\extract-factorio-data.ps1
```

#### Command Line Mode

```bash
# Linux/macOS/Git Bash
./extract-factorio-data.sh -p /usr/games/factorio -l en,de,fr

# Windows Command Prompt
extract-factorio-data.cmd -p "C:\Program Files\Factorio\bin\x64\factorio.exe" -l en,de,fr

# Windows PowerShell
.\extract-factorio-data.ps1 -Path "C:\Program Files\Factorio\bin\x64\factorio.exe" -Languages "en,de,fr"
```

## What the Scripts Do

1. **Auto-detect Factorio installation** - Searches common installation paths
2. **Prompt for missing information** - Asks for Factorio path and language codes if not provided
3. **Run Factorio data extraction sequentially** - Executes three separate Factorio commands:
   - `--dump-data` - Exports data.raw as JSON
   - `--dump-prototype-locale` - Exports prototype names and descriptions
   - `--dump-icon-sprites` - Exports all icon sprites as PNG files
4. **Find output** - Locates Factorio's script output folder
5. **Report results** - Shows extracted files and directory size

## Output

The scripts copy files directly to the `data-dumps/` folder:

```
data-dumps/
├── data.raw.json
├── prototype-locale/
│   ├── en.cfg
│   ├── de.cfg
│   └── ...
└── icon-sprites/
    ├── item/
    ├── entity/
    └── ...
```

**Note:** Factorio outputs to its default `script-output` folder, then the scripts copy the files to the `data-dumps/` directory for better file management.

## Language Codes

Supported language codes include:

- `en` - English
- `de` - German
- `fr` - French
- `es` - Spanish
- `ru` - Russian
- `zh` - Chinese
- And many more...

Use comma-separated codes for multiple languages: `en,de,fr`

## Requirements

- **Factorio** - Must be installed and accessible
- **Bash** - For the `.sh` script (available on Linux, macOS, Git Bash on Windows)
- **Command Prompt** - For the `.cmd` script (available on all Windows systems)
- **PowerShell** - For the `.ps1` script (available on Windows 7+ and modern systems)

## Troubleshooting

### "Could not find Factorio executable"

- Provide the full path to your Factorio executable using the `-p` or `--path` option
- Common paths:
  - Windows: `C:\Program Files\Factorio\bin\x64\factorio.exe`
  - Linux: `/usr/games/factorio`
  - Steam: Check your Steam installation directory

### "Invalid language codes format"

- Use 2-letter language codes separated by commas
- Example: `en,de,fr` (not `english,german,french`)

### Permission Issues (Windows)

- Run Command Prompt or PowerShell as Administrator if needed
- For PowerShell, you may need to set execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Notes

- The `data-dumps/` directory is automatically added to `.gitignore`
- Each extraction creates a new timestamped directory
- The extraction process may take several minutes depending on your system
- Factorio runs in headless mode during extraction
