# Zathura as default PDF handler on macOS

Zathura is a CLI tool installed via Homebrew — no `.app` bundle, no bundle identifier. macOS Launch Services requires both to register a default file-type handler. The fix is a minimal wrapper bundle.

---

## 1. Create the `.app` bundle

```
/Applications/Zathura.app/
  Contents/
    Info.plist
    MacOS/
      Zathura        ← shell script
    Resources/
      zathura.icns   ← optional custom icon
```

```bash
mkdir -p /Applications/Zathura.app/Contents/MacOS
mkdir -p /Applications/Zathura.app/Contents/Resources
```

`Contents/MacOS/Zathura`:

```bash
#!/bin/bash
exec /opt/homebrew/bin/zathura "$@"
```

```bash
chmod +x /Applications/Zathura.app/Contents/MacOS/Zathura
```

`Contents/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>org.pwmt.zathura</string>
    <key>CFBundleName</key>
    <string>Zathura</string>
    <key>CFBundleExecutable</key>
    <string>Zathura</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>0.5.11</string>
    <key>CFBundleIconFile</key>
    <string>zathura</string>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeName</key>
            <string>PDF Document</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Owner</string>
            <key>LSItemContentTypes</key>
            <array>
                <string>com.adobe.pdf</string>
            </array>
        </dict>
    </array>
    <key>UTImportedTypeDeclarations</key>
    <array>
        <dict>
            <key>UTTypeIdentifier</key>
            <string>com.adobe.pdf</string>
            <key>UTTypeConformsTo</key>
            <array>
                <string>public.data</string>
            </array>
            <key>UTTypeTagSpecification</key>
            <dict>
                <key>public.filename-extension</key>
                <array>
                    <string>pdf</string>
                </array>
                <key>public.mime-type</key>
                <string>application/pdf</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>
```

---

## 2. Add a custom icon (optional)

Start from any PNG (512×512 or larger). Convert to `.icns`:

```bash
mkdir -p /tmp/zathura.iconset
for size in 16 32 128 256 512; do
  sips -z $size $size icon.png --out /tmp/zathura.iconset/icon_${size}x${size}.png
  sips -z $((size*2)) $((size*2)) icon.png --out /tmp/zathura.iconset/icon_${size}x${size}@2x.png
done
iconutil -c icns /tmp/zathura.iconset -o /Applications/Zathura.app/Contents/Resources/zathura.icns
```

`CFBundleIconFile` in `Info.plist` (already included above) points to the filename without extension.

---

## 3. Register with Launch Services

```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
  -f /Applications/Zathura.app
```

---

## 4. Set as default handler

```bash
brew install duti
duti -s org.pwmt.zathura com.adobe.pdf all
```

Verify:

```bash
duti -x pdf
# Zathura
# /Applications/Zathura.app
# org.pwmt.zathura
```

---

## 5. Force Finder to refresh icon cache (if icon doesn't update)

```bash
sudo rm -rf /Library/Caches/com.apple.iconservices.store && sudo killall Finder
```
