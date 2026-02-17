#!/bin/bash
# Draw Things Automation - Smart Generation with File Monitoring
# Usage: ./generate.sh "Your prompt here"

PROMPT="${1:-A beautiful portrait, photorealistic}"
APP="Draw Things"
OUTPUT_DIR="$HOME/Desktop/Vanessa Draw Things Images"

# Validate output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "❌ Error: Output directory not found: $OUTPUT_DIR"
    echo "   Please check Draw Things settings and ensure images save to this location"
    exit 1
fi

echo "🎨 DRAW THINGS AUTOMATION"
echo "========================="
echo "Prompt: $PROMPT"
echo "Length: ${#PROMPT} characters"
echo ""

# Count existing files before generation
BEFORE_COUNT=$(ls -1 "$OUTPUT_DIR"/*.png 2>/dev/null | wc -l | tr -d ' ')
echo "📁 Images in folder before: $BEFORE_COUNT"
echo ""

# Launch
echo "[1/5] Launching $APP..."
/opt/homebrew/bin/peekaboo app launch "$APP" --json > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Failed to launch $APP. Is it installed?"
    exit 1
fi
sleep 2

# Focus
echo "[2/5] Focusing prompt box..."
/opt/homebrew/bin/peekaboo press tab --json > /dev/null 2>&1

# Clear
echo "[3/5] Clearing text..."
/opt/homebrew/bin/peekaboo hotkey "command,a" --json > /dev/null 2>&1
/opt/homebrew/bin/peekaboo press delete --json > /dev/null 2>&1
sleep 1

# Enter prompt
echo "[4/5] Entering prompt..."
if [ ${#PROMPT} -gt 120 ]; then
    /opt/homebrew/bin/peekaboo paste "$PROMPT" --json > /dev/null 2>&1
else
    /opt/homebrew/bin/peekaboo type "$PROMPT" --json > /dev/null 2>&1
fi
sleep 1

# Generate
echo "[5/5] Starting generation..."
/opt/homebrew/bin/peekaboo hotkey "command,return" --json > /dev/null 2>&1

echo ""
echo "⏳ Monitoring output folder for new image..."
echo "   (Checking every 5 seconds, timeout after 15 minutes)"
echo ""

# Smart completion detection - watch for new file
TIMEOUT=180  # 15 minutes = 180 checks × 5 seconds
CHECK=0
FOUND=0

while [ $CHECK -lt $TIMEOUT ]; do
    CHECK=$((CHECK + 1))
    
    # Count current PNG files
    AFTER_COUNT=$(ls -1 "$OUTPUT_DIR"/*.png 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$AFTER_COUNT" -gt "$BEFORE_COUNT" ]; then
        # New file detected!
        NEWEST_FILE=$(ls -t "$OUTPUT_DIR"/*.png 2>/dev/null | head -1)
        FILENAME=$(basename "$NEWEST_FILE")
        FILESIZE=$(du -h "$NEWEST_FILE" | cut -f1)
        
        echo "✅ Generation complete!"
        echo ""
        echo "📷 New image: $FILENAME"
        echo "📊 File size: $FILESIZE"
        echo "🕐 Elapsed: $((CHECK * 5)) seconds"
        echo ""
        FOUND=1
        break
    fi
    
    # Show progress every 30 seconds (6 checks)
    if [ $((CHECK % 6)) -eq 0 ]; then
        echo "   [$((CHECK * 5 / 60))m] Still generating..."
    fi
    
    sleep 5
done

if [ $FOUND -eq 0 ]; then
    echo "⚠️  Timeout: No new image detected after 15 minutes"
    echo "   Check Draw Things - generation may have failed or settings changed"
    exit 1
fi

exit 0
