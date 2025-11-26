# Copilot Instructions for MondaineFace

## Project Overview
MondaineFace is a Garmin Connect IQ watchface that mimics the classic Swiss railway station clock (Mondaine design). Built using Monkey C language for Garmin wearable devices.

## Architecture & Key Components

### Core Structure
- `source/MondaineFaceApp.mc` - Main application entry point extending `Application.AppBase`
- `source/MondaineFaceView.mc` - Watch face rendering logic extending `WatchUi.WatchFace`
- `manifest.xml` - Device compatibility and app metadata (auto-generated, use VS Code commands to edit)
- `monkey.jungle` - Build configuration file
- `resources/` - Static assets (strings, drawables, layouts)

### Watch Face Rendering Pattern
The `MondaineFaceView` follows Garmin's standard lifecycle:
1. `onLayout(dc)` - Initialize screen dimensions and center coordinates
2. `onUpdate(dc)` - Main rendering loop with layered drawing order:
   - Clear background to white
   - Draw tick marks (`drawTicks()`)
   - Draw activity alerts (`drawMoveAlert()`) 
   - Draw watch hands in order: hour → minute → second

### Power Management
- `isAwake` state variable controls second hand visibility
- `onEnterSleep()`/`onExitSleep()` manage low-power mode
- Second hand (red) hidden during sleep to conserve battery

### Drawing Conventions
- **Coordinate System**: Center-based using `centerX`, `centerY`
- **Angles**: Degrees converted to radians, 0° = 12 o'clock position
- **Color Scheme**: White background, black hands/ticks, red second hand and alerts
- **Tick Marks**: 60 total - major ticks every 5 positions (hours), minor ticks for minutes

## Key Functions & Patterns

### Hand Drawing Pattern
All hand functions follow same signature: `(dc, angleDeg, lengthPercent, width, color)`
- Use trigonometry for positioning: `Math.sin(angleRad)`, `Math.cos(angleRad)`
- Include tail extensions behind center for authentic clock appearance
- Center dot overlay for hand pivot point

### Activity Integration
- Uses `ActivityMonitor.getInfo().moveBarLevel` for fitness alerts
- Red blocks indicate inactivity periods (1-5 levels)
- Positioned in bottom half to avoid hand overlap

## Development Workflow

### Building & Testing
- Use VS Code Monkey C extension commands (Ctrl+Shift+P):
  - "Monkey C: Build for Device" 
  - "Monkey C: Run Without Installing"
- Target device: Forerunner 165 (fr165) - see `manifest.xml`
- Output files generated in `bin/` and `output/` directories

### Resource Management
- **DO NOT** manually edit `manifest.xml` - use VS Code commands
- SVG assets in `resources/drawables/` for scalable icons
- String externalization in `resources/strings/strings.xml`

### Code Style Conventions
- Import statements grouped by Toybox modules
- Class names use PascalCase matching file names
- Function parameters typed explicitly: `(dc as Dc)`
- Screen dimensions calculated once in `onLayout()`, reused in drawing functions

## Common Modifications

### Adjusting Visual Elements
- **Tick spacing**: Modify `radius` calculation in `drawTicks()` (currently `screenWidth/2 - 15`)
- **Hand lengths**: Adjust `lengthPercent` parameters (hour: 60%, minute: 90%, second: 70%)
- **Colors**: Use `Graphics.COLOR_*` constants consistently

### Performance Considerations
- Minimize calculations in `onUpdate()` - pre-compute in `onLayout()` when possible
- Use `isAwake` checks for battery-intensive features like second hand
- Consider `WatchUi.requestUpdate()` frequency for smooth vs. efficient updates

## File Dependencies
- All `.mc` files auto-import Toybox modules as needed
- Resource references use `@Strings.AppName`, `@Drawables.LauncherIcon` syntax
- Build system handles compilation order and resource linking automatically