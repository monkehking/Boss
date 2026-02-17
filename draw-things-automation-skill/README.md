# Draw Things Automation Skill

Automated image generation for Draw Things macOS app with smart completion detection.

---

## What This Does

This skill automates the entire Draw Things AI image generation workflow:

1. **Launch** — Brings Draw Things to the foreground
2. **Focus** — Tabs to the prompt input field  
3. **Clear** — Removes previous prompt text
4. **Enter** — Pastes your prompt (handles long text automatically)
5. **Generate** — Triggers Cmd+Enter to start
6. **Smart Monitor** — Watches the output folder for the new image

---

## Smart Completion Detection

This skill uses **file monitoring** to detect when generation completes. Instead of waiting a fixed amount of time, it watches your output folder for new PNG files and reports immediately when the image is saved.

**Note:** You must configure your own folder path in the script. The script monitors a specific folder for new files — update `OUTPUT_DIR` in `scripts/generate.sh` to match your Draw Things output location.

**Tip:** It's a good idea to set your Draw Things output folder somewhere easily accessible like Desktop or Documents for convenience.

---

## Requirements

- macOS with Draw Things app installed
- Peekaboo CLI: `/opt/homebrew/bin/peekaboo`
- Accessibility permissions for Terminal/Peekaboo
- Output folder configured in Draw Things settings

---

## Installation

1. Copy this skill folder to your OpenClaw skills directory:
   ```bash
   cp -r draw-things-automation.skill ~/.openclaw/skills/draw-things-automation
   ```

2. Update the output folder path in the script:
   ```bash
   # Edit scripts/generate.sh and change:
   OUTPUT_DIR="$HOME/Desktop/Your Draw Things Images"
   ```

3. Make the script executable:
   ```bash
   chmod +x ~/.openclaw/skills/draw-things-automation/scripts/generate.sh
   ```

4. Install Peekaboo CLI if not already:
   ```bash
   brew install peekaboo
   ```

---

## Usage

### Basic Generation

```bash
cd ~/.openclaw/skills/draw-things-automation/scripts
./generate.sh "Your creative prompt here"
```

### Long Prompts (Auto-Handled)

Prompts over 120 characters automatically use the paste method:

```bash
./generate.sh "Cinematic portrait at golden hour, warm orange light filtering through window blinds, dust particles visible in light rays, vintage film grain, shallow depth of field, photorealistic 8k quality"
```

### Batch Generation

Run multiple times with different prompts, or chain them:

```bash
./generate.sh "First prompt" && ./generate.sh "Second prompt" && ./generate.sh "Third prompt"
```

---

## Output

```
🎨 DRAW THINGS AUTOMATION
=========================
Prompt: [your prompt]
Length: 217 characters

📁 Images in folder before: 32

[1/5] Launching Draw Things...
[2/5] Focusing prompt box...
[3/5] Clearing text...
[4/5] Entering prompt...
[5/5] Starting generation...

⏳ Monitoring output folder for new image...
   (Checking every 5 seconds, timeout after 15 minutes)

   [1m] Still generating...
   
✅ Generation complete!

📷 New image: your_prompt_filename_4127974000.png
📊 File size: 1.4M
🕐 Elapsed: 115 seconds
```

---

## Troubleshooting

**"Output directory not found" error?**
- Check Draw Things → Settings → Output folder location
- Update `OUTPUT_DIR` in the script to match your setup

**Timeout — no image detected?**
- Generation may have failed (check Draw Things window)
- Output folder path in the script may be incorrect
- File permissions issue — verify Terminal can read the folder

**Prompt gets cut off?**
- The script auto-uses `paste` for long prompts
- Verify prompt appears fully in Draw Things before generating

**App doesn't launch?**
- Check Draw Things is installed
- Verify Accessibility permissions for Terminal in System Settings

---

## How It Works

The script uses [Peekaboo CLI](https://github.com/openclaw/peekaboo) to control the Draw Things GUI:

- `peekaboo app launch "Draw Things"` — Opens/brings app to front
- `peekaboo paste "$PROMPT"` — Enters long text via clipboard
- `peekaboo hotkey "command,return"` — Triggers generation

Completion detection uses simple file counting — it compares the number of PNG files before and after generation to detect when a new image is saved.

---

## Created By

**Created by Boss and Vanessa**

This skill was developed as part of the OpenClaw agent ecosystem in February 2026. It uses intelligent file monitoring to detect completion instead of fixed-time waiting.

---

## License

Part of the OpenClaw project. Use freely, modify as needed.

---

**Enjoy your automated AI art generation!** 🎨✨
