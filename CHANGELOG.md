# Mkey Change Log

##### Version 0.0.2: (12/05/2026)
- Migrate menu bar to SwiftUI with MenuBarExtra.
- Set VNI as default input method.
- Increase menu bar icon to size 20 bold.
- Fix standalone `w` conversion skipped in Telex mode.
- Add ObjC MKeyGlobals/MKeyCallbacks bridge layer.
- Raise deployment target to macOS 13.
- Default "dấu tự do" enabled.
- Switch language hotkey: Cmd+Space → Ctrl+Space.
- Fix tone marks not applied after multi-syllable input when buffer has prior modifications.

##### Version 0.0.1: (12/05/2026)
- Fork from OpenKey — strip to Telex/VNI only.
- Remove Simple Telex, encoding options, spell check, convert tool, smart switch, info tab.
- Remove storyboard; minimal AppDelegate with cmd+space default switch key.
- Add SMAppService run-on-startup, TIS lang cache, smart app-change switch.
- Rename OpenKey → Mkey throughout (project, scheme, bundle ID, manager).
- Menu bar icon: V/E text, size 16 semibold; opens Accessibility settings on click.
- Flatten input type to top-level menu; remove Unicode item.
- Fix TIS thread-safety via cached vCurrentLang.
- Add missing `diu` pattern to consonantD table.
