# ComEd Price Monitor for KDE Plasma

A KDE Plasma widget (Plasmoid) that displays real-time hourly electricity pricing from ComEd (Commonwealth Edison).

Based on the [iOS Widget](https://github.com/robrepp/powerprice), this brings the same visualization to your Linux desktop.

## Features
- **Real-time Pricing**: Fetches data from ComEd's API every 5 minutes.
- **Hourly Average**: Displays the running average for the current hour.
- **Trend Indicators**: Shows if price is trending up or down.
- **Visual Tiers**: Background changes color based on price (Green < 8¢, Orange 8-14¢, Red > 14¢).
- **History Graph**: Bar chart showing the last hour of pricing history.

## Installation

### From Release (Easy)
1. Download `ComEdPrice.plasmoid` from the [Releases page](../../releases).
2. Run:
   ```bash
   kpackagetool5 --install ComEdPrice.plasmoid
   # OR for Plasma 6
   kpackagetool6 --install ComEdPrice.plasmoid
   ```
3. Right-click desktop > **Add Widgets** > Search for "ComEd Price".

### From Source
```bash
git clone https://github.com/robrepp/comed-plasma-widget.git
cd comed-plasma-widget
# Zip contents to .plasmoid
zip -r ComEdPrice.plasmoid *
# Install
kpackagetool6 --install ComEdPrice.plasmoid
```

## Requirements
- KDE Plasma 6.x (Tested on Neon)
- Internet connection (to fetch ComEd API)
