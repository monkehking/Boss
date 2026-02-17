---
name: draw-things-automation
description: Automate image generation in Draw Things macOS app using Peekaboo CLI. Handles complete workflow - launching app, entering long prompts via paste method, triggering generation, and smart completion detection via file monitoring. Use when automating Draw Things image generation workflows, entering prompts over 120 characters, batch generating images, or monitoring generation progress without blind waiting.
---

# Draw Things Automation

Automated image generation for Draw Things macOS app using Peekaboo CLI.

## Quick Start

```bash
./scripts/generate.sh "Your prompt here"
```

## How It Works

This skill automates the Draw Things app workflow:

1. **Launch** - Brings Draw Things to foreground
2. **Focus** - Tabs to the prompt input field
3. **Clear** - Selects and deletes previous text
4. **Enter** - Pastes your prompt (handles long text)
5. **Generate** - Triggers Cmd+Enter to start
6. **Monitor** - Checks progress every 60 seconds

## The Paste Method

Draw Things has a character limit on the `type` command (~120 chars). This skill uses `paste` for longer prompts:

- **Short prompts (<120 chars)**: Uses `type` (direct keystrokes)
- **Long prompts (>120 chars)**: Uses `paste` (clipboard method)

## Requirements

- macOS with Draw Things app installed
- Peekaboo CLI: `/opt/homebrew/bin/peekaboo`
- Accessibility permissions granted to Terminal/Peekaboo
- Output folder configured in Draw Things settings

## Usage

### Basic Generation

```bash
./scripts/generate.sh "Portrait of a person, photorealistic, 8k"
```

### Long Cinematic Prompts

```bash
./scripts/generate.sh "Cinematic portrait at golden hour, warm orange light, city skyline background, shallow depth of field, photorealistic 8k quality"
```

### Batch Generation

Run the script multiple times with different prompts.

## Workflow Details

| Step | Action | Duration |
|------|--------|----------|
| 1 | Launch app | 2s |
| 2 | Focus prompt | Instant |
| 3 | Clear text | 1s |
| 4 | Enter prompt | 1s |
| 5 | Generate | Instant |
| 6 | Monitor | Until file appears (max 15 min) |

## Smart Completion Detection

The script monitors your output folder (`~/Desktop/Vanessa Draw Things Images/`) for new PNG files:

- **Before generation**: Counts existing images
- **During generation**: Checks every 5 seconds for new files
- **On completion**: Reports filename, file size, and elapsed time
- **Timeout**: 15 minutes (in case generation fails)

This is more efficient than blind waiting or screenshots—no CPU overhead, instant detection when the image is actually saved.

## Troubleshooting

**"Output directory not found" error?**
- The script expects images in `~/Desktop/Vanessa Draw Things Images/`
- Check Draw Things → Settings → Output folder location
- Update `OUTPUT_DIR` in the script if your location differs

**Timeout - no image detected?**
- Generation may have failed (check Draw Things window)
- Output folder may have changed in Draw Things settings
- File permissions issue—verify Terminal can read the folder
- Script times out after 15 minutes to prevent hanging

**Prompt gets cut off?**
- The script automatically uses `paste` for long prompts
- Verify prompt appears fully before generating

**App doesn't launch?**
- Check Draw Things is installed
- Verify Accessibility permissions for Terminal

**Generation fails?**
- Ensure Draw Things has required model downloaded
- Check disk space for output folder

## Script Reference

- `scripts/generate.sh` - Main automation script

## Tips

- Keep prompts under 500 characters for best results
- Use descriptive language: lighting, style, background
- The automation handles the technical steps - focus on creative prompts