# Installing Maestro on Windows

## Option 1: Direct Download (Recommended)

Visit the official Maestro releases page and download the latest Windows release:

**https://maestro.mobile.dev/docs/getting-started/maestro-cli**

Steps:
1. Go to the link above
2. Download `maestro-windows.zip`
3. Extract to `C:\tools\maestro` or your preferred location
4. Add to PATH:
   - Press `Win + X` → System
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Edit "Path" variable
   - Add: `C:\tools\maestro\bin` (or your maestro location)
5. Restart PowerShell
6. Verify: `maestro --version`

## Option 2: Docker (If Available)

If you have Docker installed:

```bash
docker run -it --rm mobile-dev-inc/maestro maestro --version
```

Then run tests:
```bash
docker run -it --rm --device /dev/kvm \
  -v "%cd%:/work" \
  mobile-dev-inc/maestro \
  maestro test /work/maestro/
```

## Option 3: Manual Installation from GitHub

1. Visit: https://github.com/mobile-dev-inc/maestro/releases
2. Download latest `maestro-windows.zip`
3. Extract to `C:\tools\maestro`
4. Add to PATH

## Option 4: Java-based Installation (If Java is installed)

```bash
# Install using Java
java -jar maestro-cli.jar install

# Or build from source
git clone https://github.com/mobile-dev-inc/maestro.git
cd maestro
./gradlew :cli:build
```

## Verify Installation

After installation, verify in PowerShell:

```bash
maestro --version
maestro device list
```

## Troubleshooting

### Maestro command not found

1. Verify installation location: `dir C:\tools\maestro\bin`
2. Check PATH: `echo $env:Path` (should include maestro path)
3. Restart terminal/IDE if PATH was modified
4. Try full path: `C:\tools\maestro\bin\maestro --version`

### PATH Not Updated

Add manually:
```powershell
$maestroPath = "C:\tools\maestro\bin"
$env:Path += ";$maestroPath"
[Environment]::SetEnvironmentVariable("Path", $env:Path, "User")
```

### Device Connection Issues

```bash
# List devices
maestro device list

# Check device status
maestro device info

# Restart device
maestro device shutdown
```

## Running Tests After Installation

Once Maestro is installed:

```bash
# Navigate to maestro directory
cd maestro

# Run all E2E tests
maestro test .

# Run specific test
maestro test 01_login_flow.yaml

# Run with recording
maestro test --record-on-failure .

# Run with specific device
maestro test --device <device-id> .
```

## Next Steps

1. Install Maestro using one of the options above
2. Verify with: `maestro --version`
3. Return to project and run: `cd maestro && maestro test .`

For more help: https://maestro.mobile.dev/
