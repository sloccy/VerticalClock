# Vertical Clock

A minimal fork of the KDE Plasma 6 digital clock (`org.kde.plasma.digitalclock`) that installs as a separate widget (`org.kde.plasma.verticalclock`) alongside the original.

## What's different

- **Vertical panel**: hours and minutes each fill a full row, sized to the panel width. AM/PM appears as an optional third row.
- **AM/PM toggle**: configure → Appearance → "Show AM/PM indicator row" (visible only in 12-hour mode).
- Everything else (calendar popup, timezones, event plugins, tooltip, clipboard, horizontal rendering) is byte-identical to the upstream digital clock.

## Setup (first time)

```bash
git clone https://github.com/sloccy/VerticalClock.git
cd VerticalClock
bash scripts/build.sh        # auto-inits submodule on first run, then assembles build/package/
```

## Install / update on your Fedora KDE machine

Every push to `main` builds a release zip automatically. On your Fedora box:

```bash
bash <(curl -fsSL https://github.com/sloccy/VerticalClock/raw/main/scripts/install-or-update.sh)
```

Or download and run the script manually:

```bash
curl -fL https://github.com/sloccy/VerticalClock/releases/latest/download/verticalclock.zip -o /tmp/verticalclock.zip
kpackagetool6 -t Plasma/Applet -u /tmp/verticalclock.zip || kpackagetool6 -t Plasma/Applet -i /tmp/verticalclock.zip
```

Then right-click your vertical panel → Add Widgets → search "Vertical Clock".

## Receiving upstream updates

Updates come in automatically (see [GitHub Actions](#github-actions)). To pull manually:

```bash
bash scripts/update-upstream.sh
```

## GitHub Actions

Two workflows live in `.github/workflows/`:

- **`ci.yml`** — runs on every push/PR; builds the package and checks overlay anchors.
- **`upstream-sync.yml`** — runs every Monday 07:00 UTC **and** has a "Run workflow" button in the GitHub Actions tab. When upstream changes, it opens a PR with an anchor-check status so you know whether the overlay needs manual review before merging.

### One-time setup after pushing to GitHub

1. Settings → Actions → General → Workflow permissions → **Read and write**
2. Settings → Actions → General → **Allow GitHub Actions to create and approve pull requests** ✓

## How the overlay works

```
upstream/applets/digital-clock/   ← plasma-workspace submodule
overlay/                          ← only the 4 files we changed
scripts/build.sh                  ← merge: upstream → build/package/ then overlay/ on top
```

Changed files (our entire diff):
| File | Change |
|---|---|
| `metadata.json` | New applet ID/name |
| `main.xml` | Added `showAmPmRow` config key |
| `DigitalClock.qml` | Vertical panel state: stacked layout |
| `configAppearance.qml` | AM/PM toggle checkbox |

## Dependencies

The C++ plugin (`org.kde.plasma.private.digitalclock`) ships with the system's `plasma-workspace` package — it is **not** included here and must be installed on the target machine (it is on any standard Fedora KDE install).
