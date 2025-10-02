# Cross-platform Factorio Data Extraction Script
# PowerShell version for Windows
# Extracts Factorio data dumps for mod development and analysis

param(
    [string]$Path = "",
    [string]$Languages = "en",
    [switch]$Help
)

# Function to print colored output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Function to show help
function Show-Help {
    Write-Info "Factorio Data Extraction Script"
    Write-Info "================================"
    Write-Host ""
    Write-Host "Usage: .\extract-factorio-data.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Path PATH        Path to Factorio executable"
    Write-Host "  -Languages CODES  Comma-separated language codes (default: en)"
    Write-Host "  -Help            Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\extract-factorio-data.ps1"
    Write-Host "  .\extract-factorio-data.ps1 -Path 'C:\Program Files\Factorio\bin\x64\factorio.exe' -Languages 'en,de,fr'"
    Write-Host "  .\extract-factorio-data.ps1 -Path 'C:\Steam\steamapps\common\Factorio\bin\x64\factorio.exe' -Languages en"
}

# Function to find Factorio executable
function Find-FactorioExecutable {
    param([string]$ProvidedPath)
    
    if ($ProvidedPath) {
        if (Test-Path $ProvidedPath) {
            return $ProvidedPath
        } else {
            Write-Error "Provided Factorio path does not exist: $ProvidedPath"
            return $null
        }
    }
    
    # Common Windows locations
    $commonPaths = @(
        "C:\Program Files\Factorio\bin\x64\factorio.exe",
        "C:\Program Files (x86)\Steam\steamapps\common\Factorio\bin\x64\factorio.exe"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    Write-Error "Could not find Factorio executable. Please provide the path manually."
    return $null
}

# Function to validate language codes
function Test-LanguageCodes {
    param([string]$Codes)
    
    # Basic validation - should be comma-separated 2-letter codes
    if ($Codes -notmatch '^[a-z]{2}(,[a-z]{2})*$') {
        Write-Error "Invalid language codes format. Use comma-separated 2-letter codes (e.g., 'en,de,fr')"
        return $false
    }
    
    return $true
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-Info "Factorio Data Extraction Script"
Write-Info "================================"

# Get Factorio path if not provided
if (-not $Path) {
    Write-Info "Attempting to auto-detect Factorio installation..."
    $Path = Find-FactorioExecutable ""
    
    if (-not $Path) {
        Write-Info "Please provide the path to your Factorio executable:"
        $Path = Read-Host "Factorio executable path"
        
        if (-not $Path) {
            Write-Error "No Factorio path provided. Exiting."
            exit 1
        }
    }
} else {
    # Validate provided path
    $Path = Find-FactorioExecutable $Path
    if (-not $Path) {
        exit 1
    }
}

# Get language codes if using default
if ($Languages -eq "en") {
    Write-Info "Language codes not specified. Using default: en"
    Write-Info "You can specify multiple languages separated by commas (e.g., 'en,de,fr')"
    $userLanguages = Read-Host "Enter language codes [en]"
    if ($userLanguages) {
        $Languages = $userLanguages
    }
}

# Validate language codes
if (-not (Test-LanguageCodes $Languages)) {
    exit 1
}

Write-Success "Using Factorio executable: $Path"
Write-Success "Using language codes: $Languages"

# Run Factorio with data-dump parameters sequentially
Write-Info "Starting Factorio data extraction..."
Write-Info "This may take a few minutes depending on your system..."
Write-Info "Note: Factorio will output to its script output folder."

# Run the extractions sequentially (each command must be run separately)
try {
    Write-Info "Running --dump-data..."
    $process1 = Start-Process -FilePath $Path -ArgumentList "--dump-data" -Wait -PassThru -NoNewWindow
    if ($process1.ExitCode -ne 0) {
        Write-Error "Factorio --dump-data failed with exit code: $($process1.ExitCode)"
        exit 1
    }
    
    Write-Info "Running --dump-prototype-locale..."
    $process2 = Start-Process -FilePath $Path -ArgumentList "--dump-prototype-locale" -Wait -PassThru -NoNewWindow
    if ($process2.ExitCode -ne 0) {
        Write-Error "Factorio --dump-prototype-locale failed with exit code: $($process2.ExitCode)"
        exit 1
    }
    
    Write-Info "Running --dump-icon-sprites..."
    $process3 = Start-Process -FilePath $Path -ArgumentList "--dump-icon-sprites" -Wait -PassThru -NoNewWindow
    if ($process3.ExitCode -ne 0) {
        Write-Error "Factorio --dump-icon-sprites failed with exit code: $($process3.ExitCode)"
        exit 1
    }
    
    Write-Success "All Factorio data extractions completed successfully!"
    
    # Find Factorio's script output folder (usually in the same directory as the executable)
    $factorioDir = Split-Path -Parent $Path
    $scriptOutputDir = Join-Path $factorioDir "../../script-output"
    
    # Alternative locations to check
    $altLocations = @(
        Join-Path (Split-Path -Parent $factorioDir) "script-output"
        Join-Path $env:USERPROFILE ".factorio\script-output"
        Join-Path $env:USERPROFILE "Documents\My Games\Factorio\script-output"
        Join-Path $env:APPDATA "Factorio\script-output"
    )
    
    # Check if script-output exists in the factorio directory
    if (-not (Test-Path $scriptOutputDir)) {
        foreach ($altDir in $altLocations) {
            if (Test-Path $altDir) {
                $scriptOutputDir = $altDir
                break
            }
        }
    }
    
    if (Test-Path $scriptOutputDir) {
        Write-Info "Found Factorio script output directory: $scriptOutputDir"
        
        # Create data-dumps directory if it doesn't exist
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
        $projectRoot = Split-Path -Parent $scriptDir
        $dataDumpsDir = Join-Path $projectRoot "data-dumps"
        
        if (-not (Test-Path $dataDumpsDir)) {
            Write-Info "Creating data-dumps directory: $dataDumpsDir"
            New-Item -ItemType Directory -Path $dataDumpsDir -Force | Out-Null
        }
        
        # Copy files from script output to our organized directory
        Write-Info "Copying extracted files to: $dataDumpsDir"
        try {
            Copy-Item -Path "$scriptOutputDir\*" -Destination $dataDumpsDir -Recurse -Force
        } catch {
            Write-Warning "Some files may not have been copied: $($_.Exception.Message)"
        }
        
        # List extracted files
        Write-Info "Extracted files:"
        Get-ChildItem $dataDumpsDir | ForEach-Object { Write-Host "  $($_.Name)" }
        
        # Show directory size
        $size = (Get-ChildItem $dataDumpsDir -Recurse | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($size / 1MB, 2)
        Write-Info "Total size: $sizeMB MB"
        
        Write-Success "Data extraction completed successfully!"
        Write-Success "Output directory: $dataDumpsDir"
    } else {
        Write-Warning "Could not find Factorio script output directory."
        Write-Info "Please check the following locations manually:"
        Write-Info "  - $factorioDir\script-output"
        foreach ($altDir in $altLocations) {
            Write-Info "  - $altDir"
        }
    }
    
} catch {
    Write-Error "Failed to run Factorio: $($_.Exception.Message)"
    exit 1
}

Write-Success "Script completed successfully!"
Write-Info "You can now use the extracted data for mod development or analysis."
